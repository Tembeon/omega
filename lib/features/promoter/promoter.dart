import 'package:nyxx/nyxx.dart';

import '../../core/const/command_exceptions.dart';
import '../lfg_manager/data/models/register_activity.dart';
import '../settings/settings.dart';
import 'promoter_messages.dart';

/// {@template Promoter}
///
/// Promoter for notifying about new LFG posts.
///
/// {@endtemplate}
class Promoter {
  /// {@macro Promoter}
  const Promoter({
    required NyxxGateway bot,
  }) : _bot = bot;

  final NyxxGateway _bot;

  /// Notifies about a new LFG post.
  Future<void> notifyAboutLFG(
    LFGPostBuilder builder,
    Snowflake postId,
    Settings settings,
  ) async {
    final promoChannel = await settings.getPromotesChannel();
    final lfgChannel = await settings.getLFGChannel();
    if (promoChannel == null || lfgChannel == null) return;

    final channel = await _bot.channels.fetch(Snowflake(promoChannel));
    final postChannel = await _bot.channels.fetch(Snowflake(lfgChannel));

    if (channel.type != ChannelType.guildText) {
      throw CantRespondException(
        'Not a promo channel.\n'
        'ID: $promoChannel',
      );
    }

    channel as GuildTextChannel;
    final message = MessageTemplates.getRandomLFGMessage(
      builder.name,
      channel.guildId.toString(),
      postChannel.id.toString(),
      postId.toString(),
    );

    await channel.sendMessage(
      MessageBuilder(
        content: message,
      ),
    );
  }
}
