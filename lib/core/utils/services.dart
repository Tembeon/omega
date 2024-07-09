import 'dart:ffi';
import 'dart:io';

import 'package:nyxx/nyxx.dart';

import '../../features/interactor/interactor.dart';
import '../../features/lfg_manager/lfg_manager.dart';
import '../../features/lfg_manager/message_handler.dart';
import '../../features/scheduler/scheduler.dart';
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
final class Services {
  /// {@macro Dependencies}
  const Services._({
    required this.config,
    required this.postScheduler,
    required this.postsDatabase,
    required this.lfgManager,
    required this.interactor,
    required this.bot,
  });

  /// Stores instance of [Services].
  static Services? _instance;

  /// {@macro Dependencies}
  static Services get i => instance;

  /// {@macro Dependencies}
  static Services get instance {
    if (_instance == null) {
      throw Exception('Dependencies not initialized. Call Dependencies.initialize first.');
    }

    return _instance!;
  }

  /// Initializes [Services] with provided [Config].
  static Future<Services> initialize({required Config config}) async {
    if (_instance != null) {
      throw Exception('Dependencies already initialized. Use Dependencies.instance to get instance.');
    }

    _loadSqlite();

    final bot = await Nyxx.connectGateway(
      config.token,
      GatewayIntents.allUnprivileged | GatewayIntents.guildMessages,
      options: GatewayClientOptions(
        loggerName: 'LFG Bot',
        plugins: [
          Logging(),
          CliIntegration(),
          IgnoreExceptions(),
        ],
      ),
    );

    final postsDatabase = PostsDatabase();

    final lfgManager = LFGManager(database: postsDatabase, messageHandler: const MessageHandler());

    final dep = Services._(
      bot: bot,
      config: config,
      postsDatabase: postsDatabase,
      lfgManager: lfgManager,
      postScheduler: PostScheduler(database: postsDatabase, bot: bot, lfgManager: lfgManager),
      interactor: Interactor(bot: bot, serverId: config.server),
    );

    return _instance = dep;
  }

  /// {@macro Config}
  final Config config;

  final PostScheduler postScheduler;

  ///
  final PostsDatabase postsDatabase;

  /// {@macro ILFGManager}
  final ILFGManager lfgManager;

  /// {@macro Interactor}
  final Interactor interactor;

  /// Current active bot (WebSocket).
  final NyxxGateway bot;
}
