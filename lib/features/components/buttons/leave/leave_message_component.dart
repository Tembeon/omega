import '../../../../core/const/command_exceptions.dart';
import '../../../../core/l10n/messages.dart';
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
      await event.interaction.respond(MessageBuilder(content: leaveComponentLeft), isEphemeral: true);
    } on CommandException catch (e) {
      await event.interaction.respond(MessageBuilder(content: e.toHumanMessage()), isEphemeral: true);
    } on Object catch (e, st) {
      final stackText = st.toString();
      final truncatedStack = stackText.length > 200 ? stackText.substring(0, 200) : stackText;
      await event.interaction.respond(
        MessageBuilder(
          content: '$leaveComponentUnknownErrorTitle\n'
              '${generalMetadata(e.toString())}\n'
              '${generalStackTrace(truncatedStack)}',
        ),
        isEphemeral: true,
      );
    }
  }
}
