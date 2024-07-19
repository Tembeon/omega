import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/remote.dart';
import 'package:l/l.dart';
import 'package:nyxx/nyxx.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../core/const/command_exceptions.dart';
import '../../core/utils/database/tables/posts.dart';
import '../../core/utils/services.dart';
import '../promoter/promoter.dart';
import 'data/models/register_activity.dart';
import 'message_handler.dart';

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
    User user, {
    bool fromCreate = false,
  });

  /// Removes member from LFG.
  Future<void> removeMemberFrom(Message message, User user);
}

/// {@macro ILFGManager}
final class LFGManager implements ILFGManager {
  /// {@macro ILFGManager}
  LFGManager({
    required PostsDatabase database,
    required IMessageHandler messageHandler,
    required Promoter promoter,
  })  : _database = database,
        _messageHandler = messageHandler,
        _promoter = promoter;

  /// Database used for storing LFG posts.
  final PostsDatabase _database;

  /// Discord LFG message handler.
  final IMessageHandler _messageHandler;

  /// Promoter for notifying about new LFG posts.
  final Promoter _promoter;

  @override
  Future<void> create({
    required LFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  }) async {
    // for first, we need to create post on discord and get messageID of LFG
    final discordLfgPost = await _messageHandler.createPost(
      builder: builder,
      interaction: interaction,
    );
    try {
      // Now we can create post in database
      final dbPost = PostsTableCompanion.insert(
        title: builder.name,
        description: builder.description,
        date: DateTime.fromMillisecondsSinceEpoch(builder.unixDate),
        timezone: builder.timezone,
        author: builder.authorID.value,
        postMessageId: (discordLfgPost.id.value),
        maxMembers: builder.maxMembers,
      );

      await _database.insertPost(dbPost);
      await addMemberTo(discordLfgPost, interaction.interaction.member!.user!, fromCreate: true);

      Services.i.postScheduler.schedulePost(
        startTime: dbPost.date.value,
        postID: dbPost.postMessageId.value,
      );

      _promoter.notifyAboutLFG(builder, discordLfgPost.id).ignore();
    } on Object catch (e) {
      l.e('[LFGManager] Error while creating LFG post. Deleting original post\n$e');
      // if something went wrong, we need to delete post from discord
      await _messageHandler.deletePost(discordLfgPost);

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

    print('[LFGManager] Deleting post with id $id from database');
    await _database.deletePost(id);

    print('[LFGManager] Deleting post with id $id');
    await (channel as GuildTextChannel).messages.fetch(Snowflake(post.postMessageId)).then((value) => value.delete());

    print('[LFGManager] Unsheduling post with id $id');
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

    await _messageHandler.updatePost(
      message,
      description: description,
      unixTime: unixTime,
    );

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
    User user, {
    bool fromCreate = false,
  }) async {
    // for first, check if post exists
    final post = await _database.findPost(message.id.value);
    if (post == null) throw CantRespondException('LFG ${message.id.value} не найден');

    // check if user is author of LFG. Author cannot join their own LFG
    if (post.author == user.id.value && !fromCreate) throw const AlreadyJoinedException();

    // check if max members is reached
    final membersIDS = await _database.getMembersForPost(message.id.value);

    // check if user is already joined
    if (membersIDS.contains(user.id.value)) throw const AlreadyJoinedException();

    final members = List<String>.generate(membersIDS.length + 1, (index) => '$index gen');

    if (membersIDS.length >= post.maxMembers) throw const TooManyPlayersException();

    // all good, add user to database
    await _database.addMember(message.id.value, user.id.value);

    final botCore = Services.i.bot;
    for (int index = 0; index < membersIDS.length; index++) {
      final user = await botCore.users.fetch(Snowflake(membersIDS[index]));
      members[index] = user.globalName ?? user.username;
    }

    // add user to message (visible part, not database)
    members.last = user.globalName ?? user.username;

    await _messageHandler.updatePost(
      message,
      newMembers: members,
      maxMembers: post.maxMembers,
    );
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
    for (int index = 0; index < membersIDS.length; index++) {
      final user = await botCore.users.fetch(Snowflake(membersIDS[index]));
      members[index] = user.globalName ?? user.username;
    }

    await _messageHandler.updatePost(
      message,
      newMembers: members,
      maxMembers: post.maxMembers,
    );
  }
}
