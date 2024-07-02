import 'dart:async';

import 'package:nyxx/nyxx.dart';

import '../../core/const/command_exceptions.dart';
import '../../core/utils/loaders/bot_settings.dart';

/// Typedef for creating a new command with a handler.
///
/// Parameters:
/// * [builder] is a function that returns an [ApplicationCommandBuilder] object. Use this object to create a new command.
/// * [handlers] is a map of handlers for the command. The key is a string that represents the name of the command. \
///
/// To example, we have a /create command with three subcommands: raid, dungeon, activity. \
/// So, we can create a map of handlers for this command:
/// ```dart
/// {
///  'raid': (interaction) => _createActivityHandler(interaction, LFGType.raid),
///  'dungeon': (interaction) => _createActivityHandler(interaction, LFGType.dungeon),
///  'activity': (interaction) => _createActivityHandler(interaction, LFGType.activity),
///  }
///  ```
///  This map will be used to match the name of the command with the handler.
typedef CommandCreator = ({
  ApplicationCommandBuilder Function() builder,
  Map<String, Future<void> Function(InteractionCreateEvent<ApplicationCommandInteraction> interaction)> handlers,
});

/// Typedef for creating a new component with a handler.
///
/// Parameters:
/// * [customID] is a custom ID of the component.
/// * [handler] is a function that handles the component.
typedef ComponentCreator = ({
  String customID,
  Future<void> Function(InteractionCreateEvent<MessageComponentInteraction> interaction) handler,
});

typedef ModalCreator = ({
  String customID,
  Future<void> Function(InteractionCreateEvent<ModalSubmitInteraction> interaction) handler,
});

