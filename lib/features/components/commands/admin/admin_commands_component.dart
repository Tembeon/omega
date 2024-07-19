import '../../../../core/utils/event_parsers.dart';
import '../../../interactor/interactor_component.dart';

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
      description: 'Команды администратора',
      type: ApplicationCommandType.chatInput,
      options: [
        // delete LFG command
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
        // health command
        CommandOptionBuilder.subCommand(
          name: 'health',
          description: 'Узнать состояние бота',
          options: [],
        ),
        // set commands
        CommandOptionBuilder.subCommandGroup(
          name: 'set',
          description: 'Настройки бота',
          options: [
            CommandOptionBuilder.subCommand(
              name: 'lfg_channel',
              description: 'Установить LFG канал',
              options: [
                CommandOptionBuilder.channel(
                  name: 'channel',
                  description: 'канал',
                  channelTypes: [ChannelType.guildText],
                  isRequired: false,
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'promo_channel',
              description: 'Установить канал для оповещений о LFG',
              options: [
                CommandOptionBuilder.channel(
                  name: 'channel',
                  description: 'канал',
                  channelTypes: [ChannelType.guildText],
                  isRequired: false,
                ),
              ],
            ),
          ],
        ),
        CommandOptionBuilder.subCommandGroup(
          name: 'promotes',
          description: 'Настройки объявлений бота',
          options: [
            CommandOptionBuilder.subCommand(
              name: 'add',
              description: 'Добавить новое сообщение',
              options: [
                CommandOptionBuilder.string(
                  name: 'message',
                  description: 'Шаблоны: {AUTHOR}, {DESCRIPTION}, {DATE}, {MAX_MEMBERS}, {NAME}, {MESSAGE_URL}',
                  isRequired: true,
                ),
                CommandOptionBuilder.integer(
                  name: 'weight',
                  description: 'Вес сообщения',
                  isRequired: false,
                  minValue: 1,
                  maxValue: 10,
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'remove',
              description: 'Удалить сообщение по ID',
              options: [
                CommandOptionBuilder.integer(
                  name: 'id',
                  description: 'ID сообщения',
                ),
              ],
            ),
            CommandOptionBuilder.subCommand(
              name: 'list',
              description: 'Показать все сообщения',
              options: [],
            ),
          ],
        ),
        CommandOptionBuilder.subCommandGroup(
          name: 'bot',
          description: 'Тут можно получить информацию о настройках бота',
          options: [
            CommandOptionBuilder.subCommand(
              name: 'channels',
              description: 'Каналы, в которых бот работает',
              options: [],
            ),
            CommandOptionBuilder.subCommand(
              name: 'roles',
              description: 'Получить список ролей для активности',
              options: [
                CommandOptionBuilder.string(
                  name: 'activity',
                  description: 'Активность',
                  isRequired: true,
                ),
                CommandOptionBuilder.string(
                  name: 'role',
                  description: 'role',
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
  }

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
      ..writeln('**Stats:**')
      ..writeln('Ping: ${now - timestamp}ms')
      ..writeln()
      ..writeln('**LFGs:**');

    // If any exception was caught, then show it to user.
    try {
      response.writeln('Scheduled: ${scheduler.getScheduledPostsCount()}');
    } on Object catch (e) {
      response.writeln('Scheduler unavailable: $e');
    }

    try {
      response.writeln('Total: ${await database.getAllPostsCount()}');
    } on Object catch (e) {
      response.writeln('Database unavailable: $e');
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
        MessageBuilder(content: 'Данное сообщение не содержит LFG [LFGNotFound]'),
        isEphemeral: true,
      );
      return;
    }

    final lfgManager = services.lfgManager;

    await lfgManager.delete(int.parse(messageId.value as String));

    await event.interaction.respond(
      MessageBuilder(
        content: 'LFG пользователя "$userName", с активностью "${postData.title}" удалено.',
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
      MessageBuilder(content: channel != null ? 'LFG канал установлен' : 'LFG канал удален'),
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
      MessageBuilder(content: channel != null ? 'Канал уведомлений установлен' : 'Канал уведомлений удален'),
      isEphemeral: true,
    );
  }

  Future<void> _addPromoteMessageHandler(
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final message = findInOption<String>('message', event.interaction.data.options!);
    final weight = findInOption<int>('вес', event.interaction.data.options!) ?? 1;
    if (message == null) return;

    final settings = services.settings;
    await settings.addPromoteMessage(message, weight);

    await event.interaction.respond(
      MessageBuilder(content: 'Сообщение добавлено'),
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
      MessageBuilder(content: 'Сообщение удалено'),
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
      ..writeln('**Сообщения:**')
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
      ..write('LFG канал: ')
      ..writeln(lfgChannel != null ? '<#$lfgChannel>' : 'Не установлен')
      ..write('Канал уведомлений: ')
      ..write(promoChannel != null ? '<#$promoChannel>' : 'Не установлен');

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
    final activityRaw = findInOption<String>('activity', event.interaction.data.options!);
    final activity = int.parse(activityRaw!);
    final role = findInOption<String>('role', event.interaction.data.options!);
    if (activity == null || role == null) return;

    final settings = services.settings;
    final roles = await settings.getFreeRoleCount(id: activity, role: role);

    await event.interaction.respond(
      MessageBuilder(content: 'Активность "$activity" имеет $roles свободных ролей "$role"'),
      isEphemeral: true,
    );
  }
}
