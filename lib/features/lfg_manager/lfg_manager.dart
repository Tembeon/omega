import 'dart:async';

import 'package:nyxx/nyxx.dart';

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
  FutureOr<ILFGPost> delete(int id);

  /// Reads existing LFG.
  FutureOr<ILFGPost> read(int id);
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
    final discordLfgPostID = await _messageHandler.createPost(
      builder: builder,
      interaction: interaction,
    );

    // Now we can create post in database
    final dbPost = PostsTableCompanion.insert(
      title: builder.name,
      description: builder.description,
      date: DateTime.fromMillisecondsSinceEpoch(builder.unixDate),
      author: builder.authorID.value,
      postMessageId: discordLfgPostID.value,
      maxMembers: builder.maxMembers,
    );

    final dbID = await _database.insertPost(dbPost);

    // save to memory post time, which will be used to notify users about LFG
    _posts[dbID] = dbPost.date.value;

    // return LFGPost
    return LFGPost.fromBuilder(
      builder,
      id: dbID,
      members: [builder.authorID],
      messageID: discordLfgPostID,
    );
  }

  @override
  FutureOr<ILFGPost> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  FutureOr<ILFGPost> read(int id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  FutureOr<ILFGPost> update(ILFGPostBuilder builder) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
