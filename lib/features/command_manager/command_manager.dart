import 'package:nyxx/nyxx.dart';

class CommandManager {
  const CommandManager({
    required NyxxGateway bot,
  }) : _bot = bot;

  final NyxxGateway _bot;

  void startListenInteractions() {
    _bot.onApplicationCommandInteraction.listen((event) {
      if (event.interaction.data.name.contains('create')) {
        event.interaction.guild?.scheduledEvents.create(
          ScheduledEventBuilder(
            channelId: const Snowflake(1168637201005940958),
            metadata: EntityMetadata(
              location: 'Test location',
            ),
            description: 'Some test description',
            name: 'Test LFG name',
            privacyLevel: PrivacyLevel.guildOnly,
            scheduledStartTime: DateTime.now().toUtc().add(const Duration(minutes: 5)),
            scheduledEndTime: DateTime.now().toUtc().add(const Duration(minutes: 10)),
            type: ScheduledEntityType.voice,
          ),
        );

        event.interaction.respond(MessageBuilder(content: 'New event was created'));
      }
    });
  }
}
