import 'package:intl/intl.dart';
import 'package:nyxx/nyxx.dart' hide Activity;

import '../../../core/bot/core.dart';
import '../../../core/utils/context/context.dart';
import '../../../core/utils/database/tables/posts.dart';
import '../../../core/utils/time_convert.dart';
import '../../command_manager/command_manager.dart';
import '../../lfg_manager/lfg_manager.dart';

CommandCreator editComponentHandler() => (
      builder: _createEditCommand,
      handlers: {
        'Редактировать LFG': _handleEditInteraction,
      }
    );

ApplicationCommandBuilder _createEditCommand() => ApplicationCommandBuilder(
      name: 'Редактировать LFG',
      type: ApplicationCommandType.message,
    );

Future<void> _handleEditInteraction(
  InteractionCreateEvent<ApplicationCommandInteraction> event,
) async {
  final message = event.interaction.data.targetId;
  final channel = event.interaction.channel;

  // message and channel should never be null
  if (message == null || channel == null) {
    await event.interaction.respond(
      MessageBuilder(content: 'Не удалось редактировать сообщение [NotFound]'),
      isEphemeral: true,
    );
    return;
  }

  final database = Context.root.get<PostsDatabase>('db');
  final postData = await database.findPost(message.value);

  if (postData == null) {
    await event.interaction.respond(
      MessageBuilder(content: 'Данное сообщение не содержит LFG [LFGNotFound]'),
      isEphemeral: true,
    );
    return;
  }

  if (postData.author != event.interaction.member?.user?.id.value) {
    print(
      'User "${event.interaction.member?.user?.username}" tried to edit LFG of user "${postData.author}"',
    );

    await event.interaction.respond(
      MessageBuilder(
        content: 'Вы не можете редактировать это LFG, '
            'т.к. не являетесь его автором [NotAuthor]',
      ),
      isEphemeral: true,
    );
    return;
  }

  Context.root.get<LFGBotCore>('core').commandManager.unsubscribeFromModal(
        customID: 'edit_modal_${postData.postMessageId}',
        // authorID: event.interaction.user?.id.value ?? event.interaction.member?.user?.id.value ?? postData.author,
      );

  print('[EditHandler] Detected timezone: ${postData.timezone}');

  await event.interaction.respondModal(
    ModalBuilder(
      customId: 'edit_modal_${postData.postMessageId}',
      title: 'Редактирование LFG',
      components: [
        ActionRowBuilder(
          components: [
            TextInputBuilder(
              customId: 'edit_description',
              label: 'Описание',
              placeholder: 'Введите новое описание',
              maxLength: 100,
              value: postData.description,
              style: TextInputStyle.paragraph,
            ),
          ],
        ),
        ActionRowBuilder(
          components: [
            TextInputBuilder(
              customId: 'edit_date',
              label: 'Дата начала',
              placeholder: 'Введите новое время начала',
              value: DateFormat('dd MM yyyy').format(
                postData.date.add(Duration(hours: postData.timezone)).toUtc(),
              ),
              style: TextInputStyle.short,
            ),
          ],
        ),
        ActionRowBuilder(
          components: [
            TextInputBuilder(
              customId: 'edit_time',
              label: 'Время начала',
              placeholder: 'Введите новое время начала',
              value: DateFormat('HH mm').format(
                postData.date.add(Duration(hours: postData.timezone)).toUtc(),
              ),
              style: TextInputStyle.short,
            ),
          ],
        ),
      ],
    ),
  );

  Context.root.get<LFGBotCore>('core').commandManager.subscribeToModal(
        // authorID: event.interaction.user?.id.value ?? event.interaction.member?.user?.id.value ?? 0,
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
  print('[EditHandler] Editing LFG message with id: $postId');

  String? newDescription;
  int? newUnixTime;
  String? newDate;
  String? newTime;

  void save(List<MessageComponent> components) {
    for (final component in components) {
      if (component is ActionRowComponent) save(component.components);
      if (component is TextInputComponent) {
        print('Component: ${component.customId} => ${component.value}');
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

  newUnixTime = TimeConverters.userInputToUnix(
    timeInput: newTime!,
    dateInput: newDate!,
    timezoneInput: timezone,
  );

  final messageId = origin.interaction.data.targetId;
  final channel = (await origin.interaction.channel?.get()) as GuildTextChannel?;

  if (messageId == null || channel == null) {
    await modalEvent.interaction.respond(
      MessageBuilder(
        content: 'Не удалось отредактировать сообщение [NotFound]',
      ),
      isEphemeral: true,
    );
    return;
  }

  final message = await channel.messages.get(Snowflake(messageId.value));

  final lfgManager = Context.root.get<LFGManager>('manager');
  await lfgManager.update(
    message,
    description: newDescription,
    unixTime: newUnixTime,
  );

  await modalEvent.interaction.respond(
    MessageBuilder(content: 'Редактирование завершено'),
    isEphemeral: true,
  );
}
