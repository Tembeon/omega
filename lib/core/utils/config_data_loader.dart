import 'dart:convert';
import 'dart:io';

import 'package:lfg_bot/core/data/models/activity.dart';

import '../data/enums/activity_type.dart';

final class ConfigFileMissing implements Exception {
  const ConfigFileMissing(
    this.configFileName, {
    this.configPath,
  });

  /// Message to show.
  final String configFileName;

  /// Path to the config file.
  final String? configPath;

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln('Config file "$configFileName" is missing, please create one.');
    if (configPath != null) {
      sb.writeln('Path: $configPath');
    }

    return sb.toString();
  }
}

/// Loads activities from the config file.
final class ConfigDataLoader {
  /// file with the custom activities config.
  final customActivities = File('data/activities/custom.json');

  /// file with the dungeon config.
  final dungeonActivities = File('data/activities/dungeons.json');

  /// file with the raid config.
  final raidActivities = File('data/activities/raids.json');

  static final Map<String, List<Activity>> _activityData = {};

  /// Returns loaded activities in a map.
  ///
  /// Example:
  /// ```dart
  /// {
  ///  'custom': [ Activity(...), Activity(...), ... ],
  ///  'dungeons': [ Activity(...), Activity(...), ... ],
  ///  'raids': [ Activity(...), Activity(...), ... ],
  /// }
  /// ```
  static Map<String, List<Activity>> get activityData => _activityData;

  /// Returns loaded dungeon activities.
  static List<Activity> get dungeons => _activityData['dungeons'] ?? [];

  /// Returns loaded raid activities.
  static List<Activity> get raids => _activityData['raids'] ?? [];

  /// Returns loaded custom activities.
  static List<Activity> get custom => _activityData['custom'] ?? [];

  /// Try to identify activity type by name.
  /// Throws [ArgumentError] if activity not found.
  static LFGActivityType identifyActivity(String activityNane) {
    if (dungeons.any((dungeon) => dungeon.name == activityNane)) {
      return LFGActivityType.dungeon;
    } else if (raids.any((raid) => raid.name == activityNane)) {
      return LFGActivityType.raid;
    } else if (custom.any((custom) => custom.name == activityNane)) {
      return LFGActivityType.custom;
    } else {
      throw ArgumentError('Activity $activityNane not found');
    }
  }

  static Activity getActivityByName(String name) {
    final activityType = identifyActivity(name);
    switch (activityType) {
      case LFGActivityType.dungeon:
        return dungeons.firstWhere((dungeon) => dungeon.name == name);
      case LFGActivityType.raid:
        return raids.firstWhere((raid) => raid.name == name);
      case LFGActivityType.custom:
        return custom.firstWhere((custom) => custom.name == name);
    }
  }

  void load() {
    if (!customActivities.existsSync()) {
      throw ConfigFileMissing('custom.json', configPath: customActivities.path);
    }

    if (!dungeonActivities.existsSync()) {
      throw ConfigFileMissing('dungeons.json', configPath: dungeonActivities.path);
    }

    if (!raidActivities.existsSync()) {
      throw ConfigFileMissing('raids.json', configPath: raidActivities.path);
    }

    final customActivitiesData =
        (jsonDecode(customActivities.readAsStringSync()) as List<dynamic>).cast<Map<String, dynamic>>();
    final dungeonActivitiesData =
        (jsonDecode(dungeonActivities.readAsStringSync()) as List<dynamic>).cast<Map<String, dynamic>>();
    final raidActivitiesData =
        (jsonDecode(raidActivities.readAsStringSync()) as List<dynamic>).cast<Map<String, dynamic>>();

    _activityData['custom'] = _parseFrom(activityType: 'custom', data: customActivitiesData);
    _activityData['dungeons'] = _parseFrom(activityType: 'dungeons', data: dungeonActivitiesData);
    _activityData['raids'] = _parseFrom(activityType: 'raids', data: raidActivitiesData);

    print('Loaded ${_activityData.length} activities');
    print('Data: $_activityData');

    if (_activityData.isEmpty) {
      throw ConfigFileMissing('all configs are empty', configPath: 'data/activities/');
    }
  }

  List<Activity> _parseFrom({
    required String activityType,
    required List<Map<String, dynamic>> data,
  }) {
    final activities = <Activity>[];
    for (final activity in data) {
      if (activityType == 'dungeons') {
        activities.add(Activity.dungeon(activity));
      } else if (activityType == 'raids') {
        activities.add(Activity.raid(activity));
      } else if (activityType == 'custom') {
        activities.add(Activity.custom(activity));
      } else {
        throw Exception('Unknown activity type: $activityType');
      }
    }

    return activities;
  }
}
