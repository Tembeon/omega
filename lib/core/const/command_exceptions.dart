import '../l10n/messages.dart';

/// Exceptions thrown by commands. Used to display human-readable messages.
///
/// All exceptions should be caught by the command handler and sends to the user.
sealed class CommandException implements Exception {
  const CommandException();

  String toHumanMessage();
}

/// Exception thrown when a command is executed with too many players in the activity.
class TooManyPlayersException implements CommandException {
  const TooManyPlayersException();

  @override
  String toHumanMessage() => tooManyPlayersMessage;
}

/// Exception thrown when a creator tries to leave their own activity.
class CreatorCannotLeaveException implements CommandException {
  const CreatorCannotLeaveException();

  @override
  String toHumanMessage() => creatorCannotLeaveMessage;
}

/// Exception thrown when a player tries to join an activity they are already in.
class AlreadyJoinedException implements CommandException {
  const AlreadyJoinedException();

  @override
  String toHumanMessage() => alreadyJoinedMessage;
}

/// Exception thrown when a player tries to leave an activity they are not in.
class NotJoinedException implements CommandException {
  const NotJoinedException();

  @override
  String toHumanMessage() => notJoinedMessage;
}

/// Exception thrown when a command is executed by a player who is not the creator.
class NotCreatorException implements CommandException {
  const NotCreatorException();

  @override
  String toHumanMessage() => notCreatorMessage;
}

/// Exception thrown when a command triggered, but bot refused to respond.
class CantRespondException implements CommandException {
  const CantRespondException(this.reason);

  /// Reason why the bot can't respond.
  final String reason;

  @override
  String toHumanMessage() {
    return cantRespondError(reason);
  }
}
