import 'package:nyxx/nyxx.dart' hide Activity;

import '../../../core/data/enums/activity_type.dart';
import '../../../core/utils/context/context.dart';
import '../../../core/utils/dependencies.dart';
import '../../../core/utils/loaders/bot_settings.dart';
import '../../../core/utils/time_convert.dart';
import '../../command_manager/command_manager.dart';
import '../../lfg_manager/data/models/register_activity.dart';

/// Builds `/create` command.
///
/// This command is used for creating new LFG posts.
///
/// This command has 3 subcommands: raid, dungeon, activity.
/// * raid - creates new LFG post for raid activity.
/// * dungeon - creates new LFG post for dungeon activity.
/// * activity - creates new LFG post for custom activity.
CommandCreator createCategoryCommands() {
  return (
    builder: _createAll,
    handlers: {
      'create raid': _createActivityHandler,
      'create dungeon': _createActivityHandler,
      'create activity': _createActivityHandler,
    }
  );
}

Future<void> _createActivityHandler(InteractionCreateEvent<ApplicationCommandInteraction> interaction) async {
  final member = interaction.interaction.member;
  if (member == null) return; // refuse to work with bots

  final userName = member.nick ?? member.user?.username;
  print('User "$userName" is trying to create new raid LFG post');


  final manager = Dependencies.i.lfgManager;
  final settings = Context.root.get<BotSettings>('settings');

  // create command always has 1 subcommand: raid, dungeon, activity.
  // So we can just use first to get options of subcommand.
  // All options for `/create` command are equal for all subcommands.
  final createOptions = interaction.interaction.data.options!.first.options!;

  final name = createOptions.firstWhere((e) => e.name == 'название').value as String;
  final description = createOptions.firstWhere((e) => e.name == 'описание').value as String;
  final date = createOptions.firstWhere((e) => e.name == 'дата').value as String;
  final time = createOptions.firstWhere((e) => e.name == 'время').value as String;
  final timezone = createOptions.firstWhere((e) => e.name == 'часовой_пояс').value as int;

  final activity = settings.activityData.activities.where((e) => e.name == name).first;

  print('Creating new LFG post for user "$userName" with activity "$name" and description "$description"');
  await manager.create(
    interaction: interaction,
    builder: LFGPostBuilder.fromActivity(
      activity: activity,
      authorID: member.user!.id,
      description: description,
      timezone: timezone,
      unixDate: TimeConverters.userInputToUnix(timeInput: time, dateInput: date, timezoneInput: timezone),
    ),
  );
}

List<CommandOptionChoiceBuilder<String>>? _getActivityChoices(LFGType type) {
  final settings = Context.root.get<BotSettings>('settings');
  final activities = settings.activityData.activities.where((e) => e.type == type);

  if (activities.isEmpty) return null;

  return activities.map((e) => CommandOptionChoiceBuilder<String>(name: e.name, value: e.name)).toList();
}

List<CommandOptionChoiceBuilder<int>> _getTimezoneChoices() {
  final settings = Context.root.get<BotSettings>('settings');
  final timezones = settings.botConfig.timezones;

  return timezones.entries.map((e) => CommandOptionChoiceBuilder<int>(name: e.key, value: e.value)).toList();
}

ApplicationCommandBuilder _createAll() {
  return ApplicationCommandBuilder(
    name: 'create',
    description: 'Создать активность',
    type: ApplicationCommandType.chatInput,
    options: LFGType.values
        .map((type) => CommandOptionBuilder.subCommand(
              name: type.name,
              description: 'Создать сбор на активность',
              options: [
                CommandOptionBuilder.string(
                  name: 'название',
                  description: 'Введите название активности',
                  choices: _getActivityChoices(type),
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
                CommandOptionBuilder.integer(
                  name: 'часовой_пояс',
                  description: 'Введите ваш текущий часовой пояс',
                  choices: _getTimezoneChoices(),
                  isRequired: true,
                ),
              ],
            ),)
        .toList(),
  );
}
