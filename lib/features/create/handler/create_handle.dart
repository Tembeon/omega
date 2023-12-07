import 'package:nyxx/nyxx.dart';

import '../../command_manager/command_manager.dart';

CommandCreator createRaidCommand() {
  return (
    builder: createCommandBuilder,
    handler: _handler,
  );
}

Future<void> _handler(InteractionCreateEvent<ApplicationCommandInteraction> interaction) {
  return interaction.interaction.respond(
    MessageBuilder(
      content: 'Raid created',
    ),
  );
}

ApplicationCommandBuilder createCommandBuilder() {
  return ApplicationCommandBuilder(
    name: 'create',
    description: 'Создать активность',
    type: ApplicationCommandType.chatInput,
    options: [
      CommandOptionBuilder.subCommand(
        name: 'raid',
        description: 'Создать рейд',
        options: [
          CommandOptionBuilder.string(
            name: 'название',
            description: 'Введите название активности',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'описание',
            description: 'Введите описание активности',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'дата',
            description: 'Введите дату начала активности [15 01 2023]',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'время',
            description: 'Введите время начала активности [15 01]',
            isRequired: true,
          ),
          CommandOptionBuilder.string(
            name: 'часовой_пояс',
            description: 'Введите ваш текущий часовой пояс',
            isRequired: true,
          ),
        ],
      ),
    ],
  );
}
