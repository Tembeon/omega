part of 'admin_commands_creator.dart';

Future<void> _healthBotHandler(
  InteractionCreateEvent<ApplicationCommandInteraction> interaction,
) async {
  final member = interaction.interaction.member;

  if (member == null) return; // refuse to work with bots
  if (!(member.permissions?.has(Permissions.administrator) ?? false)) {
    return; // Check if user is administrator
  }

  // To calculate the ping we will take the time when the command was executed [timestamp]
  // and the time when it was sent [now] and subtract them.
  final now = DateTime.now().millisecondsSinceEpoch;
  final timestamp = interaction.interaction.id.timestamp.millisecondsSinceEpoch;

  final database = Dependencies.i.postsDatabase;
  final scheduler = Dependencies.i.postScheduler;

  final response = StringBuffer()
    ..writeln('**Stats:**')..writeln('Ping: ${timestamp - now}ms')..writeln()..writeln('**LFGs:**');

  // If any exception was caught, then show it to user.
  try {
    response.writeln('Scheduled: ${scheduler.getScheduledPostsCount()}');
  } on Exception catch (e) {
    response.writeln('Scheduler unavailable: $e');
  }

  try {
    response.writeln('Total: ${await database.getAllPostsCount()}');
  } on Exception catch (e) {
    response.writeln('Database unavailable: $e');
  }

  await interaction.interaction.respond(
    MessageBuilder(content: response.toString()),
    isEphemeral: true,
  );
}
