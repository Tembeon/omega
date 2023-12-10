import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'posts.g.dart';

/// `PostsTable` is a class that extends the `Table` class provided by the `drift` package.
/// It represents the structure of the `Posts` table in the database.
class PostsTable extends Table {
  /// An integer column named `id`. This is the primary key of the table and it auto increments.
  IntColumn get id => integer().autoIncrement()();

  /// A integer column named `postMessageId`. This stores the messageID of the post.
  IntColumn get postMessageId => integer()();

  /// A text column named `title`. This stores the title of the post.
  TextColumn get title => text()();

  /// A text column named `description`. This stores the description of the post.
  TextColumn get description => text()();

  /// A integer column named `author`. This stores the author of the post.
  IntColumn get author => integer()();

  /// A integer column named `maxMembers`. This stores the max members of the post.
  IntColumn get maxMembers => integer().check(maxMembers.isBiggerThan(const Constant(0)))();

  /// A DateTime column named `date`. This stores the start date of the post.
  DateTimeColumn get date => dateTime().check(date.isBiggerThan(currentDateAndTime))();

  /// A DateTime column named `createdAt`. This stores the creation date of the post.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// A bool column named `isDeleted`. This stores the deletion status of the post.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class MembersTable extends Table {
  /// An integer column named `id`. This is the primary key of the table and it auto increments.
  IntColumn get id => integer().autoIncrement()();

  /// A text column named `member`. This stores the userID of the member.
  IntColumn get member => integer()();

  /// A text column named `post`. This stores the post related to the member.
  IntColumn get post => integer().references(PostsTable, #postMessageId, onDelete: KeyAction.cascade)();
}

@DriftDatabase(tables: [PostsTable, MembersTable])
class PostsDatabase extends _$PostsDatabase {
  PostsDatabase._internal() : super(_openConnection());

  static final PostsDatabase _instance = PostsDatabase._internal();

  factory PostsDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Inserts a [UserEvent] into the database.
  ///
  /// Returns the id of the inserted row.
  Future<int> insertPost(PostsTableCompanion post) => into(postsTable).insert(post);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File('data/db/posts.sqlite');

    return NativeDatabase.createInBackground(file);
  });
}
