import '../../../core/const/command_exceptions.dart';
import '../../interactor/component_interceptor.dart';
import '../../interactor/interactor_component.dart';

/// {@template AlwaysUserInterceptor}
///
/// Interceptor that checks user is a member of guild.
///
/// {@endtemplate}
base class AlwaysMemberInterceptor extends ComponentInterceptor {
  /// {@macro AlwaysUserInterceptor}
  const AlwaysMemberInterceptor();

  @override
  Future<void> intercept(
    InteractionCreateEvent<Interaction<Object?>> event,
    Services services,
  ) async {
    final member = event.interaction.member;

    if (member == null) {
      throw const CantRespondException('Не удалось определить пользователя');
    }
  }
}

/// {@template PermissionUserInterceptor}
///
/// Interceptor that checks user has a specific permission.
/// If not, throws [CantRespondException].
///
/// {@endtemplate}
base class PermissionUserInterceptor extends AlwaysMemberInterceptor {
  /// {@macro PermissionUserInterceptor}
  const PermissionUserInterceptor(this.permission);

  final Flag<Permissions> permission;

  @override
  Future<void> intercept(
    InteractionCreateEvent<Interaction<Object?>> event,
    Services services,
  ) async {
    await super.intercept(event, services);

    final member = event.interaction.member!;

    final hasPermission = member.permissions?.has(permission) ?? false;

    if (!hasPermission) {
      throw const CantRespondException('У вас недостаточно прав для использования этой команды');
    }
  }
}

/// {@template OnlyAdminUserInterceptor}
///
/// Interceptor that checks user is an administrator.
///
/// {@endtemplate}
base class OnlyAdminUserInterceptor extends PermissionUserInterceptor {
  /// {@macro OnlyAdminUserInterceptor}
  const OnlyAdminUserInterceptor() : super(Permissions.administrator);
}
