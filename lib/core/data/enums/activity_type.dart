/// Enum for activity types.
enum LFGType {
  /// Custom activity, stored in `/activities/custom.json` file.
  ///
  /// It can be anything, like "farming", "pvp", etc. All parameters are set by user.
  ///
  /// Main difference from others is that it has variable number of members.
  ///
  /// See [Activity.custom] for more info.
  ///
  /// All custom activities registers in `/create activity` command.
  activity,

  /// Dungeon activity, stored in `/activities/dungeons.json` file.
  ///
  /// Main difference from [LFGType.activity] is that it has fixed number of members: 3.
  ///
  /// See [Activity.dungeon] for more info.
  ///
  /// All dungeon activities registers in `/create dungeon` command.
  dungeon,

  /// Raid activity, stored in `/activities/raids.json` file.
  ///
  /// Main difference from [LFGType.activity] is that it has fixed number of members: 6.
  ///
  /// See [Activity.raid] for more info.
  ///
  /// All raid activities registers in `/create raid` command.
  raid,
}
