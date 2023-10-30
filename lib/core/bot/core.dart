import 'package:nyxx/nyxx.dart';

import '../../features/command_manager/command_manager.dart';
import '../utils/loaders/bot_settings.dart';

class LFGBotCore {
  const LFGBotCore({
    required this.bot,
    required this.commandManager,
  });

  /// Current active bot (WebSocket).
  final NyxxGateway bot;

  /// Manages bot commands.
  final CommandManager commandManager;

  static LFGBotCore? _instance;

  /// Returns current active instance.
  static LFGBotCore get instance {
    if (_instance == null) {
      throw Exception('Bot is not initialized');
    }

    return _instance!;
  }

  /// Initializes connection to Discord using WebSocket and syncs interactions.
  static Future<LFGBotCore> initialize() async {
    if (_instance != null) {
      throw Exception('Bot is already initialized');
    }

    // create bot with intents and register plugins
    final bot = await Nyxx.connectGateway(
      BotSettings.instance.botConfig.botToken,
      GatewayIntents.allUnprivileged | GatewayIntents.guildMessages,
      options: GatewayClientOptions(
        plugins: [
          Logging(),
          CliIntegration(),
          IgnoreExceptions(),
        ],
      ),
    );

    final commandManager = CommandManager(bot: bot)..startListenInteractions();

    return LFGBotCore(
      bot: bot,
      commandManager: commandManager,
    );
  }
}
