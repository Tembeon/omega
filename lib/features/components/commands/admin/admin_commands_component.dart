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
}
