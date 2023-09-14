/// Exception thrown when a command is executed with too many players.
class TooManyPlayers implements Exception {}

/// Exception thrown when a creator tries to leave their own activity.
class CreatorCannotLeave implements Exception {}

/// Exception thrown when a player tries to join an activity they are already in.
class AlreadyJoined implements Exception {}

/// Exception thrown when a player tries to leave an activity they are not in.
class NotJoined implements Exception {}

/// Exception thrown when a command is executed by a player who is not the creator.
class NotCreator implements Exception {}

/// Exception thrown when a command triggered, but bot refused to respond.
class CantRespond implements Exception {
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
