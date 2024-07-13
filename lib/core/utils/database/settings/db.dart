import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'dao_activities.dart';
import 'dao_guild_settings.dart';

part 'db.g.dart';

/// {@template SettingsDatabase}
///
/// Database which stores all runtime settings.
///
/// This settings can be changed by administrators.
///
/// See DAOs for more information.
///
/// {@endtemplate}
@DriftDatabase(
  tables: [KeyedSettingsTable, TimezonesTable, ActivitiesTable, ActivitiesRolesTable, RolesTable],
  daos: [ActivitiesDao, GuildSettingsDao],
)
class SettingsDatabase extends _$SettingsDatabase {
  SettingsDatabase._internal() : super(_openConnection());

  /// {@macro SettingsDatabase}
  ///
  /// This is a singleton class.
  factory SettingsDatabase() => _instance;

  static final SettingsDatabase _instance = SettingsDatabase._internal();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          if (details.wasCreated) await _setInitialData();
        },
      );

  Future<void> _setInitialData() async {
    await batch((batch) async {
      batch
        ..insertAll(timezonesTable, [
          TimezonesTableCompanion.insert(name: 'UTC', offset: 0),
          TimezonesTableCompanion.insert(name: 'UTC+1', offset: 1),
          TimezonesTableCompanion.insert(name: 'UTC+2', offset: 2),
          TimezonesTableCompanion.insert(name: 'UTC+3', offset: 3),
          TimezonesTableCompanion.insert(name: 'UTC+4', offset: 4),
        ])
        ..insertAll(activitiesTable, [
          ActivitiesTableCompanion.insert(name: 'Raid', maxMembers: 6),
          ActivitiesTableCompanion.insert(name: 'Dungeon', maxMembers: 4),
        ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File('data/db/settings.sqlite');

    return NativeDatabase.createInBackground(file);
  });
}
