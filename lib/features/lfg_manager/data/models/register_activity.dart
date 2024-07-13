import 'package:nyxx/nyxx.dart' show Snowflake;

import '../../../../core/data/models/activity_data.dart';

/// Class for creating LFG post.
///
/// All data provided from user input.
base class LFGPostBuilder extends ActivityData {
  const LFGPostBuilder({
    required super.name,
    required super.maxMembers,
    required super.bannerUrl,
    required super.roles,
    required super.enabled,
    required this.description,
    required this.unixDate,
    required this.authorID,
    required this.timezone,
  });

  factory LFGPostBuilder.fromActivity({
    required ActivityData activity,
    required Snowflake authorID,
    required String description,
    required int unixDate,
    required int timezone,
  }) =>
      LFGPostBuilder(
        authorID: authorID,
        description: description,
        unixDate: unixDate,
        timezone: timezone,
        bannerUrl: activity.bannerUrl,
        name: activity.name,
        maxMembers: activity.maxMembers,
        enabled: activity.enabled,
        roles: activity.roles,
      );

  /// User-defined description of LFG post.
  final String description;

  /// Unix date of LFG post.
  ///
  /// Generated from user input.
  final int unixDate;

  /// ID of the author of LFG post.
  final Snowflake authorID;

  /// User-defined timezone of LFG post.
  final int timezone;
}
