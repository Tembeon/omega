import 'activity_data.dart';

base class TakenRoles extends ActivityRole {
  const TakenRoles({
    required super.role,
    required this.total,
    required this.taken,
  });

  final int total;

  final int taken;

  @override
  String toString() {
    return 'TakenRoles(role: $role, total: $total, taken: $taken)';
  }
}
