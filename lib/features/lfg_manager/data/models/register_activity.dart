import 'package:nyxx/nyxx.dart' show Snowflake;

import '../../../../core/data/models/activity.dart';

/// Interface for model used for build new LFG post.
abstract class ILFGPostBuilder implements Activity {
  const ILFGPostBuilder();

  /// Author of the post.
  ///
  /// This is the user who created the post, and first member of the LFG.
  Snowflake get authorID;

  /// User-given description of the post.
  String get description;

  /// User-given start date of the post.
  int get unixDate;
}

/// Interface for model used for LFG post.
///
/// Contains all data for LFG post.
abstract class ILFGPost implements ILFGPostBuilder {
  const ILFGPost();

  /// ID of the post in database.
  int get id;

  /// Members of the LFG post.
  List<Snowflake> get members;

  /// Message ID of the post.
  Snowflake get messageID;
}

/// Model used for creating LFG post.
base class LFGPostBuilder implements ILFGPostBuilder {
  /// Creates new LFG post builder.
  ///
  /// You may prefer to use [LFGPostBuilder.fromActivity] instead.
  const LFGPostBuilder({
    required this.authorID,
    required this.description,
    required this.unixDate,
    required this.bannerUrl,
    required this.name,
    required this.maxMembers,
    this.enabled = true,
  });

  /// Creates new LFG post builder using data from [Activity].
  factory LFGPostBuilder.fromActivity({
    required Activity activity,
    required Snowflake authorID,
    required String description,
    required int unixDate,
  }) {
    return LFGPostBuilder(
      authorID: authorID,
      description: description,
      unixDate: unixDate,
      bannerUrl: activity.bannerUrl,
      name: activity.name,
      maxMembers: activity.maxMembers,
    );
  }

  /// Author of the post.
  ///
  /// This is the user who created the post, and first member of the LFG.
  final Snowflake authorID;

  /// User-given description of the LFG.
  final String description;

  /// User-given start date of the LFG.
  final int unixDate;

  /// Image url for LFG.
  ///
  /// Should be provided from [Activity].
  final String bannerUrl;

  /// Is LFG enabled. At this moment it's always true.
  ///
  /// If passed false, then bot will refuse to create LFG.
  final bool enabled;

  /// Name of the LFG.
  ///
  /// Should be provided from [Activity].
  final String name;

  /// Max members for LFG.
  ///
  /// Should be provided from [Activity].
  final int maxMembers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LFGPostBuilder &&
          authorID == other.authorID &&
          description == other.description &&
          unixDate == other.unixDate &&
          bannerUrl == other.bannerUrl &&
          enabled == other.enabled &&
          name == other.name &&
          maxMembers == other.maxMembers;

  @override
  int get hashCode =>
      authorID.hashCode ^
      description.hashCode ^
      unixDate.hashCode ^
      bannerUrl.hashCode ^
      enabled.hashCode ^
      name.hashCode ^
      maxMembers.hashCode;

  /// Creates new instance of [LFGPostBuilder] with updated data.
  LFGPostBuilder copyWith({
    Snowflake? authorID,
    String? description,
    int? unixDate,
    String? bannerUrl,
    bool? enabled,
    String? name,
    int? maxMembers,
  }) {
    return LFGPostBuilder(
      authorID: authorID ?? this.authorID,
      description: description ?? this.description,
      unixDate: unixDate ?? this.unixDate,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      enabled: enabled ?? this.enabled,
      name: name ?? this.name,
      maxMembers: maxMembers ?? this.maxMembers,
    );
  }
}
