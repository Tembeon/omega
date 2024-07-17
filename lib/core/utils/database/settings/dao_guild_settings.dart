import 'package:drift/drift.dart';

import 'db.dart';

part 'dao_guild_settings.g.dart';

/// Table that stores all settings in key-value format.
class KeyedSettingsTable extends Table {
  /// A text column named `key`. This stores the key of the setting.
  ///
  /// Example: `lfg_channel`, `promotes_channel`
  TextColumn get key => text().unique()();

  /// A integer column named `value`. This stores the value of the setting.
  ///
  /// Example: `1234567890`, `0987654321`
  TextColumn get value => text()();
}

/// Table that stores all timezones.
class TimezonesTable extends Table {
  /// A text column named `name`. This stores the name of the timezone.
  ///
  /// Example: `MSK`, `UTC`, `GMT+3`
  TextColumn get name => text().unique()();

  /// A integer column named `offset`. This stores the offset of the timezone.
  ///
  /// Example: `3`, `0`, `-3`
  IntColumn get offset => integer()();
}

/// Table that stores all messages that used to promote LFG posts.
class PromoteMessagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get message => text()();
}

/// {@template SettingsDatabase.GuildSettings}
///
/// DAO which provides access to [GuildSettingsTable] and [TimezonesTable].
///
/// {@endtemplate}
@DriftAccessor(tables: [KeyedSettingsTable, TimezonesTable, PromoteMessagesTable])
class GuildSettingsDao extends DatabaseAccessor<SettingsDatabase> with _$GuildSettingsDaoMixin {
  /// {@macro SettingsDatabase.GuildSettings}
  GuildSettingsDao(super.db);

  Future<String?> getValue(String key) {
    return (select(keyedSettingsTable)..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull()
        .then((value) => value?.value);
  }

  Future<int> saveValue(String key, String value) {
    return into(keyedSettingsTable).insert(
      KeyedSettingsTableCompanion.insert(
        key: key,
        value: value,
      ),
      mode: InsertMode.replace,
    );
  }

  Future<int> removeValue(String key) {
    return (delete(keyedSettingsTable)..where((tbl) => tbl.key.equals(key))).go();
  }

  Future<List<TimezonesTableData>> getTimezones() {
    return select(timezonesTable).get();
  }

  /// Adds a new timezone to the database.
  Future<int> addTimezone(String name, int offset) {
    return into(timezonesTable).insert(
      TimezonesTableCompanion.insert(
        name: name,
        offset: offset,
      ),
    );
  }

  /// Removes a timezone from the database.
  Future<int> removeTimezone(String name) {
    return (delete(timezonesTable)..where((tbl) => tbl.name.equals(name))).go();
  }

  Future<int> addPromoteMessage(String message) {
    return into(promoteMessagesTable).insert(
      PromoteMessagesTableCompanion.insert(
        message: message,
      ),
    );
  }

  Future<List<PromoteMessagesTableData>> getPromoteMessages() {
    return select(promoteMessagesTable).get();
  }

  Future<int> removePromoteMessage(int id) {
    return (delete(promoteMessagesTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}
