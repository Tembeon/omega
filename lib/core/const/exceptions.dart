import 'package:io/io.dart';

/// Base class for all fatal exceptions.
abstract class FatalException implements Exception {
  factory FatalException([Object? message]) => _FatalException(message);

  /// Exit code to use when exiting the process.
  int get exitCode;
}

/// Default implementation of [FatalException] which carries a message and an exit code.
class _FatalException implements FatalException {
  const _FatalException([this.message]);

  /// Message describing the exception.
  final Object? message;

  /// Default exit code for fatal exceptions.
  ///
  /// See more at [ExitCode.unavailable].
  @override
  int get exitCode => ExitCode.unavailable.code;

  @override
  String toString() {
    final sb = StringBuffer()..write('FatalException');
    if (message != null) {
      sb.write(': $message');
    }

    return sb.toString();
  }
}

base class ConfigFileMissing implements FatalException {
  const ConfigFileMissing(
    this.configFileName, {
    this.configPath,
  });

  /// Message to show.
  final String configFileName;

  /// Path to the config file.
  final String? configPath;

  @override
  int get exitCode => ExitCode.config.code;

  @override
  String toString() {
    final sb = StringBuffer()..writeln('Config file "$configFileName" is missing, please create one.');
    if (configPath != null) {
      sb.writeln('Path: $configPath');
    }

    return sb.toString();
  }
}
