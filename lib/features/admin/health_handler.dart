part of 'admin_commands_creator.dart';

Future<void> _healthBotHandler(
  InteractionCreateEvent<ApplicationCommandInteraction> interaction,
) async {
  final member = interaction.interaction.member;

  if (member == null) return; // refuse to work with bots
  if (!(member.permissions?.has(Permissions.administrator) ?? false)) return;

  final now = DateTime.now().millisecondsSinceEpoch;
  final timestamp = interaction.interaction.id.timestamp.millisecondsSinceEpoch;
  final ping = timestamp - now;

  final database = Context.root.get<PostsDatabase>('db');
  final lfgManager = Context.root.get<LFGManager>('manager');
  final bot = Context.root.get<LFGBotCore>('core');
  final scheduler =
      PostScheduler(database: database, core: bot, lfgManager: lfgManager);

  int? scheduledPostsCount;
  List<PostsTableData>? totalPosts;
  final serviceStatus = StringBuffer();
  final response = StringBuffer()
    ..writeln('Stats:')
    ..writeln('Ping: $ping ms')
    ..writeln()
    ..writeln('LFGs:');

  try {
    scheduledPostsCount = scheduler.getScheduledPosts();
    response.writeln('Scheduled: $scheduledPostsCount');
  } on Exception catch (e) {
    response.writeln('Scheduled: Недоступно');
    serviceStatus.writeln('Scheduler недоступен: $e');
  }

  try {
    totalPosts = await database.getAllPosts();
    response.writeln('Total: ${totalPosts.length}');
  } on Exception catch (e) {
    response.writeln('Total: Недоступно');
    serviceStatus.writeln('PostsDatabase недоступна: $e');
  }

  response
    ..writeln()
    ..writeln('Services:')
    ..writeln(serviceStatus.isEmpty ? 'OK' : serviceStatus);

  await interaction.interaction.respond(
    MessageBuilder(content: response.toString()),
    isEphemeral: true,
  );
}
