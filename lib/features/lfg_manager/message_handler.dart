import 'dart:async';
import 'dart:math';

import 'package:nyxx/nyxx.dart' hide Activity;

import '../../core/data/models/activity_data.dart';
import '../../core/utils/services.dart';
import 'data/models/register_activity.dart';

/// Interface for Discord message handler.
///
/// It handles LFG messages sends by bot.
abstract interface class IMessageHandler {
  /// Creates new LFG post.
  ///
  /// Returns ID of the message.
  Future<Message> createPost({
    required LFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  });

  /// Updates existing LFG post.
  Future<void> updatePost(
    final Message message, {
    final List<String>? newMembers,
    final int? maxMembers,
    final String? description,
    final String? name,
    final int? unixTime,
  });

  /// Deletes existing LFG post.
  Future<void> deletePost(Message message);
}

/// Discord message handler.
final class MessageHandler implements IMessageHandler {
  const MessageHandler();

  static const List<String> _colors = <String>[
    'DAB729',
    'F52D74',
    '2FE2F7',
    '4270F8',
    '2CFA50',
  ];

  Future<MessageBuilder> _buildLFGPost(LFGPostBuilder builder) async {
    final bot = Services.i.bot;
    final user = await bot.users.get(builder.authorID);

    final embedBuilder = EmbedBuilder()
      ..fields = [
        EmbedFieldBuilder(
          name: builder.name,
          value: builder.description,
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Время сбора:',
          value: '<t:${builder.unixDate ~/ 1000}:F>',
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Участники (1/${builder.maxMembers}):',
          value: user.globalName ?? user.username,
          isInline: false,
        ),
      ]
      ..author = EmbedAuthorBuilder(
        name: user.globalName ?? user.username,
        iconUrl: user.avatar.url,
      )
      ..color = DiscordColor.parseHexString(_colors[Random().nextInt(_colors.length)])
      ..image = builder.bannerUrl != null ? EmbedImageBuilder(url: (Uri.parse(builder.bannerUrl!))) : null;

    final messageBuilder = MessageBuilder(embeds: [embedBuilder])
      ..components = [
        ActionRowBuilder(
          components: [
            ButtonBuilder(
              customId: 'join',
              label: '➕ Присоединиться',
              style: ButtonStyle.success,
            ),
            ButtonBuilder(
              customId: 'leave',
              label: '➖ Покинуть',
              style: ButtonStyle.danger,
            ),
          ],
        ),
      ];

    return messageBuilder;
  }

  @override
  Future<Message> createPost({
    required LFGPostBuilder builder,
    required InteractionCreateEvent<ApplicationCommandInteraction> interaction,
  }) async {
    await interaction.interaction.respond(await _buildLFGPost(builder));

    final msg = await interaction.interaction.fetchOriginalResponse();

    return msg;
  }

  @override
  Future<void> deletePost(Message message) async {
    await message.delete();
  }

  @override
  Future<void> updatePost(
    final Message message, {
    final List<String>? newMembers,
    final int? maxMembers,
    final String? description,
    final String? name,
    final int? unixTime,
  }) async {
    final embedFields = <EmbedFieldBuilder>[];
    ActivityData activity;

    // update description if it was changed
    if (description != null) {
      final (name, _) = _getFieldData(message, 0);
      activity = await Services.i.settings.getActivity(name);

      final field = EmbedFieldBuilder(
        name: name,
        value: description,
        isInline: false,
      );

      embedFields.add(field);
    } else {
      final (name, value) = _getFieldData(message, 0);

      activity = await Services.i.settings.getActivity(name);

      final field = EmbedFieldBuilder(
        name: name,
        value: value,
        isInline: false,
      );

      embedFields.add(field);
    }

    // update time if it was changed
    if (unixTime != null) {
      final (name, _) = _getFieldData(message, 1);

      final field = EmbedFieldBuilder(
        name: name,
        value: '<t:${unixTime ~/ 1000}:F>',
        isInline: false,
      );

      embedFields.add(field);
    } else {
      final (name, value) = _getFieldData(message, 1);

      final field = EmbedFieldBuilder(
        name: name,
        value: value,
        isInline: false,
      );

      embedFields.add(field);
    }

    // update members if it was changed
    if (newMembers != null) {
      final field = EmbedFieldBuilder(
        name: 'Участники (${newMembers.length}/$maxMembers):',
        value: newMembers.join(', '),
        isInline: false,
      );

      embedFields.add(field);
    } else {
      final (name, value) = _getFieldData(message, 2);

      final field = EmbedFieldBuilder(
        name: name,
        value: value,
        isInline: false,
      );

      embedFields.add(field);
    }

    await message.edit(
      MessageUpdateBuilder(
        embeds: [
          EmbedBuilder(
            fields: embedFields,
            color: DiscordColor.parseHexString(
              _colors[Random().nextInt(_colors.length)],
            ),
            image: activity.bannerUrl != null ? EmbedImageBuilder(url: Uri.parse(activity.bannerUrl!)) : null,
          ),
        ],
      ),
    );
  }
}

(String, String) _getFieldData(Message message, int fieldPosition) {
  final field = message.embeds.first.fields![fieldPosition];

  return (field.name, field.value);
}
