import 'package:nyxx/nyxx.dart';

import '../../features/interactor/interactor.dart';
import '../../features/lfg_manager/lfg_manager.dart';
import '../../features/lfg_manager/lfg_message_builder.dart';
import '../../features/promoter/promoter.dart';
import '../../features/scheduler/scheduler.dart';
import '../../features/settings/settings.dart';
import 'config.dart';
import 'database/settings/db.dart';
import 'database/tables/posts.dart';

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
    required this.settings,
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

    final bot = await Nyxx.connectGateway(
      config.token,
      GatewayIntents.allUnprivileged | GatewayIntents.guildMessages,
      options: GatewayClientOptions(
        loggerName: 'LFG Bot',
        plugins: [
          Logging(),
          CliIntegration(),
          IgnoreExceptions(), // Ignore Discord exceptions. Exceptions from program still will cause crash.
        ],
      ),
    );

    final postsDatabase = PostsDatabase();
    final interactor = Interactor(bot: bot, serverId: config.server);
    final settings = Settings(database: SettingsDatabase(), interactor: interactor, postsDatabase: postsDatabase);
    final promoter = Promoter(bot: bot, settings: settings);
    final lfgManager = LFGManager(
      database: postsDatabase,
      lfgBuilder: const LfgMessageBuilder(),
      promoter: promoter,
    );

    final services = Services._(
      bot: bot,
      config: config,
      postsDatabase: postsDatabase,
      lfgManager: lfgManager,
      postScheduler: PostScheduler(database: postsDatabase, bot: bot, lfgManager: lfgManager),
      interactor: interactor,
      settings: settings,
    );

    return _instance = services;
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

  final Settings settings;
}
