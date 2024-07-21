import 'package:l/l.dart';

import '../../../../core/data/models/activity_data.dart';
import '../../../../core/data/models/taken_roles.dart';
import '../../../../core/utils/event_parsers.dart';
import '../../../interactor/interactor_component.dart';

class RolePickerComponent {
  const RolePickerComponent();

  static Future<MessageBuilder> builder({
    required ActivityData activityData,
    required String customID,
    int? postID,
  }) async {
    // get all taken roles
    final takenRoles = postID == null
        ? <TakenRoles>[]
        : await Services.i.postsDatabase.getAllTakenRoles(
            activity: activityData,
            id: postID,
          );

    final List<String> toRemove = [];
    for (final role in takenRoles) {
      l.d('Role ${role.role} is taken ${role.taken}/${role.total}');
      if (role.taken >= role.total) {
        l.d('Role ${role.role} is full');
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
