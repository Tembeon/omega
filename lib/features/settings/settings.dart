import 'dart:io';

import 'package:collection/collection.dart';
import 'package:l/l.dart';

import '../../core/data/models/activity_data.dart';
import '../../core/utils/database/settings/db.dart';
import '../../core/utils/database/tables/posts.dart';
import '../interactor/interactor.dart';
import '../interactor/interactor_component.dart';

class Settings {
  const Settings({
    required SettingsDatabase database,
    required Interactor interactor,
    required PostsDatabase postsDatabase,
  })  : _database = database,
        _interactor = interactor,
        _postsDatabase = postsDatabase;

  static const String lfgChannelKey = 'lfg_channel';
  static const String promotesChannelKey = 'promotes_channel';

  /// Database used for storing settings.
  final SettingsDatabase _database;

  final PostsDatabase _postsDatabase;

  /// Interactor for notifying about settings changes.
  final Interactor _interactor;

  Future<Map<String, int>> getTimezones() async {
    final timezones = await _database.guildSettingsDao.getTimezones();
    return {for (final timezone in timezones) timezone.name: timezone.offset};
  }

  Future<void> addTimezone(String name, int offset) async {
    await _database.guildSettingsDao.addTimezone(name, offset);
    _interactor.notifyUpdate({
      UpdateEvent.timezonesUpdated,
    });
  }

  Future<void> removeTimezone(String name) async {
    await _database.guildSettingsDao.removeTimezone(name);
    _interactor.notifyUpdate({
      UpdateEvent.timezonesUpdated,
    });
  }

  Future<int?> getPromotesChannel() async {
    final value = await _database.guildSettingsDao.getValue(promotesChannelKey);
    return value != null ? int.parse(value) : null;
  }

  Future<int?> getLFGChannel() async {
    final value = await _database.guildSettingsDao.getValue(lfgChannelKey);
    return value != null ? int.parse(value) : null;
  }

  Future<void> updateLFGChannel(int? channelID) async {
    if (channelID == null) {
      await _database.guildSettingsDao.removeValue(lfgChannelKey);
    } else {
      await _database.guildSettingsDao.saveValue(lfgChannelKey, channelID.toString());
    }

    _interactor.notifyUpdate({
      UpdateEvent.lfgChannelUpdated,
    });
  }

  Future<void> updatePromotesChannel(int? channelID) async {
    if (channelID == null) {
      await _database.guildSettingsDao.removeValue(promotesChannelKey);
    } else {
      await _database.guildSettingsDao.saveValue(promotesChannelKey, channelID.toString());
    }

    _interactor.notifyUpdate({
      UpdateEvent.promoChannelUpdated,
    });
  }

  Future<List<String>> getActivitiesNames() async {
    final activities = await _database.activitiesDao.getActivities();
    return activities.map((e) => e.name).toList();
  }

  Future<List<ActivityData>> getActivities() async {
    final List<ActivityData> activitiesData = [];
    final activities = await _database.activitiesDao.getActivities();
    for (final activity in activities) {
      final roles = await _database.activitiesDao.getRolesForActivity(activity.name);
      activitiesData.add(ActivityData.fromDatabase(activity: activity, roles: roles.isEmpty ? null : roles));
    }

    return activitiesData;
  }

  Future<ActivityData> getActivity(String name) async {
    final activity = await _database.activitiesDao.getActivity(name);
    final roles = await _database.activitiesDao.getRolesForActivity(name);
    return ActivityData.fromDatabase(activity: activity, roles: roles.isEmpty ? null : roles);
  }

  Future<void> addActivity(ActivityData activity) async {
    await _database.activitiesDao.addActivity(
      activity.name,
      activity.maxMembers,
      bannerUrl: activity.bannerUrl,
    );

    if (activity.roles != null) {
      for (final role in activity.roles!) {
        await _database.activitiesDao.addRoleToActivity(activity.name, role.role, role.quantity);
      }
    }

    _interactor.notifyUpdate({
      UpdateEvent.activitiesUpdated,
    });
  }

  Future<void> removeActivity(String name) async {
    final activity = await _database.activitiesDao.getActivity(name);
    await _database.activitiesDao.removeActivity(name);
    _interactor.notifyUpdate({
      UpdateEvent.activitiesUpdated,
    });

    final banner = activity.bannerUrl;
    if (banner != null && !Uri.parse(banner).isScheme('https')) {
      final file = File(banner);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
  }

  Future<void> addRoleToActivity(String activity, String role, int quantity) async {
    await _database.activitiesDao.addRoleToActivity(activity, role, quantity);
    _interactor.notifyUpdate({
      UpdateEvent.activitiesUpdated,
    });
  }

  Future<void> removeRoleFromActivity(String activity, String role) async {
    await _database.activitiesDao.removeRoleFromActivity(activity, role);
    _interactor.notifyUpdate({
      UpdateEvent.activitiesUpdated,
    });
  }

  Future<Map<int, String>> getPromoteMessages() async {
    final messages = await _database.guildSettingsDao.getPromoteMessages();
    return {for (final message in messages) message.id: message.message};
  }

  /// Same as [getPromoteMessages], but returns as many messages as they have weight.
  Future<List<String>> getPromoteMessagesWithWeight() async {
    final messages = await _database.guildSettingsDao.getPromoteMessages();
    final List<String> result = [];
    for (final message in messages) {
      for (var i = 0; i < message.weight; i++) {
        result.add(message.message);
      }
    }

    return result;
  }

  Future<void> addPromoteMessage(String message, int weight) {
    return _database.guildSettingsDao.addPromoteMessage(message, weight);
  }

  Future<void> removePromoteMessage(int id) {
    return _database.guildSettingsDao.removePromoteMessage(id);
  }

  Future<List<String>> getAllRoles() async {
    return (await _database.activitiesDao.getRoles())
        .map(
          (e) => e.name,
        )
        .toList(growable: false);
  }

  Future<void> addRole(String role) {
    return _database.activitiesDao.addRole(role);
  }

  Future<void> removeRole(String role) {
    return _database.activitiesDao.removeRole(role);
  }

  /// Returns the number of free roles for given activity
  Future<int> getFreeRoleCount({
    required int id,
    required String role,
  }) async {
    final db = Services.i.postsDatabase;
    final post = await db.findPost(id);

    if (post == null) {
      return -1;
    }
    // // activity with raw data
    final activityData = await getActivity(post!.title);
    //
    // // all roles in this activity
    // final roles = activityData.roles ?? [];

    // get all taken roles
    final takenRoles = await _postsDatabase.getAllTakenRoles(activity: activityData, id: id);

    l.d('Taken roles: $takenRoles');

    final taken = takenRoles.firstWhereOrNull((element) => element.role == role);
    return taken == null ? 0 : taken.total - taken.taken;
  }
}
