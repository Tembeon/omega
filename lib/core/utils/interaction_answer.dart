import 'package:nyxx/nyxx.dart';

extension InteractionAnswer<T> on MessageResponse<T> {

  /// Answers to the interaction with the provided [builder].
  ///
  /// If the response was already sent, creates a followup message. \
  /// If followup message was created, returns [Message].
  Future<Message?> answer(MessageBuilder builder, {bool? isEphemeral}) async {
    try {
      await respond(builder, isEphemeral: isEphemeral);
      return null;
      // nyxx doesn't provide a way to get `_didRespond` field, so we can't check if the response was already sent
      // ignore: avoid_catching_errors
    } on AlreadyRespondedError {
      final message = await createFollowup(builder, isEphemeral: isEphemeral);
      return message;
    }
  }
}
