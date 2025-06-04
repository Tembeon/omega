import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';

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
  tables: [KeyedSettingsTable, TimezonesTable, ActivitiesTable, ActivitiesRolesTable, RolesTable, PromoteMessagesTable],
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

PgDatabase _openConnection() {
  final host = Platform.environment['POSTGRES_HOST'] ?? 'localhost';
  final port = int.parse(Platform.environment['POSTGRES_PORT'] ?? '5432');
  final user = Platform.environment['POSTGRES_USER'] ?? 'omega';
  final password = Platform.environment['POSTGRES_PASSWORD'] ?? 'omega';
  final db = Platform.environment['POSTGRES_DB'] ?? 'omega';

  return PgDatabase(
    endpoint: Endpoint(
      host: host,
      port: port,
      database: db,
      username: user,
      password: password,
    ),
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
}
