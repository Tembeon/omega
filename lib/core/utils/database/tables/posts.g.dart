// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts.dart';

// ignore_for_file: type=lint
class $PostsTableTable extends PostsTable
    with TableInfo<$PostsTableTable, PostsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _postMessageIdMeta =
      const VerificationMeta('postMessageId');
  @override
  late final GeneratedColumn<int> postMessageId = GeneratedColumn<int>(
      'post_message_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<int> author = GeneratedColumn<int>(
      'author', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maxMembersMeta =
      const VerificationMeta('maxMembers');
  @override
  late final GeneratedColumn<int> maxMembers = GeneratedColumn<int>(
      'max_members', aliasedName, false,
      check: () => maxMembers.isBiggerThan(const Constant(0)),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      check: () => date.isBiggerThan(currentDateAndTime),
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        postMessageId,
        title,
        description,
        author,
        maxMembers,
        date,
        createdAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts_table';
  @override
  VerificationContext validateIntegrity(Insertable<PostsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_message_id')) {
      context.handle(
          _postMessageIdMeta,
          postMessageId.isAcceptableOrUnknown(
              data['post_message_id']!, _postMessageIdMeta));
    } else if (isInserting) {
      context.missing(_postMessageIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('max_members')) {
      context.handle(
          _maxMembersMeta,
          maxMembers.isAcceptableOrUnknown(
              data['max_members']!, _maxMembersMeta));
    } else if (isInserting) {
      context.missing(_maxMembersMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      postMessageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}post_message_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}author'])!,
      maxMembers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_members'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $PostsTableTable createAlias(String alias) {
    return $PostsTableTable(attachedDatabase, alias);
  }
}

class PostsTableData extends DataClass implements Insertable<PostsTableData> {
  /// An integer column named `id`. This is the primary key of the table and it auto increments.
  final int id;

  /// A integer column named `postMessageId`. This stores the messageID of the post.
  final int postMessageId;

  /// A text column named `title`. This stores the title of the post.
  final String title;

  /// A text column named `description`. This stores the description of the post.
  final String description;

  /// A integer column named `author`. This stores the author of the post.
  final int author;

  /// A integer column named `maxMembers`. This stores the max members of the post.
  final int maxMembers;

  /// A DateTime column named `date`. This stores the start date of the post.
  final DateTime date;

  /// A DateTime column named `createdAt`. This stores the creation date of the post.
  final DateTime createdAt;

  /// A bool column named `isDeleted`. This stores the deletion status of the post.
  final bool isDeleted;
  const PostsTableData(
      {required this.id,
      required this.postMessageId,
      required this.title,
      required this.description,
      required this.author,
      required this.maxMembers,
      required this.date,
      required this.createdAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['post_message_id'] = Variable<int>(postMessageId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['author'] = Variable<int>(author);
    map['max_members'] = Variable<int>(maxMembers);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  PostsTableCompanion toCompanion(bool nullToAbsent) {
    return PostsTableCompanion(
      id: Value(id),
      postMessageId: Value(postMessageId),
      title: Value(title),
      description: Value(description),
      author: Value(author),
      maxMembers: Value(maxMembers),
      date: Value(date),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory PostsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostsTableData(
      id: serializer.fromJson<int>(json['id']),
      postMessageId: serializer.fromJson<int>(json['postMessageId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      author: serializer.fromJson<int>(json['author']),
      maxMembers: serializer.fromJson<int>(json['maxMembers']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'postMessageId': serializer.toJson<int>(postMessageId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'author': serializer.toJson<int>(author),
      'maxMembers': serializer.toJson<int>(maxMembers),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  PostsTableData copyWith(
          {int? id,
          int? postMessageId,
          String? title,
          String? description,
          int? author,
          int? maxMembers,
          DateTime? date,
          DateTime? createdAt,
          bool? isDeleted}) =>
      PostsTableData(
        id: id ?? this.id,
        postMessageId: postMessageId ?? this.postMessageId,
        title: title ?? this.title,
        description: description ?? this.description,
        author: author ?? this.author,
        maxMembers: maxMembers ?? this.maxMembers,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  @override
  String toString() {
    return (StringBuffer('PostsTableData(')
          ..write('id: $id, ')
          ..write('postMessageId: $postMessageId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('author: $author, ')
          ..write('maxMembers: $maxMembers, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, postMessageId, title, description, author,
      maxMembers, date, createdAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostsTableData &&
          other.id == this.id &&
          other.postMessageId == this.postMessageId &&
          other.title == this.title &&
          other.description == this.description &&
          other.author == this.author &&
          other.maxMembers == this.maxMembers &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted);
}

class PostsTableCompanion extends UpdateCompanion<PostsTableData> {
  final Value<int> id;
  final Value<int> postMessageId;
  final Value<String> title;
  final Value<String> description;
  final Value<int> author;
  final Value<int> maxMembers;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  const PostsTableCompanion({
    this.id = const Value.absent(),
    this.postMessageId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.author = const Value.absent(),
    this.maxMembers = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PostsTableCompanion.insert({
    this.id = const Value.absent(),
    required int postMessageId,
    required String title,
    required String description,
    required int author,
    required int maxMembers,
    required DateTime date,
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : postMessageId = Value(postMessageId),
        title = Value(title),
        description = Value(description),
        author = Value(author),
        maxMembers = Value(maxMembers),
        date = Value(date);
  static Insertable<PostsTableData> custom({
    Expression<int>? id,
    Expression<int>? postMessageId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? author,
    Expression<int>? maxMembers,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postMessageId != null) 'post_message_id': postMessageId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (author != null) 'author': author,
      if (maxMembers != null) 'max_members': maxMembers,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PostsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? postMessageId,
      Value<String>? title,
      Value<String>? description,
      Value<int>? author,
      Value<int>? maxMembers,
      Value<DateTime>? date,
      Value<DateTime>? createdAt,
      Value<bool>? isDeleted}) {
    return PostsTableCompanion(
      id: id ?? this.id,
      postMessageId: postMessageId ?? this.postMessageId,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      maxMembers: maxMembers ?? this.maxMembers,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (postMessageId.present) {
      map['post_message_id'] = Variable<int>(postMessageId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (author.present) {
      map['author'] = Variable<int>(author.value);
    }
    if (maxMembers.present) {
      map['max_members'] = Variable<int>(maxMembers.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsTableCompanion(')
          ..write('id: $id, ')
          ..write('postMessageId: $postMessageId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('author: $author, ')
          ..write('maxMembers: $maxMembers, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $MembersTableTable extends MembersTable
    with TableInfo<$MembersTableTable, MembersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _memberMeta = const VerificationMeta('member');
  @override
  late final GeneratedColumn<int> member = GeneratedColumn<int>(
      'member', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _postMeta = const VerificationMeta('post');
  @override
  late final GeneratedColumn<int> post = GeneratedColumn<int>(
      'post', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES posts_table (post_message_id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, member, post];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members_table';
  @override
  VerificationContext validateIntegrity(Insertable<MembersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('member')) {
      context.handle(_memberMeta,
          member.isAcceptableOrUnknown(data['member']!, _memberMeta));
    } else if (isInserting) {
      context.missing(_memberMeta);
    }
    if (data.containsKey('post')) {
      context.handle(
          _postMeta, post.isAcceptableOrUnknown(data['post']!, _postMeta));
    } else if (isInserting) {
      context.missing(_postMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MembersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MembersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      member: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member'])!,
      post: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}post'])!,
    );
  }

  @override
  $MembersTableTable createAlias(String alias) {
    return $MembersTableTable(attachedDatabase, alias);
  }
}

class MembersTableData extends DataClass
    implements Insertable<MembersTableData> {
  /// An integer column named `id`. This is the primary key of the table and it auto increments.
  final int id;

  /// A text column named `member`. This stores the userID of the member.
  final int member;

  /// A text column named `post`. This stores the post related to the member.
  final int post;
  const MembersTableData(
      {required this.id, required this.member, required this.post});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['member'] = Variable<int>(member);
    map['post'] = Variable<int>(post);
    return map;
  }

  MembersTableCompanion toCompanion(bool nullToAbsent) {
    return MembersTableCompanion(
      id: Value(id),
      member: Value(member),
      post: Value(post),
    );
  }

  factory MembersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MembersTableData(
      id: serializer.fromJson<int>(json['id']),
      member: serializer.fromJson<int>(json['member']),
      post: serializer.fromJson<int>(json['post']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'member': serializer.toJson<int>(member),
      'post': serializer.toJson<int>(post),
    };
  }

  MembersTableData copyWith({int? id, int? member, int? post}) =>
      MembersTableData(
        id: id ?? this.id,
        member: member ?? this.member,
        post: post ?? this.post,
      );
  @override
  String toString() {
    return (StringBuffer('MembersTableData(')
          ..write('id: $id, ')
          ..write('member: $member, ')
          ..write('post: $post')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, member, post);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MembersTableData &&
          other.id == this.id &&
          other.member == this.member &&
          other.post == this.post);
}

class MembersTableCompanion extends UpdateCompanion<MembersTableData> {
  final Value<int> id;
  final Value<int> member;
  final Value<int> post;
  const MembersTableCompanion({
    this.id = const Value.absent(),
    this.member = const Value.absent(),
    this.post = const Value.absent(),
  });
  MembersTableCompanion.insert({
    this.id = const Value.absent(),
    required int member,
    required int post,
  })  : member = Value(member),
        post = Value(post);
  static Insertable<MembersTableData> custom({
    Expression<int>? id,
    Expression<int>? member,
    Expression<int>? post,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (member != null) 'member': member,
      if (post != null) 'post': post,
    });
  }

  MembersTableCompanion copyWith(
      {Value<int>? id, Value<int>? member, Value<int>? post}) {
    return MembersTableCompanion(
      id: id ?? this.id,
      member: member ?? this.member,
      post: post ?? this.post,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (member.present) {
      map['member'] = Variable<int>(member.value);
    }
    if (post.present) {
      map['post'] = Variable<int>(post.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersTableCompanion(')
          ..write('id: $id, ')
          ..write('member: $member, ')
          ..write('post: $post')
          ..write(')'))
        .toString();
  }
}

abstract class _$PostsDatabase extends GeneratedDatabase {
  _$PostsDatabase(QueryExecutor e) : super(e);
  late final $PostsTableTable postsTable = $PostsTableTable(this);
  late final $MembersTableTable membersTable = $MembersTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [postsTable, membersTable];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('posts_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('members_table', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
