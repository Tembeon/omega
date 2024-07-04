import 'package:nyxx/nyxx.dart';

import '../../core/utils/dependencies.dart';

/// Trigger reasons for interactor.
enum UpdateEvent {
  /// New activity was added in the system.
  ///
  /// Example: new raid was added.
  activityAdded,

  /// Activity was removed from the system.
  ///
  /// /// Example: raid was removed.
  activityRemoved,

  /// Activity was updated in the system.
  ///
  /// Example: minimum members count was updated / roles updated.
  activityUpdated,
}

/// Base class for all interactor components.
///
/// Interactor component is a part of interactor that handles specific type of interactions.
///
/// See also:
/// * [InteractorCommandComponent] - component that handles slash command interactions.
/// * [InteractorComponentComponent] - component that handles message component interactions.
/// * [InteractorModalComponent] - component that handles modal interactions.
abstract class InteractorComponent<T extends Interaction<Object?>> {
  const InteractorComponent();

  /// This method should be used to build command for this component.
  ApplicationCommandBuilder build(Dependencies dependencies);

  /// Called when Interactor receives an event that this component should handle.
  Future<void> handle(String commandName, InteractionCreateEvent<T> event, Dependencies dependencies);

  /// Called when Interactor wants to update components.
  ///
  /// If this component should be updated when some of events happened,
  /// then Interactor updates this component in Discord.
  Set<UpdateEvent> get updateWhen => <UpdateEvent>{};
}

/// Base class for all interactor command components.
///
/// This component should be used to handle slash command interactions.
abstract class InteractorCommandComponent extends InteractorComponent<ApplicationCommandInteraction> {
  const InteractorCommandComponent();

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Dependencies dependencies,
  );
}

/// Base class for all interactor message component components.
///
/// This component should be used to handle message component interactions.
abstract class InteractorComponentComponent extends InteractorComponent<MessageComponentInteraction> {
  const InteractorComponentComponent();

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<MessageComponentInteraction> event,
    Dependencies dependencies,
  );
}

/// Base class for all interactor modal components.
///
/// This component should be used to handle modal interactions.
abstract class InteractorModalComponent extends InteractorComponent<ModalSubmitInteraction> {
  const InteractorModalComponent();

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ModalSubmitInteraction> event,
    Dependencies dependencies,
  );
}
