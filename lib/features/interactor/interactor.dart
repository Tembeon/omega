import 'package:l/l.dart';
import 'package:nyxx/nyxx.dart';

import '../../core/utils/dependencies.dart';
import 'interactor_component.dart';

const String _tag = '[Interactor]';

final class Interactor {
  Interactor({
    required Snowflake server,
    required NyxxGateway bot,
  })  : _server = server,
        _bot = bot;

  final Snowflake _server;

  final NyxxGateway _bot;

  PartialApplicationCommand get _guildManager => _bot.commands[_server];

  Map<String, InteractorComponent> _components = {};

  void _listenInteractions() {
    _bot.onApplicationCommandInteraction.listen(
      (event) {
        l.d('$_tag Received new interaction "${event.interaction.data.name}", working on it...');

        final option = _UnifiedOption(
          name: event.interaction.data.name,
          type: CommandOptionType.subCommand,
          options: event.interaction.data.options?.map(_UnifiedOption.fromInteractionOption).toList(),
        );

        final matches = _parseCommandNames([option]);
        if (matches.length > 1) {
          throw Exception('More than one command matched: $matches');
        }

        if (matches.isEmpty) {
          l.d('$_tag Handler for interaction "${event.interaction.data.name}" not found');
          event.interaction.respond(MessageBuilder(content: 'Я не знаю, как на это ответить :('));
          return;
        }

        final commandName = matches.first;
        final component = _components[commandName];
        if (component == null || component is! InteractorCommandComponent) {
          l.d('$_tag handler for interaction "$commandName" not found or '
              'doesn\'t match InteractorCommandComponent'
              '\nExpected: InteractorCommandComponent, got: ${component.runtimeType}');
          event.interaction.respond(MessageBuilder(content: 'Я не знаю, как на это ответить :('));
          return;
        }

        component.handle(commandName, event, Dependencies.instance);
      },
    );
  }
}

Iterable<String> _parseCommandNames(List<_UnifiedOption> options, [String? prefix]) sync* {
  for (final option in options) {
    final currentName = prefix != null ? '$prefix ${option.name}' : option.name;

    if (option.type == CommandOptionType.subCommandGroup) {
      if (option.options != null) {
        yield* _parseCommandNames(option.options!, currentName);
      }
    } else if (option.type == CommandOptionType.subCommand) {
      if (option.options != null && option.options!.isNotEmpty) {
        bool hasSubCommand = option.options!
            .any((opt) => opt.type == CommandOptionType.subCommand || opt.type == CommandOptionType.subCommandGroup);

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
