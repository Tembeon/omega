import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../features/commands/create/create_category.dart';
import '../utils/context/context.dart';
import '../utils/loaders/bot_settings.dart';

class LFGBotCore {
  const LFGBotCore({
    required this.bot,
    required this.interactions,
    required this.context,
  });

  /// Current active bot (WebSocket).
  final INyxxWebsocket bot;

  /// Interactions with bot.
  final IInteractions interactions;

  /// Root context. Empty by default.
  final Context context;

  /// Initializes connection to Discord using WebSocket and syncs interactions.
  static Future<LFGBotCore> initialize() async {
    if (_instance != null) {
      throw Exception('Bot is already initialized');
    }

    // create bot with intents and register plugins
    final bot = NyxxFactory.createNyxxWebsocket(
      BotSettings.instance.botConfig.botToken,
      GatewayIntents.allUnprivileged | GatewayIntents.guildMessages,
    )
      ..registerPlugin(Logging())
      ..registerPlugin(CliIntegration())
      ..registerPlugin(IgnoreExceptions());

    // connect to Discord
    await bot.connect();

    // create interactions with bot (slash commands, buttons, etc.)
    final interactions = IInteractions.create(WebsocketInteractionBackend(bot))
      ..registerSlashCommand(CategoryCreate.create)
      ..syncOnReady();

    return LFGBotCore(
      bot: bot,
      interactions: interactions,
      context: Context.empty(),
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
