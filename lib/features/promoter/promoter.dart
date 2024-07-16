import 'package:nyxx/nyxx.dart';

import '../../core/const/command_exceptions.dart';
import '../../core/utils/services.dart';
import '../lfg_manager/data/models/register_activity.dart';
import 'promoter_messages.dart';

/// {@template Promoter}
/// Promoter for notifying about new LFG posts.
/// {@endtemplate}
class Promoter {
  /// {@macro Promoter}
  const Promoter({
    required this.bot,
  });

  final NyxxGateway bot;

  /// Notifies about a new LFG post.
  Future<void> notifyAboutLFG(LFGPostBuilder builder, Snowflake postId) async {
    final settings = Services.i.settings;
    final promoChannel = await settings.getPromotesChannel();
    final lfgChannel = await settings.getLFGChannel();

    final channel = await bot.channels.fetch(Snowflake(promoChannel!));
    final postChannel = await bot.channels.fetch(Snowflake(lfgChannel!));
    if (channel.type != ChannelType.guildText) {
      throw CantRespondException(
        'Not a promo channel.\n'
        'ID: $promoChannel',
      );
    } else {
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
}
