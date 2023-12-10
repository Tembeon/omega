import 'package:nyxx/nyxx.dart';

import '../../../core/utils/context/context.dart';
import '../../../core/utils/loaders/bot_settings.dart';
import '../../command_manager/command_manager.dart';
import '../../lfg_manager/data/models/register_activity.dart';
import '../../lfg_manager/lfg_manager.dart';

CommandCreator createRaidCommand() {
  return (
    builder: _createBuilder,
    handler: _createHandler,
  );
}

Future<void> _createHandler(InteractionCreateEvent<ApplicationCommandInteraction> interaction) async {
  final user = interaction.interaction.member?.id;
  print('User "$user" is trying to create new LFG post');
  if (user == null) return; // refuse to work with bots

  final manager = Context.root.get<LFGManager>('manager');
  final settings = Context.root.get<BotSettings>('settings');

  // create command always has 1 subcommand: raid, dungeon, custom.
  // So we can just use first to get options of subcommand.
  // All options for `/create` command are equal for all subcommands.
  final createOptions = interaction.interaction.data.options!.first.options!;

  final name = createOptions.firstWhere((e) => e.name == 'название').value as String;
  final description = createOptions.firstWhere((e) => e.name == 'описание').value as String;

  final activity = settings.activityData.activities.where((e) => e.name == name).first;

  print('Creating new LFG post for user "$user" with activity "$name" and description "$description"');
  await manager.create(
    interaction: interaction,
    builder: LFGPostBuilder.fromActivity(
      activity: activity,
      authorID: user,
      description: description,
      unixDate: 1702933200000,
    ),
  );
}

ApplicationCommandBuilder _createBuilder() {
  return ApplicationCommandBuilder(
    name: 'create',
    description: 'Создать активность',
    type: ApplicationCommandType.chatInput,
    options: [
      CommandOptionBuilder.subCommand(
        name: 'raid',
        description: 'Создать рейд',
        options: [
          CommandOptionBuilder.string(
            name: 'название',
            description: 'Введите название активности',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'описание',
            description: 'Введите описание активности',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'дата',
            description: 'Введите дату начала активности [15 01 2023]',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'время',
            description: 'Введите время начала активности [15 01]',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'часовой_пояс',
            description: 'Введите ваш текущий часовой пояс',
            isRequired: true,
          ),
        ],
      ),
    ],
  );
}
