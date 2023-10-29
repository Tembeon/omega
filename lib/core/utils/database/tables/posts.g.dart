// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts.dart';

// ignore_for_file: type=lint
class $PostsTableTable extends PostsTable with TableInfo<$PostsTableTable, PostsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title =
      GeneratedColumn<String>('title', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description =
      GeneratedColumn<String>('description', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author =
      GeneratedColumn<String>('author', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activityMeta = const VerificationMeta('activity');
  @override
  late final GeneratedColumn<String> activity =
      GeneratedColumn<String>('activity', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date =
      GeneratedColumn<DateTime>('date', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt =
      GeneratedColumn<String>('created_at', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt =
      GeneratedColumn<String>('updated_at', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _membersMeta = const VerificationMeta('members');
  @override
  late final GeneratedColumn<String> members =
      GeneratedColumn<String>('members', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, description, author, activity, date, createdAt, updatedAt, members];
  @override
  String get aliasedName => _alias ?? 'posts_table';
  @override
  String get actualTableName => 'posts_table';
  @override
  VerificationContext validateIntegrity(Insertable<PostsTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta, author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('activity')) {
      context.handle(_activityMeta, activity.isAcceptableOrUnknown(data['activity']!, _activityMeta));
    } else if (isInserting) {
      context.missing(_activityMeta);
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('members')) {
      context.handle(_membersMeta, members.isAcceptableOrUnknown(data['members']!, _membersMeta));
    } else if (isInserting) {
      context.missing(_membersMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostsTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      author: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      activity: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}activity'])!,
      date: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      members: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}members'])!,
    );
  }

  @override
  $PostsTableTable createAlias(String alias) {
    return $PostsTableTable(attachedDatabase, alias);
  }
}

class PostsTableData extends DataClass implements Insertable<PostsTableData> {
  final int id;
  final String title;
  final String description;
  final String author;
  final String activity;
  final DateTime date;
  final String createdAt;
  final String updatedAt;
  final String members;
  const PostsTableData(
      {required this.id,
      required this.title,
      required this.description,
      required this.author,
      required this.activity,
      required this.date,
      required this.createdAt,
      required this.updatedAt,
      required this.members});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['author'] = Variable<String>(author);
    map['activity'] = Variable<String>(activity);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['members'] = Variable<String>(members);
    return map;
  }

  PostsTableCompanion toCompanion(bool nullToAbsent) {
    return PostsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      author: Value(author),
      activity: Value(activity),
      date: Value(date),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      members: Value(members),
    );
  }

  factory PostsTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostsTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      author: serializer.fromJson<String>(json['author']),
      activity: serializer.fromJson<String>(json['activity']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      members: serializer.fromJson<String>(json['members']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'author': serializer.toJson<String>(author),
      'activity': serializer.toJson<String>(activity),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'members': serializer.toJson<String>(members),
    };
  }

  PostsTableData copyWith(
          {int? id,
          String? title,
          String? description,
          String? author,
          String? activity,
          DateTime? date,
          String? createdAt,
          String? updatedAt,
          String? members}) =>
      PostsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        author: author ?? this.author,
        activity: activity ?? this.activity,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        members: members ?? this.members,
      );
  @override
  String toString() {
    return (StringBuffer('PostsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('author: $author, ')
          ..write('activity: $activity, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('members: $members')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, author, activity, date, createdAt, updatedAt, members);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.author == this.author &&
          other.activity == this.activity &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.members == this.members);
}

class PostsTableCompanion extends UpdateCompanion<PostsTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> author;
  final Value<String> activity;
  final Value<DateTime> date;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String> members;
  const PostsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.author = const Value.absent(),
    this.activity = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.members = const Value.absent(),
  });
  PostsTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required String author,
    required String activity,
    required DateTime date,
    required String createdAt,
    required String updatedAt,
    required String members,
  })  : title = Value(title),
        description = Value(description),
        author = Value(author),
        activity = Value(activity),
        date = Value(date),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        members = Value(members);
  static Insertable<PostsTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? author,
    Expression<String>? activity,
    Expression<DateTime>? date,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? members,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (author != null) 'author': author,
      if (activity != null) 'activity': activity,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (members != null) 'members': members,
    });
  }

  PostsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? author,
      Value<String>? activity,
      Value<DateTime>? date,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String>? members}) {
    return PostsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      activity: activity ?? this.activity,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      members: members ?? this.members,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(activity.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (members.present) {
      map['members'] = Variable<String>(members.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('author: $author, ')
          ..write('activity: $activity, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('members: $members')
          ..write(')'))
        .toString();
  }
}

abstract class _$PostsDatabase extends GeneratedDatabase {
  _$PostsDatabase(QueryExecutor e) : super(e);
  late final $PostsTableTable postsTable = $PostsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [postsTable];
}
