import 'package:l/l.dart';

import '../../../../core/l10n/messages.dart';
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
      description: createCommandDescription,
      type: ApplicationCommandType.chatInput,
      options: [
        CommandOptionBuilder.subCommand(
          name: 'activity',
          description: createCommandSubcommandDescription,
          options: [
            CommandOptionBuilder.string(
              name: commandOptionNameKey,
              description: commandOptionNameDescription,
              choices: await _getActivityChoices(services.settings),
              isRequired: true,
            ),
            CommandOptionBuilder.string(
              name: commandOptionDescriptionKey,
              description: commandOptionDescriptionDescription,
              isRequired: true,
            ),
            CommandOptionBuilder.string(
              name: commandOptionDateKey,
              description: commandOptionDateDescription,
              isRequired: true,
            ),
            CommandOptionBuilder.string(
              name: commandOptionTimeKey,
              description: commandOptionTimeDescription,
              isRequired: true,
            ),
            CommandOptionBuilder.integer(
              name: commandOptionTimezoneKey,
              description: commandOptionTimezoneDescription,
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
      l.i('LFG channel is not set');
      return;
    }

    if (channelLfg != event.interaction.channelId?.value) {
      return event.interaction.respond(
        MessageBuilder(content: createCommandChannelRestriction(channelLfg.toString())),
        isEphemeral: true,
      );
    }

    // in this handle in doesn't matter which type of activity was received,
    // so ignore `commandName` parameter

    final member = event.interaction.member;
    if (member == null) return; // refuse to work with bots

    final userName = member.nick ?? member.user?.username;
    l.i('User "$userName" is trying to create new raid LFG post');

    final manager = services.lfgManager;

    // create command always has 1 subcommand: raid, dungeon, activity.
    // So we can just use first to get options of subcommand.
    // All options for `/create` command are equal for all subcommands.
    final createOptions = event.interaction.data.options!.first.options!;

    final name = createOptions.firstWhere((e) => e.name == commandOptionNameKey).value as String;
    final description = createOptions.firstWhere((e) => e.name == commandOptionDescriptionKey).value as String;
    final date = createOptions.firstWhere((e) => e.name == commandOptionDateKey).value as String;
    final time = createOptions.firstWhere((e) => e.name == commandOptionTimeKey).value as String;
    final timezone = createOptions.firstWhere((e) => e.name == commandOptionTimezoneKey).value as int;

    final activity = await services.settings.getActivity(name);

    l.i('Creating new LFG post for user "$userName" with activity "$name" and description "$description"');
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
