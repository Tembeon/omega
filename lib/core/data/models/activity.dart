/// Base class for all activities.
abstract interface class Activity {
  /// Visible name of the activity
  String get name;

  /// Max members for activity
  int get maxMembers;

  /// Image url for activity
  String get bannerUrl;

  /// Is activity enabled
  bool get enabled;

  /// Creates activity from json
  factory Activity.custom(Map<String, Object?> json) => _JsonActivity(
        name: json['name']! as String,
        maxMembers: json['max_members']! as int,
        bannerUrl: json['banner_url']! as String,
        enabled: json['enabled']! as bool,
      );

  /// Creates dungeon activity from json
  factory Activity.dungeon(Map<String, Object?> json) = _JsonActivity.dungeon;

  /// Creates raid activity from json
  factory Activity.raid(Map<String, Object?> json) = _JsonActivity.raid;
}

class _JsonActivity implements Activity {
  const _JsonActivity({
    required this.name,
    required this.maxMembers,
    required this.bannerUrl,
    required this.enabled,
  });

  @override
  final String name;

  @override
  final int maxMembers;

  @override
  final String bannerUrl;

  @override
  final bool enabled;

  factory _JsonActivity.dungeon(Map<String, Object?> json) {
    return _JsonActivity(
      name: json['name']! as String,
      maxMembers: 3,
      bannerUrl: json['banner_url']! as String,
      enabled: json['enabled']! as bool,
    );
  }

  factory _JsonActivity.raid(Map<String, Object?> json) {
    return _JsonActivity(
      name: json['name']! as String,
      maxMembers: 6,
      bannerUrl: json['banner_url']! as String,
      enabled: json['enabled']! as bool,
    );
  }
}
