import 'dart:async';
import 'dart:io';

import 'package:l/l.dart';

import '../../../../core/data/models/activity_data.dart';
import '../../../../core/utils/event_parsers.dart';
import '../../../interactor/interactor_component.dart';
import '../../../settings/settings.dart';

class ActivityCommandsComponent extends InteractorCommandComponent {
  const ActivityCommandsComponent();

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      defaultMemberPermissions: Permissions.administrator,
      name: 'activity',
      description: 'Настройки активностей',
      type: ApplicationCommandType.chatInput,
      options: [
        // add activity command
        CommandOptionBuilder.subCommand(
          name: 'add',
          description: 'Добавить активность',
          options: [
            CommandOptionBuilder.string(
              name: 'name',
              description: 'Введите название активности',
              isRequired: true,
            ),
            CommandOptionBuilder.integer(
              name: 'members',
              description: 'Введите максимальное количество участников',
              isRequired: true,
            ),
            CommandOptionBuilder.string(
              name: 'banner',
              description: 'Введите URL баннера',
              isRequired: false,
            ),
            CommandOptionBuilder.attachment(
              name: 'banner_file',
              description: 'Или загрузите баннер',
              isRequired: false,
            ),
          ],
        ),
        // remove activity command
        CommandOptionBuilder.subCommand(
          name: 'remove',
          description: 'Удалить активность',
          options: [
            CommandOptionBuilder.string(
              name: 'название',
              description: 'Введите название активности',
              choices: await _getActivityChoices(services.settings),
              isRequired: true,
            ),
          ],
        ),
      ],
    );
  }

  Future<List<CommandOptionChoiceBuilder<String>>> _getActivityChoices(Settings settings) async {
    final activities = await settings.getActivities();

    return activities.map((e) => CommandOptionChoiceBuilder<String>(name: e.name, value: e.name)).toList();
  }

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final member = event.interaction.member;

    if (member == null) return; // refuse to work with bots
    if (!(member.permissions?.has(Permissions.administrator) ?? false)) {
      return; // Check if user is administrator
    }

    return switch (commandName) {
      'activity add' => _handleActivityAdd(event, services),
      'activity remove' => _handleActivityRemove(event, services),
      _ => throw UnsupportedError('Unsupported command: $commandName'),
    };
  }

  Future<void> _handleActivityAdd(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    unawaited(event.interaction.acknowledge(isEphemeral: false));
    String? bannerPath;
    final options = event.interaction.data.options!;
    final activityName = findInOption<String>('name', options);
    final maxMembers = findInOption<int>('members', options);
    final bannerUrl = findInOption<String>('banner', options);
    final bannerFileValue = findInOption<String>('banner_file', options);
    final bannerFile = bannerFileValue != null ? Snowflake(int.parse(bannerFileValue)) : null;
    final bannerFileAttachment = bannerFile != null ? event.interaction.data.resolved!.attachments![bannerFile] : null;

    if (bannerFileAttachment != null) {
      // download file to `/data/attachments/images` folder

      l.d('[ActivityCommandsComponent] downloading BannerFileAttachment: ${bannerFileAttachment.url}');
      final httpClient = HttpClient()..userAgent = 'omega_bot';
      final request = await httpClient.getUrl(bannerFileAttachment.url);
      final response = await request.close();
      final file = File('data/attachments/images/${bannerFileAttachment.fileName}');
      if (!file.existsSync()) {
        await file.create(recursive: true);
      }
      await response.pipe(file.openWrite());
      l.d('[ActivityCommandsComponent] downloaded BannerFileAttachment: ${file.path}');
      bannerPath = file.uri.toFilePath();
    } else {
      bannerPath = bannerUrl;
    }

    final setting = services.settings;
    await setting.addActivity(
      ActivityData(
        name: activityName!,
        maxMembers: maxMembers!,
        bannerUrl: bannerPath,
        roles: null,
        enabled: true,
      ),
    );

    await event.interaction.respond(
      MessageBuilder(content: 'Активность "$activityName" добавлена'),
      isEphemeral: false,
    );
  }

  Future<void> _handleActivityRemove(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {}
}
