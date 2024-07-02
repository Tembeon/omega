import 'dart:async';

import 'package:nyxx/nyxx.dart';

import '../../core/utils/context/context.dart';
import '../../core/utils/database/tables/posts.dart';
import '../command_manager/command_manager.dart';
import '../lfg_manager/lfg_manager.dart';

CommandCreator adminCategoryCommands() {
  return (
    builder: _createAdminCommands,
    handlers: {
      'admin delete': _deleteLFGHandler,
    }
  );
}

Future<void> _deleteLFGHandler(
  InteractionCreateEvent<ApplicationCommandInteraction> interaction,
) async {
  final member = interaction.interaction.member;
  if (member == null) return; // refuse to work with bots
  if (!(member.permissions?.has(Permissions.administrator) ?? false)) return; // Check if user is administrator

  final messageId = interaction.interaction.data.options!.first.options!
      .firstWhere((e) => e.name == 'message_id');
  final database = Context.root.get<PostsDatabase>('db');
  final postData =
      await database.findPost(int.parse(messageId.value as String));

  // if post can't be found in database, then it's not LFG
  if (postData == null) {
    await interaction.interaction.respond(
      MessageBuilder(content: 'Данное сообщение не содержит LFG [LFGNotFound]'),
      isEphemeral: true,
    );
    return;
  }

  final lfgManager = Context.root.get<ILFGManager>('manager');

  await lfgManager.delete(int.parse(messageId.value as String));

  await interaction.interaction.respond(
    MessageBuilder(
      content:
          'LFG сообщение "${postData.author}", "${postData.title}" удалено.',
    ),
    isEphemeral: true,
  );
}

ApplicationCommandBuilder _createAdminCommands() {
  return ApplicationCommandBuilder(
    defaultMemberPermissions: Permissions.administrator,
    name: 'admin',
    description: 'Команды администратора',
    type: ApplicationCommandType.chatInput,
    options: [
      CommandOptionBuilder.subCommand(
        name: 'delete',
        description: 'Удалить LFG-сообщение',
        options: [
          CommandOptionBuilder.string(
            name: 'message_id',
            description: 'ID сообщения для удаления',
            isRequired: true,
          ),
        ],
      ),
      CommandOptionBuilder.subCommand(
        name: 'health',
        description: 'Узнать состояние бота',
        options: [],
      ),
    ],
  );
}
