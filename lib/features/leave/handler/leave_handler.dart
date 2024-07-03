import 'package:nyxx/nyxx.dart';

import '../../../core/const/command_exceptions.dart';
import '../../../core/utils/context/context.dart';
import '../../command_manager/command_manager.dart';
import '../../lfg_manager/lfg_manager.dart';

ComponentCreator leaveComponentHandler() => (
      customID: 'leave',
      handler: _handleLeaveInteraction,
    );

Future<void> _handleLeaveInteraction(
  InteractionCreateEvent<MessageComponentInteraction> event,
) async {
  final messageID = event.interaction.message?.id;
  if (messageID == null) return;

  final lfgManager = Context.root.get<ILFGManager>('manager');

  try {
    await lfgManager.removeMemberFrom(
      event.interaction.message!,
      event.interaction.member!.user!,
    );
    await event.interaction
        .respond(MessageBuilder(content: 'Вы покинули LFG'), isEphemeral: true);
  } on CommandException catch (e) {
    await event.interaction.respond(
      MessageBuilder(content: e.toHumanMessage()),
      isEphemeral: true,
    );
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
