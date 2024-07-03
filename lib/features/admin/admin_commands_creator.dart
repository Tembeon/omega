import 'package:nyxx/nyxx.dart';

import '../../core/bot/core.dart';
import '../../core/utils/context/context.dart';
import '../../core/utils/database/tables/posts.dart';
import '../command_manager/command_manager.dart';
import '../lfg_manager/lfg_manager.dart';
import '../scheduler/scheduler.dart';

part 'delete_handler.dart';
part 'health_handler.dart';

CommandCreator adminCategoryCommands() {
  return (
    builder: _createAdminCommands,
    handlers: {
      'admin delete': _deleteLFGHandler,
      'admin health': _healthBotHandler,
    }
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
