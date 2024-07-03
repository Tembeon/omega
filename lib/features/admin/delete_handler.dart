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

  final messageId =
      interaction.interaction.data.options!.first.options!.firstWhere(
    (e) => e.name == 'message_id',
  ); // Searching first entry with exact message_id
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
