import 'dart:async';

import 'package:nyxx/nyxx.dart';

import '../../core/bot/core.dart';
import '../../core/utils/context/context.dart';
import '../../core/utils/database/tables/posts.dart';
import '../command_manager/command_manager.dart';
import '../lfg_manager/lfg_manager.dart';
import '../scheduler/scheduler.dart';

CommandCreator adminCategoryCommands() {
  return (
    builder: _createAdminCommands,
    handlers: {
      'admin delete': _deleteLFGHandler,
      'admin health': _healthBotHandler,
    }
  );
}

Future<void> _deleteLFGHandler(
  InteractionCreateEvent<ApplicationCommandInteraction> interaction,
) async {
  final member = interaction.interaction.member;
  if (member == null) return; // refuse to work with bots
  if (!(member.permissions?.has(Permissions.administrator) ?? false)) return; // Check if user is administrator
  final userName = member.nick ?? member.user?.username;

  final messageId = interaction.interaction.data.options!.first.options!
      .firstWhere((e) => e.name == 'message_id'); // Searching first entry with exact message_id
  final database = Context.root.get<PostsDatabase>('db');
  final postData =
      await database.findPost(int.parse(messageId.value as String));

  // if post can't be found in database, then it's not LFG
  if (postData == null) {
    await interaction.interaction.respond(
      MessageBuilder(content: 'Данное сообщение не содержит LFG [LFGNotFound]'),
      isEphemeral: true,
    );
    return;
  }

  final lfgManager = Context.root.get<ILFGManager>('manager');

  await lfgManager.delete(int.parse(messageId.value as String));

  await interaction.interaction.respond(
    MessageBuilder(
      content:
          'LFG сообщение пользователя "$userName", с активностью "${postData.title}" удалено.',
    ),
    isEphemeral: true,
  );
}

Future<void> _healthBotHandler(
  InteractionCreateEvent<ApplicationCommandInteraction> interaction,
) async {
  final member = interaction.interaction.member;

  if (member == null) return; // refuse to work with bots
  if (!(member.permissions?.has(Permissions.administrator) ?? false)) return;

  final timestamp = interaction.interaction.id.timestamp.millisecondsSinceEpoch;
  final now = DateTime.now().millisecondsSinceEpoch;
  final ping = timestamp - now;

  final database = Context.root.get<PostsDatabase>('db');
  final lfgManager = Context.root.get<LFGManager>('manager');
  final bot = Context.root.get<LFGBotCore>('core');
  final scheduler =
      PostScheduler(database: database, core: bot, lfgManager: lfgManager);

  int? scheduledPostsCount;
  List<PostsTableData>? totalPosts;
  final serviceStatus = StringBuffer('OK');
  final response = StringBuffer()
    ..writeln('Stats:')
    ..writeln('Ping: $ping ms')
    ..writeln()
    ..writeln('LFGs:');

  try {
    scheduledPostsCount = scheduler.getScheduledPosts();
    response.writeln('Scheduled: $scheduledPostsCount');
  } on Exception catch (e) {
    response.writeln(e);
    serviceStatus.writeln('Scheduler is unavailable');
  }

  try {
    totalPosts = await database.getAllPosts();
    response.writeln('Total: ${totalPosts.length}');
  } on Exception catch (e) {
    response.writeln(e);
  serviceStatus.writeln('Database is unavailable');
  }

  response
    ..writeln()
    ..writeln('Services:')
    ..writeln(serviceStatus);

  await interaction.interaction.respond(
    MessageBuilder(content: response.toString()),
    isEphemeral: true,
  );
}

ApplicationCommandBuilder _createAdminCommands() {
  return ApplicationCommandBuilder(
    defaultMemberPermissions: Permissions.administrator,
    name: 'admin',
    description: 'Команды администратора',
    type: ApplicationCommandType.chatInput,
    options: [
      CommandOptionBuilder.subCommand(
        name: 'delete',
        description: 'Удалить LFG-сообщение',
        options: [
          CommandOptionBuilder.string(
            name: 'message_id',
            description: 'ID сообщения для удаления',
            isRequired: true,
          ),
        ],
      ),
      CommandOptionBuilder.subCommand(
        name: 'health',
        description: 'Узнать состояние бота',
        options: [],
      ),
    ],
  );
}
