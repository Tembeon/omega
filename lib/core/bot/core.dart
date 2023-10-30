import 'package:nyxx/nyxx.dart';

import '../utils/loaders/bot_settings.dart';

class LFGBotCore {
  const LFGBotCore({
    required this.bot,
  });

  /// Current active bot (WebSocket).
  final NyxxGateway bot;

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

    // bot.commands.create(ApplicationCommandBuilder(name: name, type: type));

    return LFGBotCore(
      bot: bot,
    );
  }

  static LFGBotCore? _instance;

  /// Returns current active instance.
  static LFGBotCore get instance {
    if (_instance == null) {
      throw Exception('Bot is not initialized');
    }

    return _instance!;
  }
}
