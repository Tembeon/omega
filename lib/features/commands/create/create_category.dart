import 'package:lfg_bot/core/utils/flavors.dart';
import 'package:lfg_bot/features/activity_builder/unexpected_error_message.dart';
import 'package:lfg_bot/features/commands/command_exceptions.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../../core/data/enums/activity_type.dart';
import '../../activity_builder/builder.dart';
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
      guild: Flavors.d.server,
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
    sendFormatExceptionMessage(event);
  } on CantRespond catch (e) {
    sendUnexpectedErrorMessage(event, e: e.toHumanMessage());
  } catch (e) {
    sendUnexpectedErrorMessage(event, e: e);
  }
}
