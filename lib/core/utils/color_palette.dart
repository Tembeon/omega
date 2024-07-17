import 'dart:math';

import 'package:nyxx/nyxx.dart';

abstract final class ColorPalette {
  static const List<String> colors = <String>[
    'DAB729',
    'F52D74',
    '2FE2F7',
    '4270F8',
    '2CFA50',
    '41f097',
    'FFFFFF',
    '00e1ff',
    'fd4242',
    '08cee9',
  ];

  static String getRandomColor() => colors[Random().nextInt(colors.length)];

  static DiscordColor getRandomDiscordColor() => DiscordColor.parseHexString(getRandomColor());
}
