import '../../utils/database/settings/db.dart';

base class ActivityData {
  const ActivityData({
    required this.name,
    required this.maxMembers,
    required this.bannerUrl,
    required this.roles,
    required this.enabled,
  });

  factory ActivityData.fromDatabase({
    required ActivitiesTableData activity,
    List<ActivitiesRolesTableData>? roles,
  }) =>
      ActivityData(
        name: activity.name,
        maxMembers: activity.maxMembers,
        bannerUrl: activity.bannerUrl,
        roles: roles?.map((role) => ActivityRole(role: role.role)).toList(),
        enabled: activity.enabled,
      );

  final String name;

  final int maxMembers;

  final String? bannerUrl;

  final List<ActivityRole>? roles;

  final bool enabled;
}

class ActivityRole {
  const ActivityRole({
    required this.role,
  });

  final String role;
}
