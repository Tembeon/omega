import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'posts.g.dart';

class PostsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get author => text()();
  TextColumn get activity => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
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
    final file = File('data/posts.sqlite');

    return NativeDatabase.createInBackground(file);
  });
}
