import 'package:nyxx/nyxx.dart';

import '../../core/bot/core.dart';
import '../../core/utils/context/context.dart';
import '../../core/utils/database/tables/posts.dart';
import '../command_manager/command_manager.dart';
import '../lfg_manager/lfg_manager.dart';
import '../scheduler/scheduler.dart';

part 'delete_handler.dart';
part 'health_handler.dart';

/// Builds `/admin` command.
///
/// This command is used by administrators to provide additional control over LFG.
///
/// This command has 2 subcommands: health, delete.
/// * health - shows some useful meta info about bot such as: ping, scheduled LFGs, total of all LFGs.
/// * delete - deletes LFG post regardless of its author.

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
        description: 'Удалить LFG',
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