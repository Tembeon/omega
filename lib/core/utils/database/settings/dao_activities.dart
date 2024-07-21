// ignore reason: this is how columns are defined in drift
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import 'db.dart';

part 'dao_activities.g.dart';

/// Database which stores all activities created by administrators.
class ActivitiesTable extends Table {
  /// Visible name of the activity. Should be unique.
  TextColumn get name => text().unique()();

  /// Maximum amount of members that can join the activity.
  IntColumn get maxMembers => integer().check(maxMembers.isBiggerThan(const Constant(1)))();

  /// Uri to the banner image of the activity.
  TextColumn get bannerUrl => text().nullable()();

  /// Whether the activity is enabled or not.
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}

/// Table that represents the many-to-many relationship between [ActivitiesTable] and [RolesTable].
class ActivitiesRolesTable extends Table {
  /// Name of the activity that the role is assigned to.
  TextColumn get activity => text().references(
        ActivitiesTable,
        #name,
        onDelete: KeyAction.cascade,
      )();

  /// Name of the role that is assigned to the activity.
  TextColumn get role => text().references(
        RolesTable,
        #name,
        onDelete: KeyAction.cascade,
      )();

  /// How much of this role needs to be assigned to the activity.
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}

/// Table that represents the roles that can be assigned to an activity.
class RolesTable extends Table {
  /// Name of the role. Should be unique.
  TextColumn get name => text().unique()();
}

@DriftAccessor(tables: [ActivitiesTable, ActivitiesRolesTable, RolesTable])
class ActivitiesDao extends DatabaseAccessor<SettingsDatabase> with _$ActivitiesDaoMixin {
  ActivitiesDao(super.db);

  /// Adds a new activity to the database.
  Future<int> addActivity(String name, int maxMembers, {String? bannerUrl}) {
    return into(activitiesTable).insert(
      ActivitiesTableCompanion.insert(
        name: name,
        maxMembers: maxMembers,
        bannerUrl: Value(bannerUrl),
      ),
    );
  }

  /// Removes an activity from the database.
  Future<int> removeActivity(String name) {
    return (delete(activitiesTable)..where((tbl) => tbl.name.equals(name))).go();
  }

  /// Adds a new role to the database for an activity.
  Future<int> addRoleToActivity(String activity, String role, int quantity) {
    return into(activitiesRolesTable).insert(
      ActivitiesRolesTableCompanion.insert(
        activity: activity,
        role: role,
        quantity: Value(quantity),
      ),
    );
  }

  /// Removes a role from an activity.
  Future<int> removeRoleFromActivity(String activity, String role) {
    return (delete(activitiesRolesTable)..where((tbl) => tbl.activity.equals(activity) & tbl.role.equals(role))).go();
  }

  /// Returns all activities stored in the database.
  ///
  /// If [includeDisabled] is set to `true`, disabled activities will also be returned.
  Future<List<ActivitiesTableData>> getActivities({bool includeDisabled = false}) {
    return (select(activitiesTable)..where((tbl) => includeDisabled ? const Constant(true) : tbl.enabled.equals(true)))
        .get();
  }

  /// Returns a single activity by its name.
  Future<ActivitiesTableData> getActivity(String name) {
    return (select(activitiesTable)..where((tbl) => tbl.name.equals(name))).getSingle();
  }

  /// Returns all roles assigned to an activity.
  Future<List<ActivitiesRolesTableData>> getRolesForActivity(String activity) {
    return (select(activitiesRolesTable)..where((tbl) => tbl.activity.equals(activity))).get();
  }

  /// Returns all roles from table
  Future<List<RolesTableData>> getRoles() {
    return select(rolesTable).get();
  }

  /// Adds role to table
  Future<int> addRole(String name) {
    return into(rolesTable).insert(RolesTableCompanion.insert(name: name));
  }

  /// Removes role from table
  Future<int> removeRole(String name) {
    return (delete(rolesTable)..where((tbl) => tbl.name.equals(name))).go();
  }
}