/// Class which manages bot interactions, such as commands, buttons, etc.
///
/// This class listens for interactions, parses them, and calls the appropriate handler.
///
/// To register a new command, use the [registerCommand] method, which takes a [CommandCreator] as a parameter.
base class CommandManager {
  /// Creates a new [CommandManager] instance for a [bot].
  CommandManager({
    required NyxxGateway bot,
  }) : _bot = bot {
    _listenInteractions();
    _listenButtons();
    _listenModals();
  }

  // Bot instance which used to manage interactions.
  final NyxxGateway _bot;

  // Partial application command manager for current guild, where bot is located and should work.
  // If bot will be invited to another guild, then bot will not work.
  PartialApplicationCommand get _guildManager => _bot.commands[Snowflake(BotSettings.instance.botConfig.serverID)];

  // Map of registered commands.
  // Key is a full command name, value is a function which handles command.
  final Map<String, Future<void> Function(InteractionCreateEvent<ApplicationCommandInteraction> interaction)>
      _commands = {};

  // Map of registered components.
  // Key is a custom ID of the component, value is a function which handles component.
  final Map<String, Future<void> Function(InteractionCreateEvent<MessageComponentInteraction> interaction)>
      _components = {};

  final Map<String, Future<void> Function(InteractionCreateEvent<ModalSubmitInteraction> interaction)> _modals = {};
  final Map<String, Timer> _modalsSubsTimers = {};

  /// Starts listening for registered interactions.
  ///
  /// You can register new interactions using the [registerCommand] method. \
  /// If you create new command using the [registerCommand] method, you don't need to call this method again.
  void _listenInteractions() {
    _bot.onApplicationCommandInteraction.listen((event) {
      print('[CommandManager] Received new interaction: "${event.interaction.data.name}"');

      final option = _UnifiedOption(
        name: event.interaction.data.name,
        type: CommandOptionType.subCommand,
        options: event.interaction.data.options?.map(_UnifiedOption.fromInteractionOption).toList(),
      );

      final matches = _parseCommandNames([option]);
      if (matches.length > 1) throw Exception('More than one command matched: $matches');

      final handler = _commands[matches.first];
      if (handler == null) {
        print('[CommandManager] Handler for interaction "${event.interaction.data.name}" not found');
        return;
      }

      handler.call(event);
    });
  }

  /// Starts listening for registered components.
  ///
  /// You can register new components using the [registerComponent] method. \
  /// If you create new component using the [registerComponent] method, you don't need to call this method again.
  void _listenButtons() {
    _bot.onMessageComponentInteraction.listen((event) {
      print(
        '[CommandManager] Received new button interaction: "${event.interaction.data.customId}" '
        'for ${event.interaction.member?.user?.username}',
      );

      final handler = _components[event.interaction.data.customId];
      if (handler == null) {
        print('[CommandManager] Handler for button "${event.interaction.data.customId}" not found');
        return;
      } else {
        handler(event);
      }
    });
  }

  void _listenModals() {
    _bot.onModalSubmitInteraction.listen((event) {
      print('[CommandManager] Received new modal interaction: "${event.interaction.data.customId}"');

      final userId = event.interaction.user?.id.value ?? event.interaction.member?.user?.id.value;
      if (userId == null) throw const CantRespondException('No user ID found in interaction');
      final subscriberString = '${event.interaction.data.customId}_subscriber';
      final subscriberHandler = _modals[subscriberString];
      if (subscriberHandler != null) {
        subscriberHandler(event);
        _modals.remove(subscriberString);
        _modalsSubsTimers[subscriberString]?.cancel();
        _modalsSubsTimers.remove(subscriberString);
      }
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
      options: commandCreator.builder().options?.map(_UnifiedOption.fromCommandOptionBuilder).toList(),
    );

    final commandNames = _parseCommandNames([option]);
    if (commandNames.length != commandCreator.handlers.length) {
      throw Exception('Different amount of handlers (${commandCreator.handlers.length}) '
          'and given value in command builder. Expected ${commandNames.length}');
    }

    for (final commandName in commandNames) {
      _commands[commandName] = commandCreator.handlers[commandName]!;
      print('[CommandManager] Registered command: "${_commands.entries.last.key}"');
    }
  }

  /// Registers a new component to a bot.
  ///
  /// Component is a button, select menu, etc.
  Future<void> registerComponent(ComponentCreator componentCreator) async {
    _components[componentCreator.customID] = componentCreator.handler;
    print('[CommandManager] Registered component: "${componentCreator.customID}"');
  }

  Future<void> registerModal(ModalCreator modalCreator) async {
    _modals[modalCreator.customID] = modalCreator.handler;
    print('[CommandManager] Registered modal: "${modalCreator.customID}"');
  }

  /// Registers a callback that will be called when the bot receives a new modal interaction with the given [modalID].
  ///
  /// Subscribers are one-time handlers that are called only once when the bot receives a modal interaction with the given [modalID].
  void subscribeToModal({
    required final String modalID,
    required final Future<void> Function(InteractionCreateEvent<ModalSubmitInteraction> interaction) handler,
    final Duration timeout = const Duration(minutes: 5), // time after which the handler will be removed
  }) {
    final subId = '${modalID}_subscriber';
    _modals[subId] = handler;
    print('[CommandManager] Subscribed to modal: "$modalID"');
    _modalsSubsTimers[subId] = Timer(timeout, () {
      print('[CommandManager] Timeout for $subId reached');
      unsubscribeFromModal(customID: modalID);
    });
  }

  void unsubscribeFromModal({
    required final String customID,
  }) {
    _modals.remove('${customID}_subscriber');
    print('[CommandManager] Unsubscribed from modal: "$customID"');
  }

  // fixes version of _getCommandNames method
  // problem: _getCommandNames method returns more than expected names.
  // for example: received Option like:
  // [Option(type: subCommand, options: [Options(type: subCommand, options: [Options(type: string]]), Options(type: subCommand)])]
  // expected: ['subCommand subCommand', 'subCommand'], but received: ['subCommand subCommand', 'subCommand subCommand', 'subCommand']
  Iterable<String> _parseCommandNames(List<_UnifiedOption> options, [String? prefix]) sync* {
    for (final option in options) {
      final currentName = prefix != null ? '$prefix ${option.name}' : option.name;

      if (option.type == CommandOptionType.subCommandGroup) {
        if (option.options != null) {
          yield* _parseCommandNames(option.options!, currentName);
        }
      } else if (option.type == CommandOptionType.subCommand) {
        if (option.options != null && option.options!.isNotEmpty) {
          bool hasSubCommand = option.options!.any((opt) =>
          opt.type == CommandOptionType.subCommand ||
              opt.type == CommandOptionType.subCommandGroup);

          if (hasSubCommand) {
            yield* _parseCommandNames(option.options!, currentName);
          } else {
            yield currentName;
          }
        } else {
          yield currentName;
        }
      }
    }
  }

  @Deprecated('use _parseCommandNames')
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
  const _UnifiedOption({
    required this.name,
    required this.type,
    this.options,
  });

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

  final String name;
  final CommandOptionType type;
  final List<_UnifiedOption>? options;
}
