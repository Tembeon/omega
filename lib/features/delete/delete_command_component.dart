import '../interactor/interactor_component.dart';

class DeleteCommandComponent extends InteractorCommandComponent {
  const DeleteCommandComponent();

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      name: 'Удалить LFG',
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

    // message and channel should never be null
    if (message == null || channel == null) {
      await event.interaction.respond(
        MessageBuilder(content: 'Не удалось удалить сообщение [NotFound]'),
        isEphemeral: true,
      );
      return;
    }

    final database = services.postsDatabase;
    final postData = await database.findPost(message.value);

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
          content: 'Вы не можете удалить это LFG, '
              'т.к. не являетесь его автором [NotAuthor]',
        ),
        isEphemeral: true,
      );
      return;
    }

    final lfgManager = services.lfgManager;
    await lfgManager.delete(message.value);

    await event.interaction.respond(
      MessageBuilder(content: 'Ваше LFG "${postData.title}" удалено.'),
      isEphemeral: true,
    );
  }
}
