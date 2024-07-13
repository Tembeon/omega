import 'package:nyxx/nyxx.dart';

import '../../core/utils/services.dart';

export 'package:nyxx/nyxx.dart';
export '../../core/utils/services.dart';

/// Trigger reasons for interactor.
enum UpdateEvent {
  /// Activity was updated in the system.
  ///
  /// Example: minimum members count was updated / roles updated.
  activitiesUpdated,

  /// Timezones were updated in the system.
  timezonesUpdated,

  lfgChannelUpdated,

  promoChannelUpdated,
}

/// Base class for all interactor components.
///
/// Interactor component is a part of interactor that handles specific type of interactions.
///
/// See also:
/// * [InteractorCommandComponent] - component that handles slash command interactions.
/// * [InteractorMessageComponent] - component that handles message component interactions.
/// * [InteractorModalComponent] - component that handles modal interactions.
abstract class InteractorComponent<T extends Interaction<Object?>> {
  const InteractorComponent();

  /// Called when Interactor receives an event that this component should handle.
  Future<void> handle(String commandName, InteractionCreateEvent<T> event, Services services);

  /// Called when Interactor wants to update components.
  ///
  /// If this component should be updated when some of events happened,
  /// then Interactor updates this component in Discord.
  Set<UpdateEvent> get updateWhen => <UpdateEvent>{};

  /// Called when Interactor wants to know if this component should be enabled.
  ///
  /// If this component should be enabled, then Interactor will register this component in Discord.
  /// Otherwise, this component will be ignored or removed from Discord (if it was registered).
  ///
  /// Please note that returning `false` will remove root command of this component.
  /// If you want to disable only some of subcommands, then you should return `true`
  /// and do not include subcommands in [build] method.
  Future<bool> enabledWhen(Services services) => Future.value(true);
}

/// Base class for all interactor command components.
///
/// This component should be used to handle slash command interactions.
abstract class InteractorCommandComponent extends InteractorComponent<ApplicationCommandInteraction> {
  const InteractorCommandComponent();

  /// This method should be used to build command for this component.
  Future<ApplicationCommandBuilder> build(Services services);

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  );
}

/// Base class for all interactor message component components.
///
/// This component should be used to handle message component interactions.
abstract class InteractorMessageComponent extends InteractorComponent<MessageComponentInteraction> {
  const InteractorMessageComponent();

  /// Generates unique ID for this component which used to identify this component in the system.
  Future<String> uniqueID(Services services);

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<MessageComponentInteraction> event,
    Services services,
  );
}

/// Base class for all interactor modal components.
///
/// This component should be used to handle modal interactions.
abstract class InteractorModalComponent extends InteractorComponent<ModalSubmitInteraction> {
  const InteractorModalComponent();

  /// Generates unique ID for this component which used to identify this component in the system.
  Future<String> uniqueID(Services services);

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ModalSubmitInteraction> event,
    Services services,
  );
}
