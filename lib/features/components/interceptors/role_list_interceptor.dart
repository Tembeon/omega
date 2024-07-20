import 'package:nyxx/nyxx.dart';

import '../../../core/utils/event_parsers.dart';
import '../../../core/utils/services.dart';
import '../../interactor/component_interceptor.dart';

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

    final customID = 'role_picker_${event.interaction.member!.user!.id.value}';

    await event.interaction.respond(
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
      ),
      isEphemeral: true,
    );
  }
}
