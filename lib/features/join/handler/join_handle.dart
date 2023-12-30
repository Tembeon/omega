import 'package:nyxx/nyxx.dart';

import '../../../core/const/command_exceptions.dart';
import '../../../core/utils/context/context.dart';
import '../../command_manager/command_manager.dart';
import '../../lfg_manager/lfg_manager.dart';

ComponentCreator joinComponentHandler() => (
      customID: 'join',
      handler: _handleJoinInteraction,
    );

Future<void> _handleJoinInteraction(InteractionCreateEvent<MessageComponentInteraction> event) async {
  final messageID = event.interaction.message?.id;
  if (messageID == null) return;

  final lfgManager = Context.root.get<ILFGManager>('manager');

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
