import 'package:nyxx/nyxx.dart';

import '../../../core/utils/dependencies.dart';
import '../../command_manager/command_manager.dart';

CommandCreator deleteCommand() {
  return (
    builder: _createDeleteCommand,
    handlers: {
      'Удалить LFG': _deleteHandler,
    }
  );
}

ApplicationCommandBuilder _createDeleteCommand() {
  return ApplicationCommandBuilder(
    name: 'Удалить LFG',
    type: ApplicationCommandType.message,
  );
}

Future<void> _deleteHandler(
  InteractionCreateEvent<ApplicationCommandInteraction> interaction,
) async {
  final message = interaction.interaction.data.targetId;
  final channel = interaction.interaction.channel;

  // message and channel should never be null
  if (message == null || channel == null) {
    await interaction.interaction.respond(
      MessageBuilder(content: 'Не удалось удалить сообщение [NotFound]'),
      isEphemeral: true,
    );
    return;
  }

  final database = Dependencies.i.postsDatabase;
  final postData = await database.findPost(message.value);

  // if post can't be found in database, then it's not LFG
  if (postData == null) {
    await interaction.interaction.respond(
      MessageBuilder(content: 'Данное сообщение не содержит LFG [LFGNotFound]'),
      isEphemeral: true,
    );
    return;
  }

  // if author of the post is not the same as author of the command, then it's not LFG of the author
  if (postData.author != interaction.interaction.member?.user?.id.value) {
    print(
      'User "${interaction.interaction.member?.user}" tried to delete LFG of user "${postData.author}"',
    );

    await interaction.interaction.respond(
      MessageBuilder(
        content: 'Вы не можете удалить это LFG, '
            'т.к. не являетесь его автором [NotAuthor]',
      ),
      isEphemeral: true,
    );
    return;
  }

  final lfgManager = Dependencies.i.lfgManager;
  await lfgManager.delete(message.value);

  await interaction.interaction.respond(
    MessageBuilder(content: 'Ваше LFG "${postData.title}" удалено.'),
    isEphemeral: true,
  );
}
