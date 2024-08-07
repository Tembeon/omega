import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/remote.dart';
import 'package:l/l.dart';
import 'package:nyxx/nyxx.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../core/const/command_exceptions.dart';
import '../../core/data/models/taken_roles.dart';
import '../../core/utils/database/tables/posts.dart';
import '../../core/utils/services.dart';
import '../components/buttons/role_picker/role_picker_component.dart';
import '../promoter/promoter.dart';
import 'data/models/register_activity.dart';
import 'lfg_message_builder.dart';

/// {@template ILFGManager}
/// Manager for LFG posts.
///
/// Used for creating, updating, deleting and reading LFG posts both in database and discord.
/// {@endtemplate}
abstract interface class ILFGManager {
  /// {@macro ILFGManager}
  const ILFGManager();

  /// Creates new LFG.
  Future<void> create({
    required LFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  });

  /// Updates existing LFG.
  Future<void> update(
    Message message, {
    final String? description,
    final int? unixTime,
  });

  /// Deletes existing LFG.
  Future<void> delete(int id);

  /// Adds new member to LFG.
  Future<void> addMemberTo(
    Message message,
    Member user, {
    bool fromCreate = false,
    Future<String?> Function()? rolePicker,
  });

  /// Removes member from LFG.
  Future<void> removeMemberFrom(Message message, User user);
}

/// {@macro ILFGManager}
final class LFGManager implements ILFGManager {
  /// {@macro ILFGManager}
  LFGManager({
    required PostsDatabase database,
    required LfgMessageBuilder lfgBuilder,
    required Promoter promoter,
  })  : _database = database,
        _lfgBuilder = lfgBuilder,
        _promoter = promoter;

  /// Database used for storing LFG posts.
  final PostsDatabase _database;

  /// Discord LFG message handler.
  final LfgMessageBuilder _lfgBuilder;

  /// Promoter for notifying about new LFG posts.
  final Promoter _promoter;

  @override
  Future<void> create({
    required LFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  }) async {
    final Services services = Services.i;
    final withRoles = builder.activity.roles != null;
    final Completer<String?> selectedRole = Completer();

    if (withRoles) {
      final customID = 'role_picker_author_${interaction.interaction.member!.user!.id.value}';
      final roleBuilder = await RolePickerComponent.builder(
        activityData: builder.activity,
        customID: customID,
      );

      await interaction.interaction.respond(roleBuilder, isEphemeral: true);
      services.interactor.subscribeToComponent(
        customID: customID,
        onTimeout: () {
          if (!selectedRole.isCompleted) {
            selectedRole.completeError(
              TimeoutException(
                'Превышено время ожидания выбора роли',
              ),
            );
          }
        },
        handler: (interaction) async {
          if (selectedRole.isCompleted) return;
          final role = interaction.interaction.data.values!.first;
          selectedRole.complete(role);

          await interaction.interaction.respond(
            MessageBuilder(content: 'Выбрана роль: $role'),
            isEphemeral: true,
          );
        },
      );

      await selectedRole.future;
    } else {
      selectedRole.complete(null);
    }

    Map<List<String>, TakenRoles>? authorRole;
    if (withRoles) {
      final role = await selectedRole.future;
      final targetRole = builder.activity.roles!.firstWhere((element) => element.role == role);
      final memberName = interaction.interaction.member?.nick ??
          interaction.interaction.member?.user?.globalName ??
          interaction.interaction.member!.user!.username;

      authorRole = {
        [memberName]: TakenRoles(
          role: targetRole.role,
          taken: 1,
          total: targetRole.quantity,
        ),
      };
    }

    final discordLfgPostBuilder = await _lfgBuilder.build(builder, authorRole: authorRole);

    final Message discordLfgPost;
    if (withRoles) {
      discordLfgPost = await interaction.interaction.createFollowup(discordLfgPostBuilder);
    } else {
      await interaction.interaction.respond(discordLfgPostBuilder);
      discordLfgPost = await interaction.interaction.fetchOriginalResponse();
    }

    try {
      // Now we can create post in database
      final dbPost = PostsTableCompanion.insert(
        title: builder.activity.name,
        description: builder.description,
        date: DateTime.fromMillisecondsSinceEpoch(builder.unixDate),
        timezone: builder.timezone,
        author: builder.authorID.value,
        postMessageId: (discordLfgPost.id.value),
        maxMembers: builder.activity.maxMembers,
      );

      await _database.insertPost(dbPost);
      await addMemberTo(
        discordLfgPost,
        interaction.interaction.member!,
        fromCreate: true,
        rolePicker: () => selectedRole.future,
      );

      Services.i.postScheduler.schedulePost(
        startTime: dbPost.date.value,
        postID: dbPost.postMessageId.value,
      );

      _promoter.notifyAboutLFG(builder, discordLfgPost.id).ignore();
    } on Object catch (e) {
      l.e('[LFGManager] Error while creating LFG post. Deleting original post\n$e');
      // if something went wrong, we need to delete post from discord
      await _lfgBuilder.deletePost(discordLfgPost);

      if (e is! SqliteException && e is! DriftRemoteException) {
        rethrow;
      }
    }
  }

