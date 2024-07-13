import '../../core/data/models/activity_data.dart';
import '../../core/utils/database/settings/db.dart';
import '../interactor/interactor.dart';
import '../interactor/interactor_component.dart';

class Settings {
  const Settings({
    required SettingsDatabase database,
    required Interactor interactor,
  })  : _database = database,
        _interactor = interactor;

  static const String lfgChannelKey = 'lfg_channel';
  static const String promotesChannelKey = 'promotes_channel';

  /// Database used for storing settings.
  final SettingsDatabase _database;

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
      return;
    }

    await _database.guildSettingsDao.saveValue(lfgChannelKey, channelID.toString());
  }

  Future<void> updatePromotesChannel(int? channelID) async {
    if (channelID == null) {
      await _database.guildSettingsDao.removeValue(promotesChannelKey);
      return;
    }

    await _database.guildSettingsDao.saveValue(promotesChannelKey, channelID.toString());
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
}
