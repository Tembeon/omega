import 'dart:io';

import 'package:nyxx/nyxx.dart';

import '../const/exceptions.dart';

/// {@template Config}
///
/// Core configuration for bot necessary for it's work.
///
/// {@endtemplate}
final class Config {
  /// {@macro Config}
  const Config({
    required this.token,
    required this.serverId,
  });

  /// Creates a new [Config] instance from environment variables.
  ///
  /// Will throw [EnvironmentVariableMissing] if any of the required variables are missing.
  factory Config.fromEnvironment() {
    final env = Platform.environment;

    return Config(
      token: _read('OMEGA_TOKEN', env),
      serverId: int.parse(_read('OMEGA_SERVER_ID', env)),
    );
  }

  static String _read(String key, Map<String, String> env) {
    final value = env[key];
    if (value == null) {
      throw EnvironmentVariableMissing(key);
    }

    return value;
  }

  /// Discord bot token.
  final String token;

  /// {@template Config.ServerId}
  ///
  /// Discord server id where bot is located.
  ///
  /// This is necessary, because bot will only register commands in this server.
  ///
  /// {@endtemplate}
  final int serverId;

  /// {@macro Config.ServerId}
  Snowflake get server => Snowflake(serverId);
}
