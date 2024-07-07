import 'package:l/l.dart';

import 'interactor_component.dart';

const String _tag = '[Interactor]';

class ComponentFormatException implements Exception {
  const ComponentFormatException(this.message);

  final String message;

  @override
  String toString() => 'ComponentFormatException: $message';
}

void test() {}

final class Interactor extends _Registrar with _Syncer, _Listener {
  Interactor({
    required super.serverId,
    required super.bot,
  }) {
    _listenInteractions();
  }
}

/// Part of Interactor that handles synchronization of components.
///
/// Main logic of this mixin is to update components in Discord when some of events happened.
base mixin _Syncer on _Registrar {
  /// Notifies Interactor that some of events happened.
  ///
  /// Interactor will update components that should be updated when some of events happened.
  void notifyUpdate(Set<UpdateEvent> events) {
    l.d('$_tag Received update events: $events');
    final List<InteractorComponent> toUpdate = [];
    for (final component in components) {
      if (component.updateWhen.intersection(events).isNotEmpty) {
        toUpdate.add(component);
        l.d('$_tag Component "${component.runtimeType}" will be updated because of $events');
      }
    }

    if (toUpdate.isEmpty) {
      l.d('$_tag No components to update, skipping sync');
      return;
    }

    _sync(toUpdate);
  }

  Future<void> _sync(List<InteractorComponent> components) async {
    l.d('$_tag Syncing components: $components');
    for (final component in components) {
      await _registerComponent(component);
    }
  }
}

typedef _RegisteredComponent = ({
  Snowflake id,
  InteractorComponent component,
});

/// Core component on Interactor, that holds all InteractionComponents and registers them in Discord.
base class _Registrar {
  _Registrar({
    required NyxxGateway bot,
    required Snowflake serverId,
  })  : _bot = bot,
        _serverId = serverId;

  final NyxxGateway _bot;

  final Snowflake _serverId;

  PartialApplicationCommand get _guildCommands => _bot.commands[_serverId];

  /// Contains all added components.
  List<InteractorComponent> get components => _registered.values.map((e) => e.component).toList(
        growable: false,
      );

  /// Contains all registered components.
  final Map<String, _RegisteredComponent> _registered = {};

  /// Adds component to registration.
  ///
  /// Throws exception if component is invalid.
  Future<void> addComponent(InteractorComponent component) async {
    return _registerComponent(component);
  }

  /// Adds multiple components to registration.
  ///
  /// Throws exception if any of components is invalid.
  Future<void> addComponents(Set<InteractorComponent> components) async {
    for (final component in components) {
      await addComponent(component);
    }
  }

  /// Removes all unknown for Interactor components.
  ///
  /// This method will remove all components that are not registered in Interactor,
  /// so this methods should be called after all components are registered.
  Future<void> forgetUnknown() async {
    l.d('$_tag Forgetting unknown commands...');
    final allCommands = await _guildCommands.manager.list();
    final knownCommands = _registered.values.map((e) => e.id).toSet();
    final unknownCommands = allCommands.where((element) => !knownCommands.contains(element.id));
    l.d('$_tag Found ${unknownCommands.length} unknown commands');

    for (final unknown in unknownCommands) {
      l.d('$_tag Deleting unknown command: ${unknown.id} with name: ${unknown.name}');
      await _guildCommands.manager.delete(unknown.id);
    }
  }

  Future<void> _unregisterComponent(InteractorComponent component) async {
    final commandsNames = await _verifyComponent(component);
    final toDelete = _registered.entries.where(
      (element) {
        return commandsNames.any((name) => element.key.contains(name));
      },
    );

    if (toDelete.isEmpty) {
      l.d('$_tag No components to unregister for ${component.runtimeType}, skipping');
      return;
    }

    l.d('$_tag Unregistering component ${component.runtimeType}...');
    for (final entry in toDelete) {
      l.d('$_tag Deleting command: ${entry.key}');
      await _guildCommands.manager.delete(entry.value.id);
      _registered.remove(entry.key);
      l.d('$_tag Command ${entry.key} deleted');
    }
  }

  _RegisteredComponent? _findByCommandName(String commandName) {
    final component = _registered[commandName];

    return component;
  }

  Future<void> _registerComponent(InteractorComponent component) async {
    final wantToRegister = await component.enabledWhen(Services.i);

    // if component doesn't want to be registered, then we should remove it from Discord
    if (!wantToRegister) {
      await _unregisterComponent(component);
      return;
    }

    if (component is InteractorMessageComponent) {
      _registered[await component.uniqueID(Services.i)] = (id: Snowflake.zero, component: component);
      return;
    }

    l.d('$_tag Checking component ${component.runtimeType}...');
    final commandsNames = await _verifyComponent(component);
    final builder = await component.build(Services.i);

    // check if command already registered. Is so, then update it
    final registeredComponent = _findByCommandName(commandsNames.first);
    if (registeredComponent != null) {
      l.d('$_tag Component ${component.runtimeType} already registered, updating...');
      final updatedResult = await _guildCommands.manager.update(
        registeredComponent.id,
        ApplicationCommandUpdateBuilder(
          name: builder.name,
          description: builder.description,
          options: builder.options,
          defaultMemberPermissions: builder.defaultMemberPermissions,
          contexts: builder.contexts,
          descriptionLocalizations: builder.descriptionLocalizations,
          integrationTypes: builder.integrationTypes,
          isNsfw: builder.isNsfw,
          nameLocalizations: builder.nameLocalizations,
        ),
      );

      l.d('$_tag Component ${component.runtimeType} updated in Discord with ID: ${updatedResult.id}');

      for (final name in commandsNames) {
        _registered[name] = (id: updatedResult.id, component: component);
      }

      return;
    }

    l.d('$_tag Registering new component ${component.runtimeType}...');
    final result = await _guildCommands.manager.create(builder);
    l.d('$_tag Component ${component.runtimeType} registered in Discord with ID: ${result.id}');

    for (final name in commandsNames) {
      _registered[name] = (id: result.id, component: component);
    }

    l.d('$_tag Component ${component.runtimeType} registered successfully '
        'with commands: $commandsNames');
  }

  /// Verifies that passed component is:
  /// 1. Valid
  /// 2. Unique
  /// 3. Not empty
  ///
  /// Returns list of command names that this component has.
  ///
  /// Throws exception if component is invalid.
  Future<Iterable<String>> _verifyComponent(InteractorComponent component) async {
    final builder = await component.build(Services.i);
    final commandNames = _parseCommandNames([
      _UnifiedOption(
        name: builder.name,
        type: CommandOptionType.subCommand,
        options: builder.options?.map(_UnifiedOption.fromCommandOptionBuilder).toList(),
      ),
    ]);

    if (commandNames.isEmpty) {
      throw const ComponentFormatException('Component has no command names');
    }

    if (commandNames.length != commandNames.toSet().length) {
      throw ComponentFormatException('Component ${component.runtimeType} has non-unique command names: $commandNames\n'
          'Trying to register this component on Discord will cause an error');
    }

    final intersection = commandNames.toSet().intersection(_registered.keys.toSet());
    if (intersection.isNotEmpty) {
      throw ComponentFormatException(
          'Component ${component.runtimeType} has command(s) that already exists: $intersection\n'
          'Please, change command name(s) to unique');
    }

    return commandNames;
  }
}

