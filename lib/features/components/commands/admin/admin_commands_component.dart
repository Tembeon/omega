import '../../../../core/l10n/messages.dart';
import '../../../../core/utils/event_parsers.dart';
import '../../../interactor/component_interceptor.dart';
import '../../../interactor/interactor_component.dart';
import '../../interceptors/always_user_interceptor.dart';

/// {@template AdminCommandComponent}
/// Builds `/admin` command.
///
/// This command is used by administrators to provide additional control over LFG.
///
/// This command has 2 subcommands: health, delete.
/// * health - shows some useful meta info about bot such as: ping, scheduled LFGs, total of all LFGs.
/// * delete - deletes LFG post regardless of its author.
/// {@endtemplate}
class AdminCommandComponent extends InteractorCommandComponent {
  /// {@macro AdminCommandComponent}
  const AdminCommandComponent();

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      defaultMemberPermissions: Permissions.administrator,
      name: 'admin',
      description: adminCommandDescription,
      type: ApplicationCommandType.chatInput,
      options: [
        // delete LFG command
        CommandOptionBuilder.subCommand(
          name: 'delete',
          description: adminDeleteSubcommandDescription,
          options: [
            CommandOptionBuilder.string(
              name: 'message_id',
              description: adminDeleteMessageIdDescription,
              isRequired: true,
            ),
          ],
        ),
        // health command
        CommandOptionBuilder.subCommand(
          name: 'health',
          description: adminHealthDescription,
          options: [],
        ),
        // set commands
        CommandOptionBuilder.subCommandGroup(
          name: 'set',
          description: adminSetGroupDescription,
          options: [
            CommandOptionBuilder.subCommand(
              name: 'lfg_channel',
              description: adminSetLfgChannelDescription,
              options: [
                CommandOptionBuilder.channel(
                  name: 'channel',
                  description: adminChannelOptionDescription,
                  channelTypes: [ChannelType.guildText],
                  isRequired: false,
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'promo_channel',
              description: adminSetPromoChannelDescription,
              options: [
                CommandOptionBuilder.channel(
                  name: 'channel',
                  description: adminChannelOptionDescription,
                  channelTypes: [ChannelType.guildText],
                  isRequired: false,
                ),
              ],
            ),
          ],
        ),
        CommandOptionBuilder.subCommandGroup(
          name: 'promotes',
          description: adminPromotesGroupDescription,
          options: [
            CommandOptionBuilder.subCommand(
              name: 'add',
              description: adminPromotesAddDescription,
              options: [
                CommandOptionBuilder.string(
                  name: 'message',
                  description: adminPromotesTemplateHelp,
                  isRequired: true,
                ),
                CommandOptionBuilder.integer(
                  name: 'weight',
                  description: adminPromotesWeightDescription,
                  isRequired: false,
                  minValue: 1,
                  maxValue: 10,
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'remove',
              description: adminPromotesRemoveDescription,
              options: [
                CommandOptionBuilder.integer(
                  name: 'id',
                  description: adminPromotesMessageIdDescription,
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'list',
              description: adminPromotesListDescription,
              options: [],
            ),
          ],
        ),
        CommandOptionBuilder.subCommandGroup(
          name: 'bot',
          description: adminBotGroupDescription,
          options: [
            CommandOptionBuilder.subCommand(
              name: 'channels',
              description: adminBotChannelsDescription,
              options: [],
            ),
            CommandOptionBuilder.subCommand(
              name: 'roles',
              description: adminBotRolesDescription,
              options: [
                CommandOptionBuilder.string(
                  name: 'activity',
                  description: adminActivityOptionDescription,
                  isRequired: true,
                ),
                CommandOptionBuilder.string(
                  name: 'role',
                  description: adminRoleOptionDescription,
                  choices: await services.settings.getAllRoles().then(
                        (roles) => roles
                            .map(
                              (role) => CommandOptionChoiceBuilder(name: role, value: role),
                            )
                            .toList(),
                      ),
                  isRequired: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );
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
        'admin health' => _healthHandler(event, services),
        'admin delete' => _deleteHandler(event, services),
        'admin set lfg_channel' => _setLFGChannelHandler(event, services),
        'admin set promo_channel' => _setPromoChannelHandler(event, services),
        'admin promotes add' => _addPromoteMessageHandler(event, services),
        'admin promotes remove' => _removePromoteMessageHandler(event, services),
        'admin promotes list' => _listPromoteMessageHandler(event, services),
        'admin bot channels' => _botChannelsHandler(event, services),
        'admin bot roles' => _rolesHandler(event, services),
        _ => throw UnsupportedError('Unsupported command: $commandName'),
      };

  Future<void> _healthHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    // To calculate the ping we will take the time when the command was executed [timestamp]
    // and the time when it was sent [now] and subtract them.
    final now = DateTime.now().millisecondsSinceEpoch;
    final timestamp = event.interaction.id.timestamp.millisecondsSinceEpoch;

    final database = services.postsDatabase;
    final scheduler = services.postScheduler;

    final response = StringBuffer()
      ..writeln(adminHealthStatsHeader)
      ..writeln(adminHealthPing(now - timestamp))
      ..writeln()
      ..writeln(adminHealthLfgHeader);

    // If any exception was caught, then show it to user.
    try {
      response.writeln(adminHealthScheduledCount(scheduler.getScheduledPostsCount()));
    } on Object catch (e) {
      response.writeln(adminHealthSchedulerUnavailable(e.toString()));
    }

    try {
      final totalPosts = await database.getAllPostsCount();
      response.writeln(adminHealthTotalCount(totalPosts ?? 0));
    } on Object catch (e) {
      response.writeln(adminHealthDatabaseUnavailable(e.toString()));
    }

    await event.interaction.respond(
      MessageBuilder(content: response.toString()),
      isEphemeral: true,
    );
  }

  Future<void> _deleteHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final member = event.interaction.member!;
    final userName = member.nick ?? member.user?.username;

    // This is designed to extract the value of the message_id parameter from the interaction data.
    final messageId = event.interaction.data.options!.first.options!.firstWhere(
      (e) => e.name == 'message_id',
    );
    final database = services.postsDatabase;

    // All LFG IDs are unique, so we look for the first entry where the [message_id] is exactly what the user provided.
    final postData = await database.findPost(int.parse(messageId.value as String));

    // if post can't be found in database, then it's not LFG
    if (postData == null) {
      await event.interaction.respond(
        MessageBuilder(content: selectedMessageIsNotLfg),
        isEphemeral: true,
      );
      return;
    }

    final lfgManager = services.lfgManager;

    await lfgManager.delete(int.parse(messageId.value as String));

    await event.interaction.respond(
      MessageBuilder(
        content: adminDeleteSuccess(userName ?? commonUnknownUser, postData.title),
      ),
      isEphemeral: true,
    );
  }

  Future<void> _setLFGChannelHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final channelValue = findInOption<String>('channel', event.interaction.data.options!);
    final channel = channelValue == null ? null : Snowflake(int.parse(channelValue));
    final settings = services.settings;

    await settings.updateLFGChannel(channel?.value);

    await event.interaction.respond(
      MessageBuilder(content: channel != null ? adminSetLfgChannelSet : adminSetLfgChannelCleared),
      isEphemeral: true,
    );
  }

  Future<void> _setPromoChannelHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final channelValue = findInOption<String>('channel', event.interaction.data.options!);
    final channel = channelValue == null ? null : Snowflake(int.parse(channelValue));

    final settings = services.settings;

    await settings.updatePromotesChannel(channel?.value);

    await event.interaction.respond(
      MessageBuilder(content: channel != null ? adminSetPromoChannelSet : adminSetPromoChannelCleared),
      isEphemeral: true,
    );
  }

  Future<void> _addPromoteMessageHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final message = findInOption<String>('message', event.interaction.data.options!);
    final weight = findInOption<int>('weight', event.interaction.data.options!) ?? 1;
    if (message == null) return;

    final settings = services.settings;
    await settings.addPromoteMessage(message, weight);

    await event.interaction.respond(
      MessageBuilder(content: adminPromoteAdded),
      isEphemeral: true,
    );
  }

  Future<void> _removePromoteMessageHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final id = findInOption<int>('id', event.interaction.data.options!);
    if (id == null) return;

    final settings = services.settings;
    await settings.removePromoteMessage(id);

    await event.interaction.respond(
      MessageBuilder(content: adminPromoteRemoved),
      isEphemeral: true,
    );
  }

  Future<void> _listPromoteMessageHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final settings = services.settings;
    final messages = await settings.getPromoteMessages();

    final response = StringBuffer()
      ..writeln(adminPromoteListHeader)
      ..writeln();

    for (final message in messages.entries) {
      response.writeln('${message.key}: ${message.value}');
    }

    await event.interaction.respond(
      MessageBuilder(content: response.toString()),
      isEphemeral: true,
    );
  }

  Future<void> _botChannelsHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final settings = services.settings;
    final lfgChannel = await settings.getLFGChannel();
    final promoChannel = await settings.getPromotesChannel();

    final StringBuffer response = StringBuffer()
      ..write(adminBotChannelPrefix)
      ..writeln(lfgChannel != null ? '<#$lfgChannel>' : commonValueNotSet)
      ..write(adminBotPromoChannelPrefix)
      ..write(promoChannel != null ? '<#$promoChannel>' : commonValueNotSet);

    await event.interaction.respond(
      MessageBuilder(
        content: response.toString(),
      ),
      isEphemeral: true,
    );
  }

  Future<void> _rolesHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final activityRaw = findInOption<String>('activity', event.interaction.data.options!)!;
    final activityId = int.parse(activityRaw);
    final roleOption = findInOption<String>('role', event.interaction.data.options!);
    if (roleOption == null) return;
    final role = roleOption;

    final settings = services.settings;
    final roles = await settings.getFreeRoleCount(id: activityId, role: role);

    await event.interaction.respond(
      MessageBuilder(content: adminRolesAvailability(activityRaw, roles, role)),
      isEphemeral: true,
    );
  }
}
