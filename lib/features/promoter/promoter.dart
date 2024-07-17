import 'dart:math';

import 'package:l/l.dart';
import 'package:nyxx/nyxx.dart';

import '../../core/const/command_exceptions.dart';
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
    if (promoChannel == null || lfgChannel == null) {
      l.w('[Promoter] No promo or LFG channel set. Skipping notifying');
      return;
    }

    final channel = await _bot.channels.fetch(Snowflake(promoChannel));

    if (channel.type != ChannelType.guildText) {
      throw CantRespondException(
        'Not a promo channel.\n'
        'ID: $promoChannel',
      );
    }

    channel as GuildTextChannel;

    await channel.sendMessage(
      await _createRandomMessage(
        builder,
        'https://discord.com/channels/${channel.guildId.value}/$lfgChannel/${postId.value}',
      ),
    );
  }

  Future<MessageBuilder> _createRandomMessage(LFGPostBuilder builder, String lfgMessageUrl) async {
    final messages = await _settings.getPromoteMessagesWithWeight();
    final message =
        messages.isNotEmpty ? messages[Random().nextInt(messages.length)] : '{AUTHOR} собирает людей в {LFG_NAME}';

    final content = message
        .replaceAll('{AUTHOR}', '<@${builder.authorID}>')
        .replaceAll('{DESCRIPTION}', builder.description)
        .replaceAll('{DATE}', '<t:${builder.unixDate ~/ 1000}:F>')
        .replaceAll('{MAX_MEMBERS}', builder.maxMembers.toString())
        .replaceAll('{NAME}', builder.name)
        .replaceAll('{MESSAGE_URL}', lfgMessageUrl);

    return MessageBuilder(
      embeds: [
        EmbedBuilder(
          color: ColorPalette.getRandomDiscordColor(),
          fields: [
            EmbedFieldBuilder(
              name: 'Новый сбор!',
              value: content,
              isInline: false,
            ),
          ],
        ),
      ],
    );
  }
}
