import 'dart:convert';
import 'dart:io';

import '../../const/exceptions.dart';

abstract final class BotConfig {
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
}

final class _BotConfigLoader implements BotConfig {
  const _BotConfigLoader({
    required this.botToken,
    required this.lfgChannel,
    required this.serverID,
    this.promoChannel,
    this.deleteDeletedMessagesFromChannels,
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
}
