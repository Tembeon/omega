import '../../../../core/utils/event_parsers.dart';
import '../../../../core/utils/time_convert.dart';
import '../../../interactor/interactor_component.dart';
import '../../../lfg_manager/data/models/register_activity.dart';
import '../../../settings/settings.dart';

/// {@template CreateCommandComponent}
/// Component for `/create` command.
///
/// This component is used to create new LFG post.
///
/// {@endtemplate}
class CreateCommandComponent extends InteractorCommandComponent {
  /// {@macro CreateCommandComponent}
  const CreateCommandComponent();

  @override
  Set<UpdateEvent> get updateWhen => {
        UpdateEvent.timezonesUpdated,
        UpdateEvent.activitiesUpdated,
        UpdateEvent.lfgChannelUpdated,
      };

  @override
  Future<bool> enabledWhen(Services services) async {
    return await services.settings.getLFGChannel() != null;
  }

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      name: 'create',
      description: 'Создать активность',
      type: ApplicationCommandType.chatInput,
      options: [
        CommandOptionBuilder.subCommand(
          name: 'activity',
          description: 'Создать сбор на активность',
          options: [
            CommandOptionBuilder.string(
              name: 'название',
              description: 'Введите название активности',
              choices: await _getActivityChoices(services.settings),
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
              choices: await _getTimezoneChoices(services.settings),
              isRequired: true,
            ),
          ],
        ),
      ],
    );
  }

  Future<List<CommandOptionChoiceBuilder<String>>?> _getActivityChoices(Settings settings) async {
    final activities = await settings.getActivitiesNames();

    if (activities.isEmpty) return null;

    return activities.map((e) => CommandOptionChoiceBuilder<String>(name: sanitize(e), value: e)).toList();
  }

  Future<List<CommandOptionChoiceBuilder<int>>> _getTimezoneChoices(Settings settings) async {
    final timezones = await settings.getTimezones();

    return timezones.entries.map((e) => CommandOptionChoiceBuilder<int>(name: e.key, value: e.value)).toList();
  }

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final channelLfg = await services.settings.getLFGChannel();
    if (channelLfg == null) {
      print('LFG channel is not set');
      return;
    }

    if (channelLfg != event.interaction.channelId?.value) {
      return event.interaction.respond(
        MessageBuilder(content: 'Команда доступна только в канале для поиска группы: <#$channelLfg>'),
        isEphemeral: true,
      );
    }

    // in this handle in doesn't matter which type of activity was received,
    // so ignore `commandName` parameter

    final member = event.interaction.member;
    if (member == null) return; // refuse to work with bots

    final userName = member.nick ?? member.user?.username;
    print('User "$userName" is trying to create new raid LFG post');

    final manager = services.lfgManager;

    // create command always has 1 subcommand: raid, dungeon, activity.
    // So we can just use first to get options of subcommand.
    // All options for `/create` command are equal for all subcommands.
    final createOptions = event.interaction.data.options!.first.options!;

    final name = createOptions.firstWhere((e) => e.name == 'название').value as String;
    final description = createOptions.firstWhere((e) => e.name == 'описание').value as String;
    final date = createOptions.firstWhere((e) => e.name == 'дата').value as String;
    final time = createOptions.firstWhere((e) => e.name == 'время').value as String;
    final timezone = createOptions.firstWhere((e) => e.name == 'часовой_пояс').value as int;

    final activity = await services.settings.getActivity(name);

    print('Creating new LFG post for user "$userName" with activity "$name" and description "$description"');
    await manager.create(
      interaction: event,
      builder: LFGPostBuilder(
        activity: activity,
        authorID: member.user!.id,
        description: description,
        timezone: timezone,
        unixDate: TimeConverters.userInputToUnix(timeInput: time, dateInput: date, timezoneInput: timezone),
      ),
    );
  }
}
