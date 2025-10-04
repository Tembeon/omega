import 'dart:async';
import 'dart:io';

import 'package:l/l.dart';

import '../../../../core/data/models/activity_data.dart';
import '../../../../core/l10n/messages.dart';
import '../../../../core/utils/event_parsers.dart';
import '../../../interactor/component_interceptor.dart';
import '../../../interactor/interactor_component.dart';
import '../../../settings/settings.dart';
import '../../interceptors/always_user_interceptor.dart';

class ActivityCommandsComponent extends InteractorCommandComponent {
  const ActivityCommandsComponent();

  @override
  Set<UpdateEvent> get updateWhen => {
        UpdateEvent.activitiesUpdated,
      };

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      defaultMemberPermissions: Permissions.administrator,
      name: 'activity',
      description: activityCommandDescription,
      type: ApplicationCommandType.chatInput,
      options: [
        // add activity command
        CommandOptionBuilder.subCommand(
          name: 'add',
          description: activityAddDescription,
          options: [
            CommandOptionBuilder.string(
              name: 'name',
              description: commandOptionNameDescription,
              isRequired: true,
            ),
            CommandOptionBuilder.integer(
              name: 'members',
              description: promptEnterMaxMembers,
              isRequired: true,
            ),
            CommandOptionBuilder.string(
              name: 'banner',
              description: promptEnterBannerUrl,
              isRequired: false,
            ),
            CommandOptionBuilder.attachment(
              name: 'banner_file',
              description: promptUploadBanner,
              isRequired: false,
            ),
          ],
        ),
        // remove activity command
        CommandOptionBuilder.subCommand(
          name: 'remove',
          description: activityRemoveDescription,
          options: [
            CommandOptionBuilder.string(
              name: 'name',
              description: commandOptionNameDescription,
              choices: await _getActivityChoices(services.settings),
              isRequired: true,
            ),
          ],
        ),
        CommandOptionBuilder.subCommandGroup(
          name: 'roles',
          description: activityRolesGroupDescription,
          options: [
            CommandOptionBuilder.subCommand(
              name: 'add',
              description: activityRolesAddDescription,
              options: [
                CommandOptionBuilder.string(
                  name: 'role',
                  description: promptEnterRoleNameWithEmoji,
                  isRequired: true,
                  maxLength: 100,
                  minLength: 1,
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'remove',
              description: activityRolesRemoveDescription,
              options: [
                CommandOptionBuilder.string(
                  name: 'role',
                  description: promptEnterRoleName,
                  isRequired: true,
                  maxLength: 100,
                  minLength: 1,
                  choices: await _getAllRoles(services.settings),
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'connect',
              description: activityRolesConnectDescription,
              options: [
                CommandOptionBuilder.string(
                  name: 'role',
                  description: promptEnterRoleName,
                  isRequired: true,
                  maxLength: 100,
                  minLength: 1,
                  choices: await _getAllRoles(services.settings),
                ),
                CommandOptionBuilder.integer(
                  name: 'quantity',
                  description: promptEnterRoleQuantity,
                  isRequired: true,
                  minValue: 1,
                ),
                CommandOptionBuilder.string(
                  name: 'activity',
                  description: commandOptionNameDescription,
                  choices: await _getActivityChoices(services.settings),
                  isRequired: true,
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'disconnect',
              description: activityRolesDisconnectDescription,
              options: [
                CommandOptionBuilder.string(
                  name: 'role',
                  description: promptEnterRoleName,
                  isRequired: true,
                  maxLength: 100,
                  minLength: 1,
                  choices: await _getAllRoles(services.settings),
                ),
                CommandOptionBuilder.string(
                  name: 'activity',
                  description: commandOptionNameDescription,
                  choices: await _getActivityChoices(services.settings),
                  isRequired: true,
                  maxLength: 100,
                  minLength: 1,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<List<CommandOptionChoiceBuilder<String>>> _getActivityChoices(Settings settings) async {
    final activities = await settings.getActivities();

    return activities.map((e) => CommandOptionChoiceBuilder<String>(name: sanitize(e.name), value: e.name)).toList();
  }

  @override
  Set<ComponentInterceptor> get interceptors => {
        ...super.interceptors,
        const OnlyAdminUserInterceptor(),
      };

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async =>
      switch (commandName) {
        'activity add' => _handleActivityAdd(event, services),
        'activity remove' => _handleActivityRemove(event, services),
        'activity roles add' => _handleActivityRolesAdd(event, services),
        'activity roles remove' => _handleActivityRolesRemove(event, services),
        'activity roles connect' => _handleActivityRolesConnect(event, services),
        'activity roles disconnect' => _handleActivityRolesDisconnect(event, services),
        _ => throw UnsupportedError('Unsupported command: $commandName'),
      };

  Future<void> _handleActivityAdd(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    unawaited(event.interaction.acknowledge(isEphemeral: false));
    String? bannerPath;
    final options = event.interaction.data.options!;
    final activityName = findInOption<String>('name', options)!;
    final maxMembers = findInOption<int>('members', options)!;
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
        name: activityName,
        maxMembers: maxMembers,
        bannerUrl: bannerPath,
        roles: null,
        enabled: true,
      ),
    );

    await event.interaction.respond(
      MessageBuilder(content: activityAddedMessage(activityName)),
      isEphemeral: false,
    );
  }

  Future<void> _handleActivityRemove(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final activityName = findInOption<String>('name', event.interaction.data.options!)!;

    final setting = services.settings;
    await setting.removeActivity(activityName);

    await event.interaction.respond(
      MessageBuilder(content: activityRemovedMessage(activityName)),
      isEphemeral: false,
    );
  }

  Future<List<CommandOptionChoiceBuilder<String>>?> _getAllRoles(Settings settings) async {
    final roles = await settings.getAllRoles();
    return roles.map((e) => CommandOptionChoiceBuilder<String>(name: sanitize(e), value: e)).toList();
  }

  Future<void> _handleActivityRolesAdd(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final role = findInOption<String>('role', event.interaction.data.options!)!;

    final setting = services.settings;
    await setting.addRole(role);

    await event.interaction.respond(
      MessageBuilder(content: roleAddedToDatabaseMessage(role)),
      isEphemeral: true,
    );
  }

  Future<void> _handleActivityRolesRemove(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final role = findInOption<String>('role', event.interaction.data.options!)!;

    final setting = services.settings;
    await setting.removeRole(role);

    await event.interaction.respond(
      MessageBuilder(content: roleRemovedFromDatabaseMessage(role)),
      isEphemeral: true,
    );
  }

  Future<void> _handleActivityRolesConnect(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final role = findInOption<String>('role', event.interaction.data.options!)!;
    final activity = findInOption<String>('activity', event.interaction.data.options!)!;
    final quantity = findInOption<int>('quantity', event.interaction.data.options!)!;

    final setting = services.settings;
    await setting.addRoleToActivity(activity, role, quantity);

    await event.interaction.respond(
      MessageBuilder(content: roleConnectedToActivityMessage(role, activity)),
      isEphemeral: true,
    );
  }

  Future<void> _handleActivityRolesDisconnect(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final role = findInOption<String>('role', event.interaction.data.options!)!;
    final activity = findInOption<String>('activity', event.interaction.data.options!)!;

    final setting = services.settings;
    await setting.removeRoleFromActivity(activity, role);

    await event.interaction.respond(
      MessageBuilder(content: roleDisconnectedFromActivityMessage(role, activity)),
      isEphemeral: true,
    );
  }
}
