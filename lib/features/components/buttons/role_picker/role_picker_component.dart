import 'package:l/l.dart';

import '../../../../core/data/models/activity_data.dart';
import '../../../../core/data/models/taken_roles.dart';
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

  static Future<MessageBuilder> builder({
    required ActivityData activityData,
    required String customID,
    int? postID,
  }) async {
    // get all taken roles
    final takenRoles = postID != null
        ? <TakenRoles>[]
        : await Services.i.postsDatabase.getAllTakenRoles(
            activity: activityData,
            id: postID!,
          );

    final List<String> toRemove = [];
    for (final role in takenRoles) {
      if (role.taken >= role.total) {
        toRemove.add(role.role);
      }
    }

    final toGenerate = activityData.roles!.where((element) => !toRemove.contains(element.role)).toList();

    final listOfOption = toGenerate
        .map(
          (e) => SelectMenuOptionBuilder(
            label: sanitize(e.role),
            value: e.role,
          ),
        )
        .toList();

    return MessageBuilder(
      content: 'Выберите роль для участия:',
      components: [
        ActionRowBuilder(
          components: [
            SelectMenuBuilder.stringSelect(
              customId: customID,
              options: listOfOption,
            ),
          ],
        ),
      ],
    );
  }
}
