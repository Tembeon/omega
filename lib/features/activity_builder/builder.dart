import 'dart:math';

import 'package:lfg_bot/core/utils/config_data_loader.dart';
import 'package:lfg_bot/features/activity_builder/buttons.dart';
import 'package:lfg_bot/features/commands/command_exceptions.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../core/utils/time_convert.dart';

class ActivityPostBuilder {
  /// Returns [ComponentMessageBuilder] with embed and buttons for activity post.
  static Future<ComponentMessageBuilder> fromCreate(ISlashCommandInteractionEvent event) async {
    // extract data from event
    final user = event.interaction.memberAuthor;
    final args = event.args;
    final String activityName = args[0].value;
    final String activityDescription = args[1].value;
    final String time = args[2].value;
    final String date = args[3].value;
    final int userTimezoneOffset = args[4].value;

    // disallow null user (bots)
    if (user == null) throw CantRespond('Неизвестный пользователь, возможно это бот. Ботов не обслуживаем.');

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
    ComponentMessageBuilder msgBuilder = ComponentMessageBuilder();
    final rawUser = await user.user.getOrDownload();
    final activity = ConfigDataLoader.getActivityByName(activityName);
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
            author.name = rawUser.username;
            author.iconUrl = rawUser.avatarUrl();
          },
        )
        ..addField(
          builder: (field) {
            field.name = activityName;
            field.content = activityDescription;
          },
        )
        ..addField(
          builder: (field) {
            field.name = 'Время сбора:';
            field.content = discordTime;
          },
        )
        ..addField(
          builder: (field) {
            field.name = 'Участники:';
            field.content = user.nickname ?? rawUser.username;
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
