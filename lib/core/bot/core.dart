import 'package:nyxx/nyxx.dart';

import '../../features/command_manager/command_manager.dart';
import '../../features/create/handler/create_handle.dart';
import '../utils/loaders/bot_settings.dart';

class LFGBotCore {
  const LFGBotCore({
    required this.bot,
    required this.commandManager,
  });

  /// Current active bot (WebSocket).
  ///
  /// You can get access to all bot features using this variable.
  final NyxxGateway bot;

  /// Manages bot commands.
  ///
  /// You can register new commands using this variable.
  final CommandManager commandManager;

  /// Initializes connection to Discord using WebSocket and syncs interactions.
  static Future<LFGBotCore> initialize() async {
    // create bot with intents and register plugins
    final bot = await Nyxx.connectGateway(
      BotSettings.instance.botConfig.botToken,
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

    final commandManager = CommandManager(bot: bot)
      ..listenInteractions()
      ..registerCommand(createRaidCommand());

    return LFGBotCore(
      bot: bot,
      commandManager: commandManager,
    );
  }
}
