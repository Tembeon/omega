import 'dart:convert';
import 'dart:io';

import '../../const/exceptions.dart';

abstract final class BotConfig {
  /// Loads all bot settings from configs. [path] is a path to config file.
  factory BotConfig.fromFile(String path) {
    final botConfig = File(path);
    if (!botConfig.existsSync()) {
      throw ConfigFileMissing('bot config', configPath: botConfig.path);
    }

    final config = jsonDecode(botConfig.readAsStringSync()) as Map<String, Object?>;

    if (config.isEmpty) {
      throw ConfigFileMissing('bot config is empty', configPath: botConfig.path);
    }

    return _BotConfigLoader.fromJson(config);
  }

  /// Returns server ID.
  int get serverID;

  /// Returns bot token.
  String get botToken;

  /// Returns channel where bot should send LFG messages.
  int get lfgChannel;

  /// Returns channel where bot should send promo messages to promote LFGs.
  int? get promoChannel;

  /// Returns list of channels where bot should check for deleted messages.
  ///
  /// To example:
  /// you have a channel which follows another channel. If someone deletes a message in the followed channel,
  /// then bot will delete a deleted message in the following channel. (I hope you understand what I mean).
  List<String>? get deleteDeletedMessagesFromChannels;

  /// Returns list of timezones that bot should show user when he creates a new LFG.
  ///
  /// Key is a name of timezone, value is a difference between UTC and this timezone.
  Map<String, int> get timezones;
}

final class _BotConfigLoader implements BotConfig {
  const _BotConfigLoader({
    required this.botToken,
    required this.lfgChannel,
    required this.serverID,
    this.promoChannel,
    this.deleteDeletedMessagesFromChannels,
    required this.timezones,
  });

  factory _BotConfigLoader.fromJson(Map<String, Object?> json) {
    return _BotConfigLoader(
      botToken: json['bot_token']! as String,
      lfgChannel: int.parse(json['lfg_channel']! as String),
      serverID: int.parse(json['server_id']! as String),
      promoChannel: int.tryParse(json['promo_channel']! as String),
      deleteDeletedMessagesFromChannels: (json['delete_deleted_messages_from_channels'] as List<Object>?)
          ?.map(
            (e) => e as String,
          )
          .toList(),
      timezones: (json['timezones']! as Map<String, Object?>).map(
        (key, value) => MapEntry(
          key,
          value! as int,
        ),
      ),
    );
  }

  @override
  final String botToken;

  @override
  final int lfgChannel;

  @override
  final int? promoChannel;

  @override
  final List<String>? deleteDeletedMessagesFromChannels;

  @override
  final int serverID;

  @override
  final Map<String, int> timezones;
}