base mixin _Listener on _Registrar {
  final Map<String, Future<void> Function(InteractionCreateEvent<ModalSubmitInteraction> interaction)>
      _modalSubscriptions = {};

  /// Register `handler` to be called when modal with `modalID` is submitted.
  ///
  /// If modal is not submitted in `timeout` time, then handler will be removed.
  void subscribeToModal({
    required final String modalID,
    required final Future<void> Function(InteractionCreateEvent<ModalSubmitInteraction> interaction) handler,
    final Duration timeout = const Duration(minutes: 5), // time after which the handler will be removed
  }) {
    _modalSubscriptions[modalID] = handler;
    l.d('$_tag Subscribed to modal: "$modalID"');

    Future<void>.delayed(timeout, () {
      l.d('$_tag Timeout for $modalID reached');
      _modalSubscriptions.remove(modalID);
    }).ignore();
  }

  /// Unsubscribes from modal with `customID`.
  void unsubscribeFromModal({
    required final String customID,
  }) {
    _modalSubscriptions.remove(customID);
    l.d('$_tag Unsubscribed from modal: "$customID"');
  }

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
          event.interaction.respond(
            MessageBuilder(content: 'Я не знаю, как на это ответить :('),
            isEphemeral: true,
          );
          return;
        }

        final commandName = matches.first;
        final registry = _registered[commandName];
        if (registry == null) {
          l.d('$_tag handler for interaction "$commandName" not found or '
              'doesn\'t match InteractorCommandComponent'
              '\nExpected: InteractorCommandComponent, got: ${registry.runtimeType}');
          event.interaction.respond(
            MessageBuilder(content: 'Я не знаю, как на это ответить :('),
            isEphemeral: true,
          );
          return;
        }

        registry.component.handle(commandName, event, Services.instance);
      },
    );

    _bot.onMessageComponentInteraction.listen(
      (event) {
        l.d(
          '$_tag Received new button interaction: "${event.interaction.data.customId}" '
          'for ${event.interaction.member?.user?.username}',
        );

        final registry = _registered[event.interaction.data.customId];
        if (registry == null) {
          l.d('$_tag Handler for button "${event.interaction.data.customId}" not found');
          return;
        } else {
          registry.component.handle(event.interaction.data.customId, event, Services.i);
        }
      },
    );

    _bot.onModalSubmitInteraction.listen((event) {
      l.d('$_tag Received new modal interaction: "${event.interaction.data.customId}"');

      final subscriberString = event.interaction.data.customId;
      final subscriberHandler = _modalSubscriptions[subscriberString];
      if (subscriberHandler != null) {
        subscriberHandler(event);
        _modalSubscriptions.remove(subscriberString);
      } else {
        l.d('$_tag No subscriber for modal "${event.interaction.data.customId}"');
      }
    });
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
        final bool hasSubCommand = option.options!
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
