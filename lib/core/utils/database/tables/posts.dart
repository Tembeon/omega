import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'posts.g.dart';

/// `PostsTable` is a class that extends the `Table` class provided by the `drift` package.
/// It represents the structure of the `Posts` table in the database.
class PostsTable extends Table {
  /// An integer column named `id`. This is the primary key of the table and it auto increments.
  IntColumn get id => integer().autoIncrement()();

  /// A text column named `title`. This stores the title of the post.
  TextColumn get title => text()();

  /// A text column named `description`. This stores the description of the post.
  TextColumn get description => text()();

  /// A text column named `author`. This stores the author of the post.
  TextColumn get author => text()();

  /// A text column named `activity`. This stores the activity related to the post.
  TextColumn get activity => text()();

  /// A DateTime column named `date`. This stores the start date of the post.
  DateTimeColumn get date => dateTime().check(date.isBiggerThan(currentDateAndTime))();

  /// A text column named `createdAt`. This stores the creation time of the post.
  TextColumn get createdAt => text()();

  /// A text column named `updatedAt`. This stores the last update time of the post.
  TextColumn get updatedAt => text()();

  /// A text column named `members`. This stores the members related to the post.
  TextColumn get members => text()();
}

@DriftDatabase(tables: [PostsTable])
class PostsDatabase extends _$PostsDatabase {
  PostsDatabase._internal() : super(_openConnection());

  static final PostsDatabase _instance = PostsDatabase._internal();

  factory PostsDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  /// Inserts a [UserEvent] into the database.
  Future<void> insertPost(PostsTableCompanion post) => into(postsTable).insert(post);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File('data/db/posts.sqlite');

    return NativeDatabase.createInBackground(file);
  });
}
