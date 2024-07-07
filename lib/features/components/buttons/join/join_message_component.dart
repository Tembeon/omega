import '../../../../core/const/command_exceptions.dart';
import '../../../interactor/interactor_component.dart';

class JoinMessageComponent extends InteractorMessageComponent {
  const JoinMessageComponent();

  @override
  Future<String> uniqueID(Services services) async {
    return 'join';
  }

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<MessageComponentInteraction> event,
    Services services,
  ) async {
    final messageID = event.interaction.message?.id;
    if (messageID == null) return;

    final lfgManager = services.lfgManager;

    try {
      await lfgManager.addMemberTo(event.interaction.message!, event.interaction.member!.user!);
      await event.interaction.respond(MessageBuilder(content: 'Вы добавлены в LFG'), isEphemeral: true);
    } on CommandException catch (e) {
      await event.interaction.respond(MessageBuilder(content: e.toHumanMessage()), isEphemeral: true);
    } on Object catch (e, st) {
      await event.interaction.respond(
        MessageBuilder(
          content: 'Произошла неизвестная ошибка при добавлении вас в LFG\n'
              'Метаданные: $e\n'
              'Стек вызовов: $st',
        ),
        isEphemeral: true,
      );
    }
  }
}
