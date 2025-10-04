import 'dart:async';

import '../../../../core/l10n/messages.dart';
import '../../../../core/utils/interaction_answer.dart';
import '../../../interactor/component_interceptor.dart';
import '../../../interactor/interactor_component.dart';
import '../../interceptors/role_list_interceptor.dart';

class JoinMessageComponent extends InteractorMessageComponent {
  const JoinMessageComponent();

  @override
  Future<String> uniqueID(Services services) async {
    return 'join';
  }

  @override
  Set<ComponentInterceptor<Interaction<Object?>>> get interceptors => {
        ...super.interceptors,
        const RoleListInterceptor(),
      };

  @override
  Future<void> handle(
    String commandName,
    InteractionCreateEvent<MessageComponentInteraction> event,
    Services services,
  ) async {
    final messageID = event.interaction.message?.id;
    if (messageID == null) return;

    final lfgManager = services.lfgManager;

    await lfgManager.addMemberTo(
      event.interaction.message!,
      event.interaction.member!,
      rolePicker: () async {
        final customID = 'role_picker_${event.interaction.member!.user!.id.value}_$messageID';
        final Completer<String?> pickedRole = Completer();
        Services.i.interactor.subscribeToComponent(
          customID: customID,
          handler: (event) async {
            final r = event.interaction.data.values;
            final roleName = r?.first;
            pickedRole.complete(roleName);

            await event.interaction.respond(
              MessageBuilder(content: joinComponentRolePicked(roleName ?? '')),
              isEphemeral: true,
            );
          },
        );

        return pickedRole.future;
      },
    );

    await event.interaction.answer(MessageBuilder(content: joinComponentJoined), isEphemeral: true);
  }
}

Future<void> askToPickRole<T extends Interaction<Object?>>(
  InteractionCreateEvent<T> c, {
  required String customID,
}) async {
  final interaction = c.interaction;
  if (interaction is MessageResponse) {
    await interaction.createFollowup(
      MessageBuilder(
        content: joinComponentPrompt,
        components: [
          ActionRowBuilder(
            components: [
              SelectMenuBuilder.stringSelect(
                customId: customID,
                options: [
                  SelectMenuOptionBuilder(
                    label: joinComponentRoleExampleOne,
                    value: 'role1',
                  ),
                  SelectMenuOptionBuilder(
                    label: joinComponentRoleExampleTwo,
                    value: 'role2',
                  ),
                  SelectMenuOptionBuilder(
                    label: joinComponentRoleExampleThree,
                    value: 'role3',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      isEphemeral: true,
    );
  }
}
