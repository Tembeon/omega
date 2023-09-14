import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../../core/data/enums/activity_type.dart';
import '../../../core/utils/loaders/bot_settings.dart';
import '../../activity_builder/builder.dart';
import '../../activity_builder/unexpected_error_message.dart';
import '../command_exceptions.dart';
import 'create_options.dart';

class CategoryCreate {
  static SlashCommandBuilder get create {
    return SlashCommandBuilder(
      'create',
      'Создать сбор',
      [
        _raid,
        _dungeon,
        _activity,
      ],
      canBeUsedInDm: false,
      guild: Snowflake(BotSettings.i.botConfig.serverID),
    );
  }
}

CommandOptionBuilder get _raid {
  return CommandOptionBuilder(
    CommandOptionType.subCommand,
    'raid',
    'Создать сбор на рейд.',
    options: createActivityOptionsFor(LFGActivityType.raid),
  )..registerHandler(_handleCreateCommand);
}

CommandOptionBuilder get _dungeon {
  return CommandOptionBuilder(
    CommandOptionType.subCommand,
    'dungeon',
    'Создать сбор в данж',
    options: createActivityOptionsFor(LFGActivityType.dungeon),
  )..registerHandler(_handleCreateCommand);
}

CommandOptionBuilder get _activity {
  return CommandOptionBuilder(
    CommandOptionType.subCommand,
    'activity',
    'Создать сбор в активность',
    options: createActivityOptionsFor(LFGActivityType.custom),
  )..registerHandler(_handleCreateCommand);
}

Future<void> _handleCreateCommand(ISlashCommandInteractionEvent event) async {
  try {
    final msg = await ActivityPostBuilder.fromCreate(event);
    await event.respond(msg);
  } on FormatException {
    await sendFormatExceptionMessage(event);
  } on CantRespond catch (e) {
    await sendUnexpectedErrorMessage(event, e: e.toHumanMessage());
  } on Object catch (e) {
    await sendUnexpectedErrorMessage(event, e: e);
  }
}
