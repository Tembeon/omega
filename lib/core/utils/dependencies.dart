import 'dart:ffi';
import 'dart:io';

import '../../features/command_manager/command_manager.dart';
import '../../features/lfg_manager/lfg_manager.dart';
import '../../features/lfg_manager/message_handler.dart';
import '../../features/scheduler/scheduler.dart';
import '../bot/core.dart';
import '../const/exceptions.dart';
import 'config.dart';
import 'database/tables/posts.dart';

DynamicLibrary _loadSqlite() {
  return DynamicLibrary.open(_sqliteLibraryPath);
}

String get _sqliteLibraryPath {
  final scriptDir = File(Platform.script.toFilePath()).parent.parent;
  final libraryNextToScript = File('${scriptDir.path}/data/dependencies');
  if (Platform.isWindows) return '${libraryNextToScript.path}/dll/sqlite3.dll';
  if (Platform.isLinux) return '${libraryNextToScript.path}/so/sqlite3';
  if (Platform.isMacOS) return '${libraryNextToScript.path}/osx/sqlite3_arm64';

  throw FatalException('Unsupported platform: ${Platform.operatingSystem}');
}

/// {@template Dependencies}
///
/// Dependencies for the application.
/// Contains all core services for bot work.
///
/// {@endtemplate}
final class Dependencies {
  /// {@macro Dependencies}
  const Dependencies._({
    required this.config,
    required this.core,
    required this.commandManager,
    required this.postScheduler,
    required this.postsDatabase,
    required this.lfgManager,
  });

  /// Stores instance of [Dependencies].
  static Dependencies? _instance;

  /// {@macro Dependencies}
  static Dependencies get i => instance;

  /// {@macro Dependencies}
  static Dependencies get instance {
    if (_instance == null) {
      throw Exception('Dependencies not initialized. Call Dependencies.initialize first.');
    }

    return _instance!;
  }

  /// Initializes [Dependencies] with provided [Config].
  static Future<Dependencies> initialize({required Config config}) async {
    if (_instance != null) {
      throw Exception('Dependencies already initialized. Use Dependencies.instance to get instance.');
    }

    _loadSqlite();

    final core = await LFGBotCore.initialize(config: config);

    final postsDatabase = PostsDatabase();

    final lfgManager = LFGManager(database: postsDatabase, messageHandler: const MessageHandler());

    final dep = Dependencies._(
      config: config,
      core: core,
      postsDatabase: postsDatabase,
      lfgManager: lfgManager,
      commandManager: core.commandManager,
      postScheduler: PostScheduler(database: postsDatabase, core: core, lfgManager: lfgManager),
    );

    return _instance = dep;
  }

  /// {@macro Config}
  final Config config;

  final LFGBotCore core;

  final CommandManager commandManager;

  final PostScheduler postScheduler;

  final PostsDatabase postsDatabase;

  final LFGManager lfgManager;
}
