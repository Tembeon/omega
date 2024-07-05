part of 'admin_commands_creator.dart';

Future<void> _deleteLFGHandler(
  InteractionCreateEvent<ApplicationCommandInteraction> interaction,
) async {
  final member = interaction.interaction.member;
  if (member == null) return; // refuse to work with bots
  if (!(member.permissions?.has(Permissions.administrator) ?? false)) {
    return; // Check if user is administrator
  }
  final userName = member.nick ?? member.user?.username;

  // This is designed to extract the value of the message_id parameter from the interaction data.
  final messageId = interaction.interaction.data.options!.first.options!.firstWhere(
    (e) => e.name == 'message_id',
  );
  final database = Context.root.get<PostsDatabase>('db');

  // All LFG IDs are unique, so we look for the first entry where the [message_id] is exactly what the user provided.
  final postData = await database.findPost(int.parse(messageId.value as String));

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

  // If the deletion was successful, we show it to the user.
  await interaction.interaction.respond(
    MessageBuilder(
      content: 'LFG пользователя "$userName", с активностью "${postData.title}" удалено.',
    ),
    isEphemeral: true,
  );
}
