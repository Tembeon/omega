/// Exceptions thrown by commands. Used to display human-readable messages.
///
/// All exceptions should be caught by the command handler and sends to the user.
sealed class CommandException implements Exception {}

/// Exception thrown when a command is executed with too many players in the activity.
class TooManyPlayers implements CommandException {}

/// Exception thrown when a creator tries to leave their own activity.
class CreatorCannotLeave implements CommandException {}

/// Exception thrown when a player tries to join an activity they are already in.
class AlreadyJoined implements CommandException {}

/// Exception thrown when a player tries to leave an activity they are not in.
class NotJoined implements CommandException {}

/// Exception thrown when a command is executed by a player who is not the creator.
class NotCreator implements CommandException {}

/// Exception thrown when a command triggered, but bot refused to respond.
class CantRespond implements CommandException {
  const CantRespond(this.reason);

  /// Reason why the bot can't respond.
  final String reason;

  String toHumanMessage() {
    final sb = StringBuffer()
      ..writeln('Невозможно выполнить команду.')
      ..writeln('Причина: $reason')
      ..writeln('Попробуйте ещё раз или обратитесь к администрации сервера.');

    return sb.toString();
  }
}
