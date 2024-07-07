import 'dart:convert';
import 'dart:io';

import '../../const/exceptions.dart';
import '../../data/models/activity.dart';

@Deprecated('Migrate to settings in SQL')
abstract final class ActivityData {
  @Deprecated('Migrate to settings in SQL')

  /// Loads activities from file.
  factory ActivityData.fromFiles({
    required String raidsPath,
    required String dungeonsPath,
    required String customsPath,
  }) {
    return _ActivityDataLoader(
      dungeons: _loadDataFromFile(File(dungeonsPath)).map(Activity.dungeon).toList(),
      raids: _loadDataFromFile(File(raidsPath)).map(Activity.raid).toList(),
      customs: _loadDataFromFile(File(customsPath)).map(Activity.custom).toList(),
    );
  }

  /// Returns all activities.
  List<Activity> get activities;

  /// Returns all dungeons activities.
  List<Activity> get dungeons;

  /// Returns all raids activities.
  List<Activity> get raids;

  /// Returns all custom activities.
  List<Activity> get customs;

  /// Returns activity by name.
  Activity get(String name);

  static List<Map<String, Object?>> _loadDataFromFile(File file) {
    if (!file.existsSync()) {
      throw ConfigFileMissing('activities', configPath: file.path);
    }

    final data = jsonDecode(file.readAsStringSync()) as List<Object?>;
    return data.map((e) => e! as Map<String, Object?>).toList();
  }
}

final class _ActivityDataLoader implements ActivityData {
  const _ActivityDataLoader({
    required List<Activity> dungeons,
    required List<Activity> raids,
    required List<Activity> customs,
  })  : _dungeons = dungeons,
        _raids = raids,
        _customs = customs;

  final List<Activity> _dungeons;
  final List<Activity> _raids;
  final List<Activity> _customs;

  @override
  List<Activity> get activities => [
        ..._dungeons,
        ..._raids,
        ..._customs,
      ];

  @override
  List<Activity> get customs => _customs;

  @override
  List<Activity> get dungeons => _dungeons;

  @override
  List<Activity> get raids => _raids;

  @override
  Activity get(String name) => activities.firstWhere((e) => e.name == name);
}
