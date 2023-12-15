import 'dart:async';

import 'package:nyxx/nyxx.dart';

import '../../core/utils/loaders/bot_settings.dart';

/// Typedef for creating a new command with a handler.
///
/// Parameters:
/// * [builder] is a function that returns an [ApplicationCommandBuilder] object. Use this object to create a new command.
/// * [handlers] is a map of handlers for the command. The key is a string that represents the name of the command. \
///
/// To example, we have a /create command with three subcommands: raid, dungeon, custom. \
/// So, we can create a map of handlers for this command:
/// ```dart
/// {
///  'raid': (interaction) => _createActivityHandler(interaction, LFGActivityType.raid),
///  'dungeon': (interaction) => _createActivityHandler(interaction, LFGActivityType.dungeon),
///  'custom': (interaction) => _createActivityHandler(interaction, LFGActivityType.custom),
///  }
///  ```
///  This map will be used to match the name of the command with the handler.
typedef CommandCreator = ({
  ApplicationCommandBuilder Function() builder,
  Map<String, FutureOr<void> Function(InteractionCreateEvent<ApplicationCommandInteraction> interaction)> handlers,
});

/// Class which manages bot interactions, such as commands, buttons, etc.
///
/// This class listens for interactions, parses them, and calls the appropriate handler.
///
/// To register a new command, use the [registerCommand] method, which takes a [CommandCreator] as a parameter.
class CommandManager {
  /// Creates a new [CommandManager] instance for a [bot].
  CommandManager({
    required NyxxGateway bot,
  }) : _bot = bot {
    _listenInteractions();
  }

  // Bot instance which used to manage interactions.
  final NyxxGateway _bot;

  // Partial application command manager for current guild, where bot is located and should work.
  // If bot will be invited to another guild, then bot will not work.
  PartialApplicationCommand get _guildManager => _bot.commands[Snowflake(BotSettings.instance.botConfig.serverID)];

  // Map of registered commands.
  // Key is a full command name, value is a function which handles command.
  final Map<String, FutureOr<void> Function(InteractionCreateEvent<ApplicationCommandInteraction> interaction)>
      _commands = {};

  /// Starts listening for registered interactions.
  ///
  /// You can register new interactions using the [registerCommand] method. \
  /// If you create new command using the [registerCommand] method, you don't need to call this method again.
  void _listenInteractions() {
    _bot.onApplicationCommandInteraction.listen((event) {
      print('Received new interaction: "${event.interaction.data.name}"');

      final option = _UnifiedOption(
        name: event.interaction.data.name,
        type: CommandOptionType.subCommand,
        options: event.interaction.data.options!.map(_UnifiedOption.fromInteractionOption).toList(),
      );

      final matches = _getCommandNames([option]);
      if (matches.length > 1) throw Exception('More than one command matched: $matches');

      final handler = _commands[matches.first];
      if (handler == null) {
        print('Handler for interaction "${event.interaction.data.name}" not found');
        return;
      }

      handler.call(event);
    });
  }

  /// Registers a new command to a bot.
  Future<void> registerCommand(CommandCreator commandCreator) async {
    // register command in Discord Guild
    await _guildManager.manager.create(commandCreator.builder());
    // register command in bot to handle it

    final option = _UnifiedOption(
      name: commandCreator.builder().name,
      type: CommandOptionType.subCommand,
      options: commandCreator.builder().options!.map(_UnifiedOption.fromCommandOptionBuilder).toList(),
    );

    final commandNames = _getCommandNames([option]);
    if (commandNames.length != commandCreator.handlers.length) {
      throw Exception('Different amount of handlers (${commandCreator.handlers.length}) '
          'and given value in command builder. Expected ${commandNames.length}');
    }

    for (final commandName in commandNames) {
      _commands[commandName] = commandCreator.handlers[commandName]!;
      print('Registered new command: "${_commands.entries.last.key}"');
    }
  }

  Iterable<String> _getCommandNames(List<_UnifiedOption> interactionOptions, [String prefix = '']) sync* {
    for (final _UnifiedOption interactionOption in interactionOptions) {
      final String currentPrefix = prefix.isNotEmpty ? '$prefix ${interactionOption.name}' : interactionOption.name;
      if (interactionOption.type == CommandOptionType.subCommandGroup ||
          interactionOption.type == CommandOptionType.subCommand) {
        if (prefix.isNotEmpty) {
          yield currentPrefix;
        }
        if (interactionOption.options != null && interactionOption.options!.isNotEmpty) {
          yield* _getCommandNames(interactionOption.options!, currentPrefix);
        } else if (interactionOption.type == CommandOptionType.subCommand) {
          yield currentPrefix;
        }
      }
    }
  }
}

class _UnifiedOption {
  _UnifiedOption({
    required this.name,
    required this.type,
    this.options,
  });

  final String name;
  final CommandOptionType type;
  final List<_UnifiedOption>? options;

  factory _UnifiedOption.fromInteractionOption(InteractionOption option) {
    return _UnifiedOption(
      name: option.name,
      type: option.type,
      options: option.options?.map(_UnifiedOption.fromInteractionOption).toList(),
    );
  }

  factory _UnifiedOption.fromCommandOptionBuilder(CommandOptionBuilder option) {
    return _UnifiedOption(
      name: option.name,
      type: option.type,
      options: option.options?.map(_UnifiedOption.fromCommandOptionBuilder).toList(),
    );
  }
}
