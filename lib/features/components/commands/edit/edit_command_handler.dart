import 'package:intl/intl.dart';
import 'package:l/l.dart';

import '../../../../core/l10n/messages.dart';
import '../../../../core/utils/time_convert.dart';
import '../../../interactor/interactor_component.dart';

class EditCommandHandler extends InteractorCommandComponent {
  const EditCommandHandler();

  @override
  Future<ApplicationCommandBuilder> build(Services services) async {
    return ApplicationCommandBuilder(
      name: editCommandName,
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
        MessageBuilder(content: editCommandMessageNotFound),
        isEphemeral: true,
      );
      return;
    }

    final database = services.postsDatabase;
    final postData = await database.findPost(message.value);

    if (postData == null) {
      await event.interaction.respond(
        MessageBuilder(content: selectedMessageIsNotLfg),
        isEphemeral: true,
      );
      return;
    }

    if (postData.author != event.interaction.member?.user?.id.value) {
      l.i('User "${event.interaction.member?.user?.username}" tried to edit LFG of user "${postData.author}"');

      await event.interaction.respond(
        MessageBuilder(
          content: editCommandNotAuthor,
        ),
        isEphemeral: true,
      );
      return;
    }

    services.interactor.unsubscribeFromModal(customID: 'edit_modal_${postData.postMessageId}');

    await event.interaction.respondModal(
      ModalBuilder(
        customId: 'edit_modal_${postData.postMessageId}',
        title: editCommandModalTitle,
        components: [
          ActionRowBuilder(
            components: [
              TextInputBuilder(
                customId: 'edit_description',
                label: editCommandDescriptionLabel,
                placeholder: editCommandDescriptionPlaceholder,
                value: postData.description,
                style: TextInputStyle.paragraph,
              ),
            ],
          ),
          ActionRowBuilder(
            components: [
              TextInputBuilder(
                customId: 'edit_date',
                label: editCommandDateLabel,
                placeholder: editCommandStartTimePlaceholder,
                value: DateFormat('dd MM yyyy').format(postData.date.add(Duration(hours: postData.timezone)).toUtc()),
                style: TextInputStyle.short,
              ),
            ],
          ),
          ActionRowBuilder(
            components: [
              TextInputBuilder(
                customId: 'edit_time',
                label: editCommandTimeLabel,
                placeholder: editCommandStartTimePlaceholder,
                value: DateFormat('HH mm').format(postData.date.add(Duration(hours: postData.timezone)).toUtc()),
                style: TextInputStyle.short,
              ),
            ],
          ),
        ],
      ),
    );

    services.interactor.subscribeToModal(
      modalID: 'edit_modal_${postData.postMessageId}',
      handler: (interaction) async {
        await _editLFGMessage(
          postId: message.value,
          origin: event,
          modalEvent: interaction,
          timezone: postData.timezone,
        );
      },
    );
  }

  Future<void> _editLFGMessage({
    required int postId,
    required InteractionCreateEvent<ApplicationCommandInteraction> origin,
    required InteractionCreateEvent<ModalSubmitInteraction> modalEvent,
    required int timezone,
  }) async {
    // at this moment we can be sure that user is the author of the post
    l.i('[EditHandler] Editing LFG message with id: $postId');

    String? newDescription;
    int? newUnixTime;
    String? newDate;
    String? newTime;

    void save(List<MessageComponent> components) {
      for (final component in components) {
        if (component is ActionRowComponent) save(component.components);
        if (component is TextInputComponent) {
          l.i('Component: ${component.customId} => ${component.value}');
          switch (component.customId) {
            case 'edit_description':
              newDescription = component.value;
            case 'edit_time':
              newTime = component.value;
            case 'edit_date':
              newDate = component.value;
          }
        }
      }
    }

    save(modalEvent.interaction.data.components);

    newUnixTime = TimeConverters.userInputToUnix(timeInput: newTime!, dateInput: newDate!, timezoneInput: timezone);

    final messageId = origin.interaction.data.targetId;
    final channel = (await origin.interaction.channel?.get()) as GuildTextChannel?;

    if (messageId == null || channel == null) {
      await modalEvent.interaction.respond(
        MessageBuilder(content: editCommandModalMessageNotFound),
        isEphemeral: true,
      );
      return;
    }

    final message = await channel.messages.get(Snowflake(messageId.value));

    final lfgManager = Services.i.lfgManager;
    await lfgManager.update(message, description: newDescription, unixTime: newUnixTime);

    await modalEvent.interaction.respond(
      MessageBuilder(content: editCommandCompleted),
      isEphemeral: true,
    );
  }
}