  @override
  Future<void> delete(int id) async {
    final post = await _database.findPost(id);
    if (post == null) throw CantRespondException('LFG $id не найден');

    final bot = Services.i.bot;
    final settings = Services.i.settings;
    final lfgChannel = await settings.getLFGChannel();
    if (lfgChannel == null) throw const CantRespondException('Канал LFG не настроен');

    final channel = await bot.channels.fetch(Snowflake(lfgChannel));
    if (channel.type != ChannelType.guildText) {
      throw CantRespondException(
        'Канал LFG не найден или настроен неправильно\n'
        'ID: $lfgChannel',
      );
    }

    l.i('[LFGManager] Deleting post with id $id from database');
    await _database.deletePost(id);

    l.i('[LFGManager] Deleting post with id $id');
    await (channel as GuildTextChannel).messages.fetch(Snowflake(post.postMessageId)).then((value) => value.delete());

    l.i('[LFGManager] Unsheduling post with id $id');
    Services.i.postScheduler.cancelPost(postID: id);
  }

  @override
  Future<void> update(
    Message message, {
    final String? description,
    final int? unixTime,
  }) async {
    final post = await _database.findPost(message.id.value);
    if (post == null) throw CantRespondException('LFG ${message.id.value} не найден');

    await _database.updatePost(
      post.postMessageId,
      PostsTableCompanion(
        date: Value(unixTime != null ? DateTime.fromMillisecondsSinceEpoch(unixTime) : post.date),
        description: Value(description ?? post.description),
      ),
    );

    final updated = await _lfgBuilder.update(
      message,
      description: description,
      unixTime: unixTime,
    );

    await message.edit(updated);

    if (unixTime != null) {
      Services.i.postScheduler.editTime(
        postID: post.postMessageId,
        newTime: DateTime.fromMillisecondsSinceEpoch(unixTime),
      );
    }
  }

  @override
  Future<void> addMemberTo(
    Message message,
    Member user, {
    bool fromCreate = false,
    Future<String?> Function()? rolePicker,
  }) async {
    // for first, check if post exists
    final post = await _database.findPost(message.id.value);
    if (post == null) throw CantRespondException('LFG ${message.id.value} не найден');

    // check if max members is reached
    final membersIDS = await _database.getMembersForPost(message.id.value);

    // check if user is already joined
    if (membersIDS.contains(user.id.value)) throw const AlreadyJoinedException();

    final members = List<String>.generate(membersIDS.length + 1, (index) => '$index gen');

    if (membersIDS.length >= post.maxMembers) throw const TooManyPlayersException();

    final activityOrigin = await Services.i.settings.getActivity(post.title);
    if (activityOrigin.roles != null) {
      final role = await rolePicker?.call();
      if (role == null) throw const CantRespondException('Роль не выбрана');
      await _database.addMember(message.id.value, user.id.value, role: role);
    } else {
      await _database.addMember(message.id.value, user.id.value);
    }

    final botCore = Services.i.bot;
    final membersManager = botCore.guilds[Services.i.config.server].members;
    for (int index = 0; index < membersIDS.length; index++) {
      final member = await membersManager.get(Snowflake(membersIDS[index]));
      members[index] = member.nick ?? member.user!.globalName ?? member.user!.username;
    }

    // add user to message (visible part, not database)
    members.last = user.nick ?? user.user!.globalName ?? user.user!.username;

    final updated = await _lfgBuilder.update(
      message,
      newMembers: members,
      maxMembers: post.maxMembers,
    );

    await message.edit(updated);
  }

  @override
  Future<void> removeMemberFrom(Message message, User user) async {
    // for first, check if post exists
    final post = await _database.findPost(message.id.value);
    if (post == null) throw CantRespondException('LFG ${message.id.value} не найден');

    // check if user is LFG creator. Creator cannot leave their own LFG
    if (post.author == user.id.value) throw const CreatorCannotLeaveException();

    final removedUsers = await _database.removeMember(message.id.value, user.id.value);
    if (removedUsers == 0) throw const NotJoinedException();

    final membersIDS = await _database.getMembersForPost(message.id.value);
    final members = List<String>.generate(membersIDS.length, (index) => '$index gen');

    final botCore = Services.i.bot;
    final membersManager = botCore.guilds[Services.i.config.server].members;
    for (int index = 0; index < membersIDS.length; index++) {
      final member = await membersManager.get(Snowflake(membersIDS[index]));
      members[index] = member.nick ?? member.user!.globalName ?? member.user!.username;
    }

    final updated = await _lfgBuilder.update(
      message,
      newMembers: members,
      maxMembers: post.maxMembers,
    );

    await message.edit(updated);
  }
}
