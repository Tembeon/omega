import 'package:nyxx/nyxx.dart';

import '../../../core/utils/interaction_answer.dart';
import '../../../core/utils/services.dart';
import '../../interactor/component_interceptor.dart';
import '../buttons/role_picker/role_picker_component.dart';

/// {@template RoleListInterceptor}
///
/// Interceptor, which asks user to pick activity role, if activity has some roles.
///
/// {@endtemplate}
base class RoleListInterceptor extends ComponentMessageInterceptor {
  /// {@macro RoleListInterceptor}
  const RoleListInterceptor();

  @override
  Future<void> intercept(
    InteractionCreateEvent<MessageComponentInteraction> event,
    Services services,
  ) async {
    final post = await services.postsDatabase.findPost(event.interaction.message!.id.value);
    if (post == null) return;

    final activityData = await services.settings.getActivity(post.title);
    if (activityData.roles == null || activityData.roles!.isEmpty) return;

    final members = await services.postsDatabase.getMembersForPost(event.interaction.message!.id.value);
    final userID = event.interaction.member!.user!.id.value;

    if (members.contains(userID)) {
      return;
    }

    final customID = 'role_picker_${event.interaction.member!.user!.id.value}_${event.interaction.message!.id.value}';

    await event.interaction.answer(
      await RolePickerComponent.builder(
        activityData: activityData,
        customID: customID,
        postID: event.interaction.message!.id.value,
      ),
      isEphemeral: true,
    );
  }
}
