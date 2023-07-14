import 'dart:convert';
import 'dart:io';

import 'package:nyxx/nyxx.dart';

import 'config_data_loader.dart';

class Flavors {
  const Flavors._({
    required this.data,
  });

  /// Holds all data for current flavor.
  final FlavorsData data;

  /// Get data for current flavor.
  static FlavorsData get d => instance.data;

  static Flavors get instance => _instance ??= throw UnimplementedError('Please, call [use] once');

  static Flavors? _instance;

  static bool isTestEnvironment = false;

  /// Initialize flavor using configuration file.
  static Flavors readFromFile({bool useTestEnvironment = false}) {
    if (_instance != null) {
      throw Exception('Flavor already initialized');
    }

    if (useTestEnvironment) {
      isTestEnvironment = true;
    }

    final config = File(useTestEnvironment ? 'data/config_stage.json' : 'data/config.json');

    // Check if config file exists.
    if (!config.existsSync()) {
      throw ConfigFileMissing('config.json', configPath: config.path);
    }

    // Read config file.
    final configData = jsonDecode(config.readAsStringSync()) as Map<String, dynamic>;
    _instance = Flavors._(data: FlavorsData.fromJson(configData));

    return instance;
  }
}

class FlavorsData {
  FlavorsData._({
    required this.server,
    required this.botToken,
    required this.lfgChannel,
    required this.promoChannel,
    required this.cleanupChannel,
  });

  /// Server where commands will be registered.
  final Snowflake server;

  /// Bot token.
  final String botToken;

  /// Channel where bot tries to find created LFG posts.
  final Snowflake lfgChannel;

  /// Channel where bot promotes newly created LFG posts with random phrase.
  final Snowflake promoChannel;

  /// Channel where bot checks for deleted messages text
  ///
  /// [Original Message Deleted]
  final Snowflake cleanupChannel;

  factory FlavorsData.fromJson(Map<String, dynamic> json) {
    return FlavorsData._(
      server: Snowflake(json['server'] as String),
      botToken: json['botToken'] as String,
      lfgChannel: Snowflake(json['lfgChannel'] as String),
      promoChannel: Snowflake(json['promoChannel'] as String),
      cleanupChannel: Snowflake(json['eventsChannel'] as String),
    );
  }

  @override
  String toString() {
    return 'FlavorsData{server: $server, botToken: $botToken, lfgChannel: $lfgChannel, promoChannel: $promoChannel, eventsChannel: $cleanupChannel}';
  }
}
