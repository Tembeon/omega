import 'dart:convert';
import 'dart:io';

import '../../const/exceptions.dart';
import 'activity_data.dart';
import 'config_data.dart';

abstract final class BotSettings {
  String get locale;

  ActivityData get activityData;

  BotConfig get botConfig;

  static BotSettings? _instance;

  static BotSettings get instance => _instance ??= throw Exception('Bot settings are not loaded');
  static BotSettings get i => instance;

  factory BotSettings.fromFile(String path) {
    final botSettingsFile = File(path);
    if (!botSettingsFile.existsSync()) {
      throw ConfigFileMissing('bot settings', configPath: botSettingsFile.path);
    }

    final botSettings = jsonDecode(botSettingsFile.readAsStringSync()) as Map<String, Object?>;

    final settingsData = _BotSettingsLoader(
      activityData: ActivityData.fromFiles(
        raidsPath: botSettings['raid_activities_path']! as String,
        dungeonsPath: botSettings['dungeon_activities_path']! as String,
        customsPath: botSettings['custom_activities_path']! as String,
      ),
      botConfig: BotConfig.fromFile(botSettings['bot_config_path']! as String),
      locale: botSettings['locale']! as String,
    );

    _instance = settingsData;
    return settingsData;
  }
}

final class _BotSettingsLoader implements BotSettings {
  const _BotSettingsLoader({
    required ActivityData activityData,
    required BotConfig botConfig,
    required String locale,
  })  : _activityData = activityData,
        _botConfig = botConfig,
        _locale = locale;

  final ActivityData _activityData;
  final BotConfig _botConfig;
  final String _locale;

  @override
  ActivityData get activityData => _activityData;

  @override
  BotConfig get botConfig => _botConfig;

  @override
  String get locale => _locale;
}
