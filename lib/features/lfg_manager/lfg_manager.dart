import 'dart:async';

import 'package:nyxx/nyxx.dart';

import '../../core/bot/core.dart';
import '../../core/const/command_exceptions.dart';
import '../../core/utils/context/context.dart';
import '../../core/utils/database/tables/posts.dart';
import 'data/models/register_activity.dart';
import 'message_handler.dart';

/// LFG Manager interface.
abstract interface class ILFGManager {
  const ILFGManager();

  /// Creates new LFG.
  FutureOr<ILFGPost> create({
    required ILFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  });

  /// Updates existing LFG.
  FutureOr<ILFGPost> update(ILFGPostBuilder builder);

  /// Deletes existing LFG.
  FutureOr<ILFGPost> delete(Snowflake id);

  /// Reads existing LFG.
  FutureOr<ILFGPost> read(Snowflake id);

  /// Adds new member to LFG.
  FutureOr<void> addMemberTo(
    Message message,
    User user, {
    bool fromCreate = false,
  });

  /// Removes member from LFG.
  FutureOr<void> removeMemberFrom(Message message, User user);
}

final class LFGManager implements ILFGManager {
  LFGManager({
    required PostsDatabase database,
    required IMessageHandler messageHandler,
  })  : _database = database,
        _messageHandler = messageHandler;

  /// Database used for storing LFG posts.
  final PostsDatabase _database;

  /// Discord LFG message handler.
  final IMessageHandler _messageHandler;

  /// Map of all LFG posts.
  ///
  /// Value is the date of the post. \
  /// Key is the ID of the post in database.
  final Map<int, DateTime> _posts = {};

  @override
  FutureOr<ILFGPost> create({
    required ILFGPostBuilder builder,
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
        author: builder.authorID.value,
        postMessageId: (discordLfgPost.id.value),
        maxMembers: builder.maxMembers,
      );

      final dbID = await _database.insertPost(dbPost);
      await addMemberTo(discordLfgPost, interaction.interaction.member!.user!, fromCreate: true);

      // save to memory post time, which will be used to notify users about LFG
      _posts[dbID] = dbPost.date.value;

      // return LFGPost
      return LFGPost.fromBuilder(
        builder,
        id: dbID,
        members: [builder.authorID],
        messageID: discordLfgPost.id,
      );
    } on Object {
      // if something went wrong, we need to delete post from discord
      await _messageHandler.deletePost(discordLfgPost);
      rethrow;
    }
  }

  @override
  FutureOr<ILFGPost> delete(Snowflake id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  FutureOr<ILFGPost> read(Snowflake id) {
    throw UnimplementedError();
  }

  @override
  FutureOr<ILFGPost> update(ILFGPostBuilder builder) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addMemberTo(
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

    final botCore = Context.root.get<LFGBotCore>('core');
    for (int index = 0; index < membersIDS.length; index++) {
      final user = await botCore.bot.users.fetch(Snowflake(membersIDS[index]));
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
  FutureOr<void> removeMemberFrom(Message message, User user) async {
    // for first, check if post exists
    final post = await _database.findPost(message.id.value);
    if (post == null) throw CantRespondException('LFG ${message.id.value} не найден');

    // check if user is LFG creator. Creator cannot leave their own LFG
    if (post.author == user.id.value) throw const CreatorCannotLeaveException();

    final removedUsers = await _database.removeMember(message.id.value, user.id.value);
    if (removedUsers == 0) throw const NotJoinedException();

    final membersIDS = await _database.getMembersForPost(message.id.value);
    final members = List<String>.generate(membersIDS.length, (index) => '$index gen');

    final botCore = Context.root.get<LFGBotCore>('core');
    for (int index = 0; index < membersIDS.length; index++) {
      final user = await botCore.bot.users.fetch(Snowflake(membersIDS[index]));
      members[index] = user.globalName ?? user.username;
    }

    await _messageHandler.updatePost(
      message,
      newMembers: members,
      maxMembers: post.maxMembers,
    );
  }
}
