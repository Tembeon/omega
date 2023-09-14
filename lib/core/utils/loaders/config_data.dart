import 'dart:convert';
import 'dart:io';

import '../../const/exceptions.dart';

abstract final class BotConfig {
  /// Returns server ID.
  String get serverID;

  /// Returns bot token.
  String get botToken;

  /// Returns channel where bot should send LFG messages.
  String get lfgChannel;

  /// Returns channel where bot should send promo messages to promote LFGs.
  String get promoChannel;

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

    return _BotConfigLoader(config);
  }
}

final class _BotConfigLoader implements BotConfig {
  const _BotConfigLoader(this._botConfig);

  final Map<String, Object?> _botConfig;

  @override
  String get serverID => _botConfig['server_id']! as String;

  @override
  String get botToken => _botConfig['bot_token']! as String;

  @override
  String get lfgChannel => _botConfig['lfg_channel']! as String;

  @override
  String get promoChannel => _botConfig['promo_channel']! as String;

  @override
  List<String>? get deleteDeletedMessagesFromChannels =>
      _botConfig['delete_deleted_messages_from_channels'] as List<String>?;
}
