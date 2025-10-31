import 'dart:math';

import 'package:l/l.dart';
import 'package:nyxx/nyxx.dart';

import '../../core/const/command_exceptions.dart';
import '../../core/l10n/messages.dart';
import '../../core/utils/color_palette.dart';
import '../lfg_manager/data/models/register_activity.dart';
import '../settings/settings.dart';

/// {@template Promoter}
///
/// Promoter for notifying about new LFG posts.
///
/// {@endtemplate}
class Promoter {
  /// {@macro Promoter}
  const Promoter({
    required NyxxGateway bot,
    required Settings settings,
  })  : _bot = bot,
        _settings = settings;

  final NyxxGateway _bot;

  final Settings _settings;

  /// Notifies about a new LFG post.
  Future<void> notifyAboutLFG(
    LFGPostBuilder builder,
    Snowflake postId,
  ) async {
    final promoChannel = await _settings.getPromotesChannel();
    final lfgChannel = await _settings.getLFGChannel();
    final promoRole = await _settings.getPromotesRole(builder.activity.name);
    if (promoChannel == null || lfgChannel == null) {
      l.w('[Promoter] No promo or LFG channel set. Skipping notifying');
      return;
    }

    final channel = await _bot.channels.fetch(Snowflake(promoChannel));

    if (channel.type != ChannelType.guildText) {
      throw CantRespondException(
        promoterChannelInvalid(promoChannel.toString()),
      );
    }

    channel as GuildTextChannel;

    await channel.sendMessage(
      await _createRandomMessage(
        builder,
        'https://discord.com/channels/${channel.guildId.value}/$lfgChannel/${postId.value}',
        promoRole,
      ),
    );
  }

  Future<MessageBuilder> _createRandomMessage(
    LFGPostBuilder builder,
    String lfgMessageUrl,
    int? promoRole,
  ) async {
    final messages = await _settings.getPromoteMessagesWithWeight();
    final authorMention = '<@${builder.authorID}>';
    final message = messages.isNotEmpty
        ? messages[Random().nextInt(messages.length)]
        : promoterDefaultTemplate(authorMention, builder.activity.name);

    final content = message
        .replaceAll('{AUTHOR}', authorMention)
        .replaceAll('{DESCRIPTION}', builder.description)
        .replaceAll('{DATE}', '<t:${builder.unixDate ~/ 1000}:F>')
        .replaceAll('{MAX_MEMBERS}', builder.activity.maxMembers.toString())
        .replaceAll('{NAME}', builder.activity.name)
        .replaceAll('{MESSAGE_URL}', lfgMessageUrl);

    final splitMessage = content.split(r'\n');

    return MessageBuilder(
      content: promoRole != null ? '<@&$promoRole>' : null,
      allowedMentions: promoRole != null ? AllowedMentions(roles: [Snowflake(promoRole)]) : null,
      embeds: [
        EmbedBuilder(
          color: ColorPalette.getRandomDiscordColor(),
          fields: [
            for (int i = 0; i < splitMessage.length; i++)
              EmbedFieldBuilder(
                name: i == 0 ? promoterNewGatheringTitle : '',
                value: splitMessage[i],
                isInline: false,
              ),
          ],
        ),
      ],
    );
  }
}
