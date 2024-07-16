import '../../../interactor/interactor_component.dart';
import '../../../promoter/promoter_messages.dart';

class PromoteCommandComponent extends InteractorCommandComponent {
  const PromoteCommandComponent();

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      name: 'Оповестить об LFG',
      type: ApplicationCommandType.message,
    );
  }

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<ApplicationCommandInteraction> event,
    Services services,
  ) async {
    final message = event.interaction.data.targetId;
    final channel = event.interaction.channel;
    final settings = Services.i.settings;
    final bot = Services.i.bot;

    // message and channel should never be null
    if (message == null || channel == null) {
      await event.interaction.respond(
        MessageBuilder(content: 'Не удалось уведомить о LFG [NotFound]'),
        isEphemeral: true,
      );
      return;
    }

    final database = services.postsDatabase;
    final postData = await database.findPost(message.value);
    final lfgChannel = await settings.getLFGChannel();

    // if post can't be found in database, then it's not LFG
    if (postData == null) {
      await event.interaction.respond(
        MessageBuilder(content: 'Данное сообщение не содержит LFG [LFGNotFound]'),
        isEphemeral: true,
      );
      return;
    }

    // if author of the post is not the same as author of the command, then it's not LFG of the author
    if (postData.author != event.interaction.member?.user?.id.value) {
      print('User "${event.interaction.member?.user}" tried to delete LFG of user "${postData.author}"');

      await event.interaction.respond(
        MessageBuilder(
          content: 'Вы не можете уведомить об этом LFG, '
              'т.к. не являетесь его автором [NotAuthor]',
        ),
        isEphemeral: true,
      );
      return;
    }

    final promoChannelFromSettings = await bot.channels.fetch(Snowflake((await settings.getPromotesChannel())!));
    if (promoChannelFromSettings.type == ChannelType.guildText) {
      final promoChannel = promoChannelFromSettings as GuildTextChannel;
      final promoteMessage = MessageTemplates.getRandomLFGMessage(
        postData.title,
        promoChannel.guild.id.toString(),
        lfgChannel.toString(),
        message.toString(),
      );
      await promoChannel.sendMessage(
        MessageBuilder(
          content: promoteMessage,
        ),
      );
      await event.interaction.respond(
        MessageBuilder(content: 'Успешно оповещено об LFG.'),
        isEphemeral: true,
      );
    } else {
      await event.interaction.respond(
        MessageBuilder(content: 'Не удалось оповестить об LFG. [NoPromoChannel]'),
        isEphemeral: true,
      );
    }
  }
}
