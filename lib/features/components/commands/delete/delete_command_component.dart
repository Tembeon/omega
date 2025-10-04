import 'package:l/l.dart';

import '../../../../core/l10n/messages.dart';
import '../../../interactor/interactor_component.dart';

class DeleteCommandComponent extends InteractorCommandComponent {
  const DeleteCommandComponent();

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      name: deleteCommandName,
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
        MessageBuilder(content: deleteCommandMessageNotFound),
        isEphemeral: true,
      );
      return;
    }

    final database = services.postsDatabase;
    final postData = await database.findPost(message.value);

    // if post can't be found in database, then it's not LFG
    if (postData == null) {
      await event.interaction.respond(
        MessageBuilder(content: selectedMessageIsNotLfg),
        isEphemeral: true,
      );
      return;
    }

    // if author of the post is not the same as author of the command, then it's not LFG of the author
    if (postData.author != event.interaction.member?.user?.id.value) {
      l.i('User "${event.interaction.member?.user}" tried to delete LFG of user "${postData.author}"');

      await event.interaction.respond(
        MessageBuilder(
          content: deleteCommandNotAuthor,
        ),
        isEphemeral: true,
      );
      return;
    }

    final lfgManager = services.lfgManager;
    await lfgManager.delete(message.value);

    await event.interaction.respond(
      MessageBuilder(content: deleteCommandSuccess(postData.title)),
      isEphemeral: true,
    );
  }
}
