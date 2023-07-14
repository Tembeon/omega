import 'package:lfg_bot/features/commands/create/create_category.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

class BotInteractions {
  BotInteractions(INyxxWebsocket bot) {
    _interactions = IInteractions.create(WebsocketInteractionBackend(bot));

    interactions
      ..registerSlashCommand(CategoryCreate.create)
      ..syncOnReady();
  }

  IInteractions? _interactions;

  IInteractions get interactions => _interactions ??= throw Exception('Interactions is not loaded');
}
