import 'dart:async';

import 'package:nyxx/nyxx.dart';

import 'data/models/register_activity.dart';

/// Interface for Discord message handler.
///
/// It handles LFG messages sends by bot.
abstract interface class IMessageHandler {
  /// Creates new LFG post.
  ///
  /// Returns ID of the message.
  FutureOr<Snowflake> createPost({
    required ILFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  });

  /// Updates existing LFG post.
  FutureOr<void> updatePost(ILFGPost post);

  /// Deletes existing LFG post.
  FutureOr<void> deletePost(ILFGPost post);
}

/// Discord message handler.
final class MessageHandler implements IMessageHandler {
  const MessageHandler();

  @override
  FutureOr<Snowflake> createPost({
    required ILFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  }) async {
    final msg = await interaction.interaction.respond(
      MessageBuilder(
        content: 'Raid ${builder.name} created;\n'
            'Meta:\n'
            '${builder.toString()}',
      ),
    );

    return Snowflake(0);
  }

  @override
  FutureOr<void> deletePost(ILFGPost post) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updatePost(ILFGPost post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}
