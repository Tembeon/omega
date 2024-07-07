import '../../../../core/const/command_exceptions.dart';
import '../../../interactor/interactor_component.dart';

class LeaveMessageComponent extends InteractorMessageComponent {
  const LeaveMessageComponent();

  @override
  Future<String> uniqueID(Services services) async {
    return 'leave';
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
      await lfgManager.removeMemberFrom(event.interaction.message!, event.interaction.member!.user!);
      await event.interaction.respond(MessageBuilder(content: 'Вы покинули LFG'), isEphemeral: true);
    } on CommandException catch (e) {
      await event.interaction.respond(MessageBuilder(content: e.toHumanMessage()), isEphemeral: true);
    } on Object catch (e, st) {
      await event.interaction.respond(
        MessageBuilder(
          content: 'Произошла неизвестная ошибка при удалении вас из LFG\n'
              'Метаданные: $e\n'
              'Стек вызовов: ${st.toString().substring(0, 200)}',
        ),
        isEphemeral: true,
      );
    }
  }
}
