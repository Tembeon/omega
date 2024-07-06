import 'package:nyxx/nyxx.dart';

import '../../features/command_manager/command_manager.dart';
import '../utils/config.dart';

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
  static Future<LFGBotCore> initialize({required Config config}) async {
    // create bot with intents and register plugins
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

    return LFGBotCore(
      bot: bot,
      commandManager: CommandManager(bot: bot, server: config.server),
    );
  }
}
