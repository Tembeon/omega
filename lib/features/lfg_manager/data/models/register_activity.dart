import 'package:nyxx/nyxx.dart' show Snowflake;

import '../../../../core/data/models/activity_data.dart';

/// Class for creating LFG post.
///
/// All data provided from user input.
base class LFGPostBuilder {
  const LFGPostBuilder({
    required this.activity,
    required this.description,
    required this.unixDate,
    required this.authorID,
    required this.timezone,
  });

  /// Source activity data.
  final ActivityData activity;

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
