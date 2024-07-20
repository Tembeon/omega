import 'package:l/l.dart';

import '../../../../core/data/models/activity_data.dart';
import '../../../../core/utils/event_parsers.dart';
import '../../../interactor/interactor_component.dart';

class RolePickerComponent extends InteractorMessageComponent {
  const RolePickerComponent();

  @override
  Future<String> uniqueID(Services services) async {
    return 'role_picker';
  }

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<MessageComponentInteraction> event,
    Services services,
  ) async {
    l.d(event);

    await event.interaction.respond(
      MessageBuilder(content: 'Check logs'),
      isEphemeral: true,
    );
  }

  static MessageBuilder builder({
    required ActivityData activityData,
    required String customID,
  }) =>
      MessageBuilder(
        content: 'Выберите роль для участия:',
        components: [
          ActionRowBuilder(
            components: [
              SelectMenuBuilder.stringSelect(
                customId: customID,
                options: activityData.roles!
                    .map(
                      (e) => SelectMenuOptionBuilder(
                        label: sanitize(e.role),
                        value: e.role,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      );
}
