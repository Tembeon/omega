import 'dart:async';

import '../../../../core/const/command_exceptions.dart';
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

    try {
      await lfgManager.addMemberTo(
        event.interaction.message!,
        event.interaction.member!.user!,
        rolePicker: () async {
          final customID = 'role_picker_${event.interaction.member!.user!.id.value}';
          final Completer<String?> pickedRole = Completer();
          Services.i.interactor.subscribeToComponent(
            customID: customID,
            handler: (event) async {
              final r = event.interaction.data.values;
              pickedRole.complete(r?.first);
            },
          );

          return pickedRole.future;
        },
      );
      await event.interaction.createFollowup(MessageBuilder(content: 'Вы добавлены в LFG'), isEphemeral: true);
    } on CommandException catch (e) {
      await event.interaction.createFollowup(MessageBuilder(content: e.toHumanMessage()), isEphemeral: true);
    } on Object catch (e, st) {
      await event.interaction.createFollowup(
        MessageBuilder(
          content: 'Произошла неизвестная ошибка при добавлении вас в LFG\n'
              'Метаданные: $e\n'
              'Стек вызовов: $st',
        ),
        isEphemeral: true,
      );
    }
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
        content: 'Выберите роль для участия',
        components: [
          ActionRowBuilder(
            components: [
              SelectMenuBuilder.stringSelect(
                customId: customID,
                options: [
                  SelectMenuOptionBuilder(
                    label: 'Роль 1',
                    value: 'role1',
                  ),
                  SelectMenuOptionBuilder(
                    label: 'Роль 2',
                    value: 'role2',
                  ),
                  SelectMenuOptionBuilder(
                    label: 'Роль 3',
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
