import '../../core/data/enums/activity_type.dart';
import '../../core/utils/context/context.dart';
import '../../core/utils/loaders/bot_settings.dart';
import '../../core/utils/time_convert.dart';
import '../interactor/interactor_component.dart';
import '../lfg_manager/data/models/register_activity.dart';

// TODO: migrate to user settings
List<CommandOptionChoiceBuilder<String>>? _getActivityChoices(LFGType type) {
  final settings = Context.root.get<BotSettings>('settings');
  final activities = settings.activityData.activities.where((e) => e.type == type);

  if (activities.isEmpty) return null;

  return activities.map((e) => CommandOptionChoiceBuilder<String>(name: e.name, value: e.name)).toList();
}

// TODO: migrate to user settings
List<CommandOptionChoiceBuilder<int>> _getTimezoneChoices() {
  final settings = Context.root.get<BotSettings>('settings');
  final timezones = settings.botConfig.timezones;

  return timezones.entries.map((e) => CommandOptionChoiceBuilder<int>(name: e.key, value: e.value)).toList();
}

/// {@template CreateCommandComponent}
/// Component for `/create` command.
///
/// This component is used to create new LFG post.
///
/// Supported subcommands:
/// * `/create raid`
/// * `/create dungeon`
/// * `/create activity`
///
/// In future, subcommands should be automatically generated from user-settings.
/// {@endtemplate}
class CreateCommandComponent extends InteractorCommandComponent {
  /// {@macro CreateCommandComponent}
  const CreateCommandComponent();

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      name: 'create',
      description: 'Создать активность',
      type: ApplicationCommandType.chatInput,
      options: LFGType.values
          .map(
            (type) => CommandOptionBuilder.subCommand(
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
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    // in this handle in doesn't matter which type of activity was received,
    // so ignore `commandName` parameter

    final member = event.interaction.member;
    if (member == null) return; // refuse to work with bots

    final userName = member.nick ?? member.user?.username;
    print('User "$userName" is trying to create new raid LFG post');

    final manager = services.lfgManager;
    final settings = Context.root.get<BotSettings>('settings');

    // create command always has 1 subcommand: raid, dungeon, activity.
    // So we can just use first to get options of subcommand.
    // All options for `/create` command are equal for all subcommands.
    final createOptions = event.interaction.data.options!.first.options!;

    final name = createOptions.firstWhere((e) => e.name == 'название').value as String;
    final description = createOptions.firstWhere((e) => e.name == 'описание').value as String;
    final date = createOptions.firstWhere((e) => e.name == 'дата').value as String;
    final time = createOptions.firstWhere((e) => e.name == 'время').value as String;
    final timezone = createOptions.firstWhere((e) => e.name == 'часовой_пояс').value as int;

    final activity = settings.activityData.activities.where((e) => e.name == name).first;

    print('Creating new LFG post for user "$userName" with activity "$name" and description "$description"');
    await manager.create(
      interaction: event,
      builder: LFGPostBuilder.fromActivity(
        activity: activity,
        authorID: member.user!.id,
        description: description,
        timezone: timezone,
        unixDate: TimeConverters.userInputToUnix(timeInput: time, dateInput: date, timezoneInput: timezone),
      ),
    );
  }
}
