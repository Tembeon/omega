import 'interactor_component.dart';

abstract class ComponentInterceptor<T extends Interaction<Object?>> {
  const ComponentInterceptor();

  Future<void> intercept(
    InteractionCreateEvent<T> event,
    Services services,
  );
}

abstract class ComponentMessageInterceptor extends ComponentInterceptor<MessageComponentInteraction> {
  const ComponentMessageInterceptor();

  @override
  Future<void> intercept(
    InteractionCreateEvent<MessageComponentInteraction> event,
    Services services,
  );
}

abstract class ComponentCommandInterceptor extends ComponentInterceptor<ApplicationCommandInteraction> {
  const ComponentCommandInterceptor();

  @override
  Future<void> intercept(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  );
}
