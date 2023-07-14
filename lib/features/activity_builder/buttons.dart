import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

ComponentRowBuilder get activityButtons {
  return ComponentRowBuilder()
    ..addComponent(
      ButtonBuilder(
        '➕ Присоединиться',
        'activity_join',
        ButtonStyle.success,
      ),
    )
    ..addComponent(
      ButtonBuilder(
        '➖ Покинуть',
        'activity_leave',
        ButtonStyle.danger,
      ),
    );
}
