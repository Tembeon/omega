import 'package:nyxx/nyxx.dart';

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
  factory Activity.custom(Map<String, dynamic> json) => _JsonActivity(
        name: json['name'] as String,
        maxMembers: json['max_members'] as int,
        bannerUrl: json['banner_url'] as String,
        enabled: json['enabled'] as bool,
      );

  /// Creates dungeon activity from json
  factory Activity.dungeon(Map<String, dynamic> json) = _JsonActivity.dungeon;

  /// Creates raid activity from json
  factory Activity.raid(Map<String, dynamic> json) = _JsonActivity.raid;
}

class _JsonActivity implements Activity {
  const _JsonActivity({
    required String name,
    required int maxMembers,
    required String bannerUrl,
    required bool enabled,
  })  : _name = name,
        _maxMembers = maxMembers,
        _bannerUrl = bannerUrl,
        _enabled = enabled;

  final String _name;
  final int _maxMembers;
  final String _bannerUrl;
  final bool _enabled;

  @override
  String get name => _name;

  @override
  int get maxMembers => _maxMembers;

  @override
  String get bannerUrl => _bannerUrl;

  @override
  bool get enabled => _enabled;

  factory _JsonActivity.dungeon(Map<String, dynamic> json) {
    return _JsonActivity(
      name: json['name'] as String,
      maxMembers: 3,
      bannerUrl: json['banner_url'] as String,
      enabled: json['enabled'] as bool,
    );
  }

  factory _JsonActivity.raid(Map<String, dynamic> json) {
    return _JsonActivity(
      name: json['name'] as String,
      maxMembers: 6,
      bannerUrl: json['banner_url'] as String,
      enabled: json['enabled'] as bool,
    );
  }
}

/// Represents activity for LFG Builder
final class LFGActivity implements Activity {
  const LFGActivity({
    required String name,
    required int maxMembers,
    required String bannerUrl,
    required bool enabled,
    required String description,
    required Snowflake author,
    required int id,
  })  : _name = name,
        _description = description,
        _maxMembers = maxMembers,
        _bannerUrl = bannerUrl,
        _enabled = enabled,
        _author = author,
        _id = id;

  final String _name;
  final String _description;
  final String _bannerUrl;
  final bool _enabled;
  final int _maxMembers;
  final Snowflake _author;
  final int _id;

  @override
  String get name => _name;

  /// Description of the activity, passed by the user.
  String get description => _description;

  /// Author of the activity.
  Snowflake get author => _author;

  /// Activity id. Provided by the database.
  int get id => _id;

  @override
  String get bannerUrl => _bannerUrl;

  @override
  bool get enabled => _enabled;

  @override
  int get maxMembers => _maxMembers;
}
