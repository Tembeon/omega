import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../core/utils/loaders/bot_settings.dart';
import '../../core/utils/time_convert.dart';
import '../commands/command_exceptions.dart';
import 'buttons.dart';

class ActivityPostBuilder {
  /// Returns [ComponentMessageBuilder] with embed and buttons for activity post.
  static Future<ComponentMessageBuilder> fromCreate(ISlashCommandInteractionEvent event) async {
    // extract data from event
    final user = event.interaction.memberAuthor;
    final args = event.args;
    final String activityName = args[0].value as String;
    final String activityDescription = args[1].value as String;
    final String time = args[2].value as String;
    final String date = args[3].value as String;
    final int userTimezoneOffset = args[4].value as int;

    // disallow null user (bots)
    if (user == null) throw const CantRespond('Неизвестный пользователь, возможно это бот. Ботов не обслуживаем.');

    final messageBuilder = await _createEmbedWith(
      user: user,
      activityName: activityName,
      activityDescription: activityDescription,
      time: time,
      date: date,
      userTimezoneOffset: userTimezoneOffset,
    );

    return messageBuilder;
  }

  static Future<ComponentMessageBuilder> _createEmbedWith({
    required IMember user,
    required String activityName,
    required String activityDescription,
    required String time,
    required String date,
    required int userTimezoneOffset,
  }) async {
    final msgBuilder = ComponentMessageBuilder();
    final rawUser = await user.user.getOrDownload();
    final activity = BotSettings.i.activityData.get(activityName);
    final discordTime = TimeConverters.convertRawDateToDiscordTime(
      time: time,
      date: date,
      userTimezoneOffset: userTimezoneOffset,
    );

    // create embed
    await msgBuilder.addEmbed(
      (embed) => embed
        ..addAuthor(
          (author) {
            author
              ..name = rawUser.username
              ..iconUrl = rawUser.avatarUrl();
          },
        )
        ..addField(
          builder: (field) {
            field
              ..name = activityName
              ..content = activityDescription;
          },
        )
        ..addField(
          builder: (field) {
            field
              ..name = 'Время сбора:'
              ..content = discordTime;
          },
        )
        ..addField(
          builder: (field) {
            field
              ..name = 'Участники:'
              ..content = user.nickname ?? rawUser.username;
          },
        )
        ..imageUrl = activity.bannerUrl
        ..color = _getRandomHexColor,
    );

    msgBuilder.addComponentRow(activityButtons);

    return msgBuilder;
  }

  static DiscordColor get _getRandomHexColor {
    final colors = [
      DiscordColor.fromHexString('#DAB729'),
      DiscordColor.fromHexString('#F52D74'),
      DiscordColor.fromHexString('#2FE2F7'),
      DiscordColor.fromHexString('#4270F8'),
      DiscordColor.fromHexString('#2CFA50'),
    ];

    return colors[Random().nextInt(colors.length)];
  }
}
