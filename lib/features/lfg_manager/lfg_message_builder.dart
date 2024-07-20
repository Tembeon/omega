import 'dart:io';

import 'package:nyxx/nyxx.dart';

import '../../core/const/command_exceptions.dart';
import '../../core/utils/color_palette.dart';
import '../../core/utils/services.dart';
import 'data/models/register_activity.dart';

base class LfgMessageBuilder {
  const LfgMessageBuilder();

  Future<MessageUpdateBuilder> update(
    Message message, {
    List<String>? newMembers,
    int? maxMembers,
    String? description,
    int? unixTime,
  }) async {
    final dbPost = await Services.i.postsDatabase.findPost(message.id.value);
    if (dbPost == null) throw CantRespondException('LFG ${message.id.value} не найден');
    final activityData = await Services.i.settings.getActivity(dbPost.title);

    final embedAuthor = _buildAuthorField(origin: message);
    final embedColor = _buildColor(origin: message);
    final embedDescription = _buildDescription(forceDescription: description, origin: message);
    final embedStartTime = _buildStartTime(origin: message, unixTime: unixTime);
    final embedMembers = _buildMembers(
      members: newMembers,
      maxMembers: maxMembers ?? activityData.maxMembers,
      origin: message,
    );
    final (embedImage, attachment) = _buildImage(uri: activityData.bannerUrl);

    final builder = MessageUpdateBuilder(
      embeds: [
        EmbedBuilder(
          author: embedAuthor,
          image: embedImage,
          color: embedColor,
          fields: [
            embedDescription,
            embedStartTime,
            embedMembers,
          ],
        ),
      ],
    );

    if (attachment != null) {
      builder.attachments = [
        AttachmentBuilder(data: attachment.readAsBytesSync(), fileName: 'image.png'),
      ];
    }

    return builder;
  }

  /// Builds a formatted message for LFG post.
  Future<MessageBuilder> build(LFGPostBuilder builder, {String? authorRole}) async {
    final bot = Services.i.bot;

    final member = await bot.guilds[Services.i.config.server].members.get(builder.authorID);

    final (embedImage, attachment) = _buildImage(uri: builder.activity.bannerUrl);
    final embedAuthor = _buildAuthorField(member: member);
    final embedColor = _buildColor();
    final embedDescription = _buildDescription(builder: builder);
    final embedStartTime = _buildStartTime(builder: builder);
    final embedMembers = _buildMembers(
      members: [
        member.nick ?? member.user!.globalName ?? member.user!.username,
      ],
      maxMembers: builder.activity.maxMembers,
    );

    return MessageBuilder(
      content: authorRole,
      attachments: attachment != null
          ? [
              AttachmentBuilder(data: attachment.readAsBytesSync(), fileName: 'image.png'),
            ]
          : null,
      embeds: [
        EmbedBuilder(
          author: embedAuthor,
          color: embedColor,
          image: embedImage,
          fields: [
            embedDescription,
            embedStartTime,
            embedMembers,
          ],
        ),
      ],
      components: [
        ActionRowBuilder(
          components: [
            ButtonBuilder(
              customId: 'join',
              label: '➕  Присоединиться',
              style: ButtonStyle.success,
            ),
            ButtonBuilder(
              customId: 'leave',
              label: '➖  Покинуть',
              style: ButtonStyle.danger,
            ),
          ],
        ),
      ],
    );
  }

  EmbedAuthorBuilder _buildAuthorField({Member? member, Message? origin}) {
    final originUserFields = origin?.embeds.first.author;

    return EmbedAuthorBuilder(
      name: member?.nick ?? member?.user?.globalName ?? member?.user?.username ?? originUserFields!.name,
      iconUrl: member?.user?.avatar.url ?? originUserFields!.iconUrl,
    );
  }

  DiscordColor _buildColor({Message? origin}) => origin?.embeds.first.color ?? ColorPalette.getRandomDiscordColor();

  EmbedFieldBuilder _buildDescription({LFGPostBuilder? builder, Message? origin, String? forceDescription}) {
    final (name, description) = origin == null ? (null, null) : _getFieldData(origin, 0);

    return EmbedFieldBuilder(
      name: builder?.activity.name ?? name!,
      value: forceDescription ?? builder?.description ?? description!,
      isInline: false,
    );
  }

  EmbedFieldBuilder _buildStartTime({LFGPostBuilder? builder, Message? origin, int? unixTime}) {
    final (_, description) = origin == null ? (null, null) : _getFieldData(origin, 1);
    final String value = () {
      if (builder?.unixDate != null) {
        return '<t:${builder!.unixDate ~/ 1000}:F>';
      }

      if (unixTime != null) {
        return '<t:${unixTime ~/ 1000}:F>';
      }

      return description!;
    }();

    return EmbedFieldBuilder(
      name: 'Время сбора:',
      value: value,
      isInline: false,
    );
  }

  EmbedFieldBuilder _buildMembers({
    List<String>? members,
    Message? origin,
    required int maxMembers,
  }) {
    final membersCount = members?.length;
    final (_, value) = origin == null ? (null, null) : _getFieldData(origin, 2);

    return EmbedFieldBuilder(
      name: 'Участники (${membersCount ?? 1}/$maxMembers):',
      value: members == null ? value! : members.join(', '),
      isInline: false,
    );
  }

  (EmbedImageBuilder? builder, File? attachment) _buildImage({String? uri}) {
    final parsedUri = uri != null ? Uri.parse(uri) : null;
    File? attachment;

    if (parsedUri != null && !parsedUri.isScheme('https')) {
      attachment = File(parsedUri.toFilePath());
    }

    final embedImage = uri != null
        ? EmbedImageBuilder(
            url: attachment != null ? Uri(scheme: 'attachment', host: 'image.png') : parsedUri!,
          )
        : null;

    return (embedImage, attachment);
  }

  Future<void> deletePost(Message message) async {
    await message.delete();
  }
}

(String, String) _getFieldData(Message message, int fieldPosition) {
  final field = message.embeds.first.fields![fieldPosition];

  return (field.name, field.value);
}
