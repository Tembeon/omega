import 'dart:async';

import 'package:nyxx/nyxx.dart';

import '../../core/utils/loaders/bot_settings.dart';

/// Typedef for creating a new command with a handler.
///
/// Parameters:
/// * [builder] is a function that returns an [ApplicationCommandBuilder] object. Use this object to create a new command.
/// * [handler] is a function that handles the command. It takes an [InteractionCreateEvent] object as a parameter. \
///  You can use the [InteractionCreateEvent] object to get the [ApplicationCommandInteraction] object and respond to the interaction.
typedef CommandCreator = ({
  ApplicationCommandBuilder Function() builder,
  FutureOr<void> Function(InteractionCreateEvent<ApplicationCommandInteraction> interaction) handler,
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
  }) : _bot = bot;

  // Bot instance which used to manage interactions.
  final NyxxGateway _bot;

  // Partial application command manager for current guild, where bot is located and should work.
  // If bot will be invited to another guild, then bot will not work.
  PartialApplicationCommand get _guildManager => _bot.commands[Snowflake(BotSettings.instance.botConfig.serverID)];

  // Map of registered commands.
  // Key is a full command name, value is a function which handles command.
  final Map<String, CommandCreator> _commands = {};

  /// Starts listening for registered interactions.
  ///
  /// You can register new interactions using the [registerCommand] method. \
  /// If you create new command using the [registerCommand] method, you don't need to call this method again.
  void listenInteractions() {
    _bot.onApplicationCommandInteraction.listen((event) {
      _commands[_convertInteractionToName(event.interaction.data)]?.handler(event);
    });
  }

  /// Registers a new command to a bot.
  void registerCommand(CommandCreator commandCreator) {
    // register command in Discord Guild
    _guildManager.manager.create(commandCreator.builder());
    // register command in bot to handle it
    _commands[_convertCommandBuilderToName(commandCreator.builder())] = commandCreator;
    print('Registered new command: "${_commands.entries.last.key}"');
  }

  /// Converts [ApplicationCommandBuilder] to a full command name for matching with interaction.
  String _convertCommandBuilderToName(ApplicationCommandBuilder builder) {
    final sb = StringBuffer(builder.name);

    // get options of command and convert them to a full command name
    final options = builder.options;
    if (options == null || options.isEmpty) {
      return sb.toString();
    }

    // if we have options, then we should convert them to a full command name
    // by documentation, we have [subCommand] and [subCommandGroup] options that can be used to create a full command name
    // [subCommandGroup] can have up to 25 [subCommand]'s options
    // [subCommand] can have up to 25 options, and any option can be [subCommandGroup] or [subCommand]
    // so, we should check if we have [subCommandGroup] or [subCommand] and convert them to a full command name
    sb.write(_parseCommandBuilderName(options));

    // at this moment we should have a full command name which we can use to match with interaction
    // to example: `create raid` where `create` is a base command name and `raid` is a sub command name
    return sb.toString();
  }

  /// Converts [ApplicationCommandBuilder] to a full command name for matching with interaction.
  ///
  /// See [CommandManager._convertCommandBuilderToName] for more details.
  // Internal API is different for [CommandOptionBuilder] and [ApplicationCommandInteractionData],
  // so we need to have two different methods.
  String _parseCommandBuilderName(final List<CommandOptionBuilder> options) {
    final sb = StringBuffer();
    for (final option in options) {
      if (option.type case CommandOptionType.subCommand) {
        sb.write(' ${option.name}');
      } else if (option.type case CommandOptionType.subCommandGroup) {
        sb.write(' ${option.name}');
        if (option.options != null) {
          sb.write(' ${_parseCommandBuilderName(option.options!)}');
        }
      }
    }
    return sb.toString();
  }

  /// Converts [ApplicationCommandInteractionData] to a full command name for matching with command handler.
  String _convertInteractionToName(ApplicationCommandInteractionData data) {
    // local convertor subCommand to command name

    // create sb and write base name of interaction
    final sb = StringBuffer(data.name);
    // get options of interaction
    final options = data.options;

    // if we have no options, then we can return a base name of interaction
    if (options == null || options.isEmpty) {
      return sb.toString();
    }

    // if we have options, then we should convert them to a full command name
    // by documentation, we have [subCommand] and [subCommandGroup] options that can be used to create a full command name
    // [subCommandGroup] can have up to 25 [subCommand]'s options
    // [subCommand] can have up to 25 options, and any option can be [subCommandGroup] or [subCommand]
    // so, we should check if we have [subCommandGroup] or [subCommand] and convert them to a full command name
    sb.write(_parseInteractionName(options));

    return sb.toString();
  }

  /// Parses a list of [InteractionOption] objects and constructs a string that represents the interaction name.
  ///
  /// The method iterates over each [InteractionOption] in the provided list.
  /// For each [InteractionOption], it checks the `type` of the option.
  ///
  /// If the `type` of the [InteractionOption] is [CommandOptionType.subCommand],
  /// it appends the `name` of the option to the string with a leading space.
  ///
  /// If the `type` of the [InteractionOption] is [CommandOptionType.subCommandGroup],
  /// it checks if the `options` property of the [InteractionOption] is not null.
  ///
  /// If it's not null, it recursively calls `_parseInteractionName` with the `options` of the [InteractionOption]
  /// and appends the result to the string with a leading space. \
  /// Finally, after iterating over all the [InteractionOption] objects in the list,
  /// the method returns the constructed string.
  ///
  /// This method essentially constructs a string that represents the interaction name based on the [InteractionOption] objects provided.
  /// It handles both `subCommand` and `subCommandGroup` types of options, and it can handle nested options due to its recursive nature.
  ///
  /// [options] is a list of [InteractionOption] objects that represent the interaction options.
  ///
  /// Returns a string that represents the interaction name.
  String _parseInteractionName(final List<InteractionOption> options) {
    final sb = StringBuffer();
    for (final option in options) {
      if (option.type case CommandOptionType.subCommand) {
        sb.write(' ${option.name}');
      } else if (option.type case CommandOptionType.subCommandGroup) {
        sb.write(' ${option.name}');
        if (option.options != null) {
          sb.write(' ${_parseInteractionName(option.options!)}');
        }
      }
    }
    return sb.toString();
  }
}
