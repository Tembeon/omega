// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $KeyedSettingsTableTable extends KeyedSettingsTable
    with TableInfo<$KeyedSettingsTableTable, KeyedSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyedSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keyed_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<KeyedSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  KeyedSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyedSettingsTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $KeyedSettingsTableTable createAlias(String alias) {
    return $KeyedSettingsTableTable(attachedDatabase, alias);
  }
}

class KeyedSettingsTableData extends DataClass
    implements Insertable<KeyedSettingsTableData> {
  /// A text column named `key`. This stores the key of the setting.
  ///
  /// Example: `lfg_channel`, `promotes_channel`
  final String key;

  /// A integer column named `value`. This stores the value of the setting.
  ///
  /// Example: `1234567890`, `0987654321`
  final String value;
  const KeyedSettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyedSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return KeyedSettingsTableCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory KeyedSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyedSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KeyedSettingsTableData copyWith({String? key, String? value}) =>
      KeyedSettingsTableData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('KeyedSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyedSettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class KeyedSettingsTableCompanion
    extends UpdateCompanion<KeyedSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyedSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyedSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<KeyedSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyedSettingsTableCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return KeyedSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyedSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimezonesTableTable extends TimezonesTable
    with TableInfo<$TimezonesTableTable, TimezonesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimezonesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _offsetMeta = const VerificationMeta('offset');
  @override
  late final GeneratedColumn<int> offset = GeneratedColumn<int>(
      'offset', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name, offset];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timezones_table';
  @override
  VerificationContext validateIntegrity(Insertable<TimezonesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('offset')) {
      context.handle(_offsetMeta,
          offset.isAcceptableOrUnknown(data['offset']!, _offsetMeta));
    } else if (isInserting) {
      context.missing(_offsetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TimezonesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimezonesTableData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      offset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offset'])!,
    );
  }

  @override
  $TimezonesTableTable createAlias(String alias) {
    return $TimezonesTableTable(attachedDatabase, alias);
  }
}

class TimezonesTableData extends DataClass
    implements Insertable<TimezonesTableData> {
  /// A text column named `name`. This stores the name of the timezone.
  ///
  /// Example: `MSK`, `UTC`, `GMT+3`
  final String name;

  /// A integer column named `offset`. This stores the offset of the timezone.
  ///
  /// Example: `3`, `0`, `-3`
  final int offset;
  const TimezonesTableData({required this.name, required this.offset});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['offset'] = Variable<int>(offset);
    return map;
  }

  TimezonesTableCompanion toCompanion(bool nullToAbsent) {
    return TimezonesTableCompanion(
      name: Value(name),
      offset: Value(offset),
    );
  }

  factory TimezonesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimezonesTableData(
      name: serializer.fromJson<String>(json['name']),
      offset: serializer.fromJson<int>(json['offset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'offset': serializer.toJson<int>(offset),
    };
  }

  TimezonesTableData copyWith({String? name, int? offset}) =>
      TimezonesTableData(
        name: name ?? this.name,
        offset: offset ?? this.offset,
      );
  @override
  String toString() {
    return (StringBuffer('TimezonesTableData(')
          ..write('name: $name, ')
          ..write('offset: $offset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, offset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimezonesTableData &&
          other.name == this.name &&
          other.offset == this.offset);
}

class TimezonesTableCompanion extends UpdateCompanion<TimezonesTableData> {
  final Value<String> name;
  final Value<int> offset;
  final Value<int> rowid;
  const TimezonesTableCompanion({
    this.name = const Value.absent(),
    this.offset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimezonesTableCompanion.insert({
    required String name,
    required int offset,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        offset = Value(offset);
  static Insertable<TimezonesTableData> custom({
    Expression<String>? name,
    Expression<int>? offset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (offset != null) 'offset': offset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimezonesTableCompanion copyWith(
      {Value<String>? name, Value<int>? offset, Value<int>? rowid}) {
    return TimezonesTableCompanion(
      name: name ?? this.name,
      offset: offset ?? this.offset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (offset.present) {
      map['offset'] = Variable<int>(offset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimezonesTableCompanion(')
          ..write('name: $name, ')
          ..write('offset: $offset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTableTable extends ActivitiesTable
    with TableInfo<$ActivitiesTableTable, ActivitiesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _maxMembersMeta =
      const VerificationMeta('maxMembers');
  @override
  late final GeneratedColumn<int> maxMembers = GeneratedColumn<int>(
      'max_members', aliasedName, false,
      check: () => maxMembers.isBiggerThan(const Constant(1)),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _bannerUrlMeta =
      const VerificationMeta('bannerUrl');
  @override
  late final GeneratedColumn<String> bannerUrl = GeneratedColumn<String>(
      'banner_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [name, maxMembers, bannerUrl, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ActivitiesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('max_members')) {
      context.handle(
          _maxMembersMeta,
          maxMembers.isAcceptableOrUnknown(
              data['max_members']!, _maxMembersMeta));
    } else if (isInserting) {
      context.missing(_maxMembersMeta);
    }
    if (data.containsKey('banner_url')) {
      context.handle(_bannerUrlMeta,
          bannerUrl.isAcceptableOrUnknown(data['banner_url']!, _bannerUrlMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ActivitiesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivitiesTableData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      maxMembers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_members'])!,
      bannerUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}banner_url']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
    );
  }

  @override
  $ActivitiesTableTable createAlias(String alias) {
    return $ActivitiesTableTable(attachedDatabase, alias);
  }
}

class ActivitiesTableData extends DataClass
    implements Insertable<ActivitiesTableData> {
  /// Visible name of the activity. Should be unique.
  final String name;

  /// Maximum amount of members that can join the activity.
  final int maxMembers;

  /// Uri to the banner image of the activity.
  final String? bannerUrl;

  /// Whether the activity is enabled or not.
  final bool enabled;
  const ActivitiesTableData(
      {required this.name,
      required this.maxMembers,
      this.bannerUrl,
      required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['max_members'] = Variable<int>(maxMembers);
    if (!nullToAbsent || bannerUrl != null) {
      map['banner_url'] = Variable<String>(bannerUrl);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ActivitiesTableCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesTableCompanion(
      name: Value(name),
      maxMembers: Value(maxMembers),
      bannerUrl: bannerUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(bannerUrl),
      enabled: Value(enabled),
    );
  }

  factory ActivitiesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivitiesTableData(
      name: serializer.fromJson<String>(json['name']),
      maxMembers: serializer.fromJson<int>(json['maxMembers']),
      bannerUrl: serializer.fromJson<String?>(json['bannerUrl']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'maxMembers': serializer.toJson<int>(maxMembers),
      'bannerUrl': serializer.toJson<String?>(bannerUrl),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  ActivitiesTableData copyWith(
          {String? name,
          int? maxMembers,
          Value<String?> bannerUrl = const Value.absent(),
          bool? enabled}) =>
      ActivitiesTableData(
        name: name ?? this.name,
        maxMembers: maxMembers ?? this.maxMembers,
        bannerUrl: bannerUrl.present ? bannerUrl.value : this.bannerUrl,
        enabled: enabled ?? this.enabled,
      );
  @override
  String toString() {
    return (StringBuffer('ActivitiesTableData(')
          ..write('name: $name, ')
          ..write('maxMembers: $maxMembers, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, maxMembers, bannerUrl, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivitiesTableData &&
          other.name == this.name &&
          other.maxMembers == this.maxMembers &&
          other.bannerUrl == this.bannerUrl &&
          other.enabled == this.enabled);
}

class ActivitiesTableCompanion extends UpdateCompanion<ActivitiesTableData> {
  final Value<String> name;
  final Value<int> maxMembers;
  final Value<String?> bannerUrl;
  final Value<bool> enabled;
  final Value<int> rowid;
  const ActivitiesTableCompanion({
    this.name = const Value.absent(),
    this.maxMembers = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesTableCompanion.insert({
    required String name,
    required int maxMembers,
    this.bannerUrl = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        maxMembers = Value(maxMembers);
  static Insertable<ActivitiesTableData> custom({
    Expression<String>? name,
    Expression<int>? maxMembers,
    Expression<String>? bannerUrl,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (maxMembers != null) 'max_members': maxMembers,
      if (bannerUrl != null) 'banner_url': bannerUrl,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesTableCompanion copyWith(
      {Value<String>? name,
      Value<int>? maxMembers,
      Value<String?>? bannerUrl,
      Value<bool>? enabled,
      Value<int>? rowid}) {
    return ActivitiesTableCompanion(
      name: name ?? this.name,
      maxMembers: maxMembers ?? this.maxMembers,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (maxMembers.present) {
      map['max_members'] = Variable<int>(maxMembers.value);
    }
    if (bannerUrl.present) {
      map['banner_url'] = Variable<String>(bannerUrl.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesTableCompanion(')
          ..write('name: $name, ')
          ..write('maxMembers: $maxMembers, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RolesTableTable extends RolesTable
    with TableInfo<$RolesTableTable, RolesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles_table';
  @override
  VerificationContext validateIntegrity(Insertable<RolesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  RolesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RolesTableData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $RolesTableTable createAlias(String alias) {
    return $RolesTableTable(attachedDatabase, alias);
  }
}

class RolesTableData extends DataClass implements Insertable<RolesTableData> {
  /// Name of the role. Should be unique.
  final String name;
  const RolesTableData({required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    return map;
  }

  RolesTableCompanion toCompanion(bool nullToAbsent) {
    return RolesTableCompanion(
      name: Value(name),
    );
  }

  factory RolesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RolesTableData(
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
    };
  }

  RolesTableData copyWith({String? name}) => RolesTableData(
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('RolesTableData(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => name.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RolesTableData && other.name == this.name);
}

class RolesTableCompanion extends UpdateCompanion<RolesTableData> {
  final Value<String> name;
  final Value<int> rowid;
  const RolesTableCompanion({
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolesTableCompanion.insert({
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<RolesTableData> custom({
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RolesTableCompanion copyWith({Value<String>? name, Value<int>? rowid}) {
    return RolesTableCompanion(
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesTableCompanion(')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesRolesTableTable extends ActivitiesRolesTable
    with TableInfo<$ActivitiesRolesTableTable, ActivitiesRolesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesRolesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityMeta =
      const VerificationMeta('activity');
  @override
  late final GeneratedColumn<String> activity = GeneratedColumn<String>(
      'activity', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES activities_table (name) ON DELETE CASCADE'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES roles_table (name) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [activity, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities_roles_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ActivitiesRolesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity')) {
      context.handle(_activityMeta,
          activity.isAcceptableOrUnknown(data['activity']!, _activityMeta));
    } else if (isInserting) {
      context.missing(_activityMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ActivitiesRolesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivitiesRolesTableData(
      activity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
    );
  }

  @override
  $ActivitiesRolesTableTable createAlias(String alias) {
    return $ActivitiesRolesTableTable(attachedDatabase, alias);
  }
}

class ActivitiesRolesTableData extends DataClass
    implements Insertable<ActivitiesRolesTableData> {
  /// Name of the activity that the role is assigned to.
  final String activity;

  /// Name of the role that is assigned to the activity.
  final String role;
  const ActivitiesRolesTableData({required this.activity, required this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity'] = Variable<String>(activity);
    map['role'] = Variable<String>(role);
    return map;
  }

  ActivitiesRolesTableCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesRolesTableCompanion(
      activity: Value(activity),
      role: Value(role),
    );
  }

  factory ActivitiesRolesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivitiesRolesTableData(
      activity: serializer.fromJson<String>(json['activity']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activity': serializer.toJson<String>(activity),
      'role': serializer.toJson<String>(role),
    };
  }

  ActivitiesRolesTableData copyWith({String? activity, String? role}) =>
      ActivitiesRolesTableData(
        activity: activity ?? this.activity,
        role: role ?? this.role,
      );
  @override
  String toString() {
    return (StringBuffer('ActivitiesRolesTableData(')
          ..write('activity: $activity, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activity, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivitiesRolesTableData &&
          other.activity == this.activity &&
          other.role == this.role);
}

class ActivitiesRolesTableCompanion
    extends UpdateCompanion<ActivitiesRolesTableData> {
  final Value<String> activity;
  final Value<String> role;
  final Value<int> rowid;
  const ActivitiesRolesTableCompanion({
    this.activity = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesRolesTableCompanion.insert({
    required String activity,
    required String role,
    this.rowid = const Value.absent(),
  })  : activity = Value(activity),
        role = Value(role);
  static Insertable<ActivitiesRolesTableData> custom({
    Expression<String>? activity,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activity != null) 'activity': activity,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesRolesTableCompanion copyWith(
      {Value<String>? activity, Value<String>? role, Value<int>? rowid}) {
    return ActivitiesRolesTableCompanion(
      activity: activity ?? this.activity,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activity.present) {
      map['activity'] = Variable<String>(activity.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesRolesTableCompanion(')
          ..write('activity: $activity, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PromoteMessagesTableTable extends PromoteMessagesTable
    with TableInfo<$PromoteMessagesTableTable, PromoteMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromoteMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, message, weight];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promote_messages_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PromoteMessagesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromoteMessagesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromoteMessagesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight'])!,
    );
  }

  @override
  $PromoteMessagesTableTable createAlias(String alias) {
    return $PromoteMessagesTableTable(attachedDatabase, alias);
  }
}

class PromoteMessagesTableData extends DataClass
    implements Insertable<PromoteMessagesTableData> {
  final int id;
  final String message;
  final int weight;
  const PromoteMessagesTableData(
      {required this.id, required this.message, required this.weight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message'] = Variable<String>(message);
    map['weight'] = Variable<int>(weight);
    return map;
  }

  PromoteMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return PromoteMessagesTableCompanion(
      id: Value(id),
      message: Value(message),
      weight: Value(weight),
    );
  }

  factory PromoteMessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromoteMessagesTableData(
      id: serializer.fromJson<int>(json['id']),
      message: serializer.fromJson<String>(json['message']),
      weight: serializer.fromJson<int>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(message),
      'weight': serializer.toJson<int>(weight),
    };
  }

  PromoteMessagesTableData copyWith({int? id, String? message, int? weight}) =>
      PromoteMessagesTableData(
        id: id ?? this.id,
        message: message ?? this.message,
        weight: weight ?? this.weight,
      );
  @override
  String toString() {
    return (StringBuffer('PromoteMessagesTableData(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, message, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromoteMessagesTableData &&
          other.id == this.id &&
          other.message == this.message &&
          other.weight == this.weight);
}

class PromoteMessagesTableCompanion
    extends UpdateCompanion<PromoteMessagesTableData> {
  final Value<int> id;
  final Value<String> message;
  final Value<int> weight;
  const PromoteMessagesTableCompanion({
    this.id = const Value.absent(),
    this.message = const Value.absent(),
    this.weight = const Value.absent(),
  });
  PromoteMessagesTableCompanion.insert({
    this.id = const Value.absent(),
    required String message,
    required int weight,
  })  : message = Value(message),
        weight = Value(weight);
  static Insertable<PromoteMessagesTableData> custom({
    Expression<int>? id,
    Expression<String>? message,
    Expression<int>? weight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (message != null) 'message': message,
      if (weight != null) 'weight': weight,
    });
  }

  PromoteMessagesTableCompanion copyWith(
      {Value<int>? id, Value<String>? message, Value<int>? weight}) {
    return PromoteMessagesTableCompanion(
      id: id ?? this.id,
      message: message ?? this.message,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromoteMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

abstract class _$SettingsDatabase extends GeneratedDatabase {
  _$SettingsDatabase(QueryExecutor e) : super(e);
  _$SettingsDatabaseManager get managers => _$SettingsDatabaseManager(this);
  late final $KeyedSettingsTableTable keyedSettingsTable =
      $KeyedSettingsTableTable(this);
  late final $TimezonesTableTable timezonesTable = $TimezonesTableTable(this);
  late final $ActivitiesTableTable activitiesTable =
      $ActivitiesTableTable(this);
  late final $RolesTableTable rolesTable = $RolesTableTable(this);
  late final $ActivitiesRolesTableTable activitiesRolesTable =
      $ActivitiesRolesTableTable(this);
  late final $PromoteMessagesTableTable promoteMessagesTable =
      $PromoteMessagesTableTable(this);
  late final ActivitiesDao activitiesDao =
      ActivitiesDao(this as SettingsDatabase);
  late final GuildSettingsDao guildSettingsDao =
      GuildSettingsDao(this as SettingsDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        keyedSettingsTable,
        timezonesTable,
        activitiesTable,
        rolesTable,
        activitiesRolesTable,
        promoteMessagesTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('activities_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('activities_roles_table', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('roles_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('activities_roles_table', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$KeyedSettingsTableTableInsertCompanionBuilder
    = KeyedSettingsTableCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyedSettingsTableTableUpdateCompanionBuilder
    = KeyedSettingsTableCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyedSettingsTableTableTableManager extends RootTableManager<
    _$SettingsDatabase,
    $KeyedSettingsTableTable,
    KeyedSettingsTableData,
    $$KeyedSettingsTableTableFilterComposer,
    $$KeyedSettingsTableTableOrderingComposer,
    $$KeyedSettingsTableTableProcessedTableManager,
    $$KeyedSettingsTableTableInsertCompanionBuilder,
    $$KeyedSettingsTableTableUpdateCompanionBuilder> {
  $$KeyedSettingsTableTableTableManager(
      _$SettingsDatabase db, $KeyedSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$KeyedSettingsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$KeyedSettingsTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$KeyedSettingsTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KeyedSettingsTableCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              KeyedSettingsTableCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
        ));
}

class $$KeyedSettingsTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$SettingsDatabase,
        $KeyedSettingsTableTable,
        KeyedSettingsTableData,
        $$KeyedSettingsTableTableFilterComposer,
        $$KeyedSettingsTableTableOrderingComposer,
        $$KeyedSettingsTableTableProcessedTableManager,
        $$KeyedSettingsTableTableInsertCompanionBuilder,
        $$KeyedSettingsTableTableUpdateCompanionBuilder> {
  $$KeyedSettingsTableTableProcessedTableManager(super.$state);
}

class $$KeyedSettingsTableTableFilterComposer
    extends FilterComposer<_$SettingsDatabase, $KeyedSettingsTableTable> {
  $$KeyedSettingsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$KeyedSettingsTableTableOrderingComposer
    extends OrderingComposer<_$SettingsDatabase, $KeyedSettingsTableTable> {
  $$KeyedSettingsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TimezonesTableTableInsertCompanionBuilder = TimezonesTableCompanion
    Function({
  required String name,
  required int offset,
  Value<int> rowid,
});
typedef $$TimezonesTableTableUpdateCompanionBuilder = TimezonesTableCompanion
    Function({
  Value<String> name,
  Value<int> offset,
  Value<int> rowid,
});

class $$TimezonesTableTableTableManager extends RootTableManager<
    _$SettingsDatabase,
    $TimezonesTableTable,
    TimezonesTableData,
    $$TimezonesTableTableFilterComposer,
    $$TimezonesTableTableOrderingComposer,
    $$TimezonesTableTableProcessedTableManager,
    $$TimezonesTableTableInsertCompanionBuilder,
    $$TimezonesTableTableUpdateCompanionBuilder> {
  $$TimezonesTableTableTableManager(
      _$SettingsDatabase db, $TimezonesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TimezonesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TimezonesTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TimezonesTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> name = const Value.absent(),
            Value<int> offset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TimezonesTableCompanion(
            name: name,
            offset: offset,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String name,
            required int offset,
            Value<int> rowid = const Value.absent(),
          }) =>
              TimezonesTableCompanion.insert(
            name: name,
            offset: offset,
            rowid: rowid,
          ),
        ));
}

class $$TimezonesTableTableProcessedTableManager extends ProcessedTableManager<
    _$SettingsDatabase,
    $TimezonesTableTable,
    TimezonesTableData,
    $$TimezonesTableTableFilterComposer,
    $$TimezonesTableTableOrderingComposer,
    $$TimezonesTableTableProcessedTableManager,
    $$TimezonesTableTableInsertCompanionBuilder,
    $$TimezonesTableTableUpdateCompanionBuilder> {
  $$TimezonesTableTableProcessedTableManager(super.$state);
}

class $$TimezonesTableTableFilterComposer
    extends FilterComposer<_$SettingsDatabase, $TimezonesTableTable> {
  $$TimezonesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get offset => $state.composableBuilder(
      column: $state.table.offset,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TimezonesTableTableOrderingComposer
    extends OrderingComposer<_$SettingsDatabase, $TimezonesTableTable> {
  $$TimezonesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get offset => $state.composableBuilder(
      column: $state.table.offset,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ActivitiesTableTableInsertCompanionBuilder = ActivitiesTableCompanion
    Function({
  required String name,
  required int maxMembers,
  Value<String?> bannerUrl,
  Value<bool> enabled,
  Value<int> rowid,
});
typedef $$ActivitiesTableTableUpdateCompanionBuilder = ActivitiesTableCompanion
    Function({
  Value<String> name,
  Value<int> maxMembers,
  Value<String?> bannerUrl,
  Value<bool> enabled,
  Value<int> rowid,
});

class $$ActivitiesTableTableTableManager extends RootTableManager<
    _$SettingsDatabase,
    $ActivitiesTableTable,
    ActivitiesTableData,
    $$ActivitiesTableTableFilterComposer,
    $$ActivitiesTableTableOrderingComposer,
    $$ActivitiesTableTableProcessedTableManager,
    $$ActivitiesTableTableInsertCompanionBuilder,
    $$ActivitiesTableTableUpdateCompanionBuilder> {
  $$ActivitiesTableTableTableManager(
      _$SettingsDatabase db, $ActivitiesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ActivitiesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ActivitiesTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ActivitiesTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> name = const Value.absent(),
            Value<int> maxMembers = const Value.absent(),
            Value<String?> bannerUrl = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivitiesTableCompanion(
            name: name,
            maxMembers: maxMembers,
            bannerUrl: bannerUrl,
            enabled: enabled,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String name,
            required int maxMembers,
            Value<String?> bannerUrl = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivitiesTableCompanion.insert(
            name: name,
            maxMembers: maxMembers,
            bannerUrl: bannerUrl,
            enabled: enabled,
            rowid: rowid,
          ),
        ));
}

class $$ActivitiesTableTableProcessedTableManager extends ProcessedTableManager<
    _$SettingsDatabase,
    $ActivitiesTableTable,
    ActivitiesTableData,
    $$ActivitiesTableTableFilterComposer,
    $$ActivitiesTableTableOrderingComposer,
    $$ActivitiesTableTableProcessedTableManager,
    $$ActivitiesTableTableInsertCompanionBuilder,
    $$ActivitiesTableTableUpdateCompanionBuilder> {
  $$ActivitiesTableTableProcessedTableManager(super.$state);
}

class $$ActivitiesTableTableFilterComposer
    extends FilterComposer<_$SettingsDatabase, $ActivitiesTableTable> {
  $$ActivitiesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maxMembers => $state.composableBuilder(
      column: $state.table.maxMembers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bannerUrl => $state.composableBuilder(
      column: $state.table.bannerUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter activitiesRolesTableRefs(
      ComposableFilter Function($$ActivitiesRolesTableTableFilterComposer f)
          f) {
    final $$ActivitiesRolesTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.name,
            referencedTable: $state.db.activitiesRolesTable,
            getReferencedColumn: (t) => t.activity,
            builder: (joinBuilder, parentComposers) =>
                $$ActivitiesRolesTableTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.activitiesRolesTable,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$ActivitiesTableTableOrderingComposer
    extends OrderingComposer<_$SettingsDatabase, $ActivitiesTableTable> {
  $$ActivitiesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maxMembers => $state.composableBuilder(
      column: $state.table.maxMembers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bannerUrl => $state.composableBuilder(
      column: $state.table.bannerUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$RolesTableTableInsertCompanionBuilder = RolesTableCompanion Function({
  required String name,
  Value<int> rowid,
});
typedef $$RolesTableTableUpdateCompanionBuilder = RolesTableCompanion Function({
  Value<String> name,
  Value<int> rowid,
});

class $$RolesTableTableTableManager extends RootTableManager<
    _$SettingsDatabase,
    $RolesTableTable,
    RolesTableData,
    $$RolesTableTableFilterComposer,
    $$RolesTableTableOrderingComposer,
    $$RolesTableTableProcessedTableManager,
    $$RolesTableTableInsertCompanionBuilder,
    $$RolesTableTableUpdateCompanionBuilder> {
  $$RolesTableTableTableManager(_$SettingsDatabase db, $RolesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RolesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$RolesTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$RolesTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RolesTableCompanion(
            name: name,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              RolesTableCompanion.insert(
            name: name,
            rowid: rowid,
          ),
        ));
}

class $$RolesTableTableProcessedTableManager extends ProcessedTableManager<
    _$SettingsDatabase,
    $RolesTableTable,
    RolesTableData,
    $$RolesTableTableFilterComposer,
    $$RolesTableTableOrderingComposer,
    $$RolesTableTableProcessedTableManager,
    $$RolesTableTableInsertCompanionBuilder,
    $$RolesTableTableUpdateCompanionBuilder> {
  $$RolesTableTableProcessedTableManager(super.$state);
}

class $$RolesTableTableFilterComposer
    extends FilterComposer<_$SettingsDatabase, $RolesTableTable> {
  $$RolesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter activitiesRolesTableRefs(
      ComposableFilter Function($$ActivitiesRolesTableTableFilterComposer f)
          f) {
    final $$ActivitiesRolesTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.name,
            referencedTable: $state.db.activitiesRolesTable,
            getReferencedColumn: (t) => t.role,
            builder: (joinBuilder, parentComposers) =>
                $$ActivitiesRolesTableTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.activitiesRolesTable,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$RolesTableTableOrderingComposer
    extends OrderingComposer<_$SettingsDatabase, $RolesTableTable> {
  $$RolesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ActivitiesRolesTableTableInsertCompanionBuilder
    = ActivitiesRolesTableCompanion Function({
  required String activity,
  required String role,
  Value<int> rowid,
});
typedef $$ActivitiesRolesTableTableUpdateCompanionBuilder
    = ActivitiesRolesTableCompanion Function({
  Value<String> activity,
  Value<String> role,
  Value<int> rowid,
});

class $$ActivitiesRolesTableTableTableManager extends RootTableManager<
    _$SettingsDatabase,
    $ActivitiesRolesTableTable,
    ActivitiesRolesTableData,
    $$ActivitiesRolesTableTableFilterComposer,
    $$ActivitiesRolesTableTableOrderingComposer,
    $$ActivitiesRolesTableTableProcessedTableManager,
    $$ActivitiesRolesTableTableInsertCompanionBuilder,
    $$ActivitiesRolesTableTableUpdateCompanionBuilder> {
  $$ActivitiesRolesTableTableTableManager(
      _$SettingsDatabase db, $ActivitiesRolesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ActivitiesRolesTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ActivitiesRolesTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ActivitiesRolesTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> activity = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivitiesRolesTableCompanion(
            activity: activity,
            role: role,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String activity,
            required String role,
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivitiesRolesTableCompanion.insert(
            activity: activity,
            role: role,
            rowid: rowid,
          ),
        ));
}

class $$ActivitiesRolesTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$SettingsDatabase,
        $ActivitiesRolesTableTable,
        ActivitiesRolesTableData,
        $$ActivitiesRolesTableTableFilterComposer,
        $$ActivitiesRolesTableTableOrderingComposer,
        $$ActivitiesRolesTableTableProcessedTableManager,
        $$ActivitiesRolesTableTableInsertCompanionBuilder,
        $$ActivitiesRolesTableTableUpdateCompanionBuilder> {
  $$ActivitiesRolesTableTableProcessedTableManager(super.$state);
}

class $$ActivitiesRolesTableTableFilterComposer
    extends FilterComposer<_$SettingsDatabase, $ActivitiesRolesTableTable> {
  $$ActivitiesRolesTableTableFilterComposer(super.$state);
  $$ActivitiesTableTableFilterComposer get activity {
    final $$ActivitiesTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.activity,
            referencedTable: $state.db.activitiesTable,
            getReferencedColumn: (t) => t.name,
            builder: (joinBuilder, parentComposers) =>
                $$ActivitiesTableTableFilterComposer(ComposerState($state.db,
                    $state.db.activitiesTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$RolesTableTableFilterComposer get role {
    final $$RolesTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.role,
        referencedTable: $state.db.rolesTable,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder, parentComposers) =>
            $$RolesTableTableFilterComposer(ComposerState($state.db,
                $state.db.rolesTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ActivitiesRolesTableTableOrderingComposer
    extends OrderingComposer<_$SettingsDatabase, $ActivitiesRolesTableTable> {
  $$ActivitiesRolesTableTableOrderingComposer(super.$state);
  $$ActivitiesTableTableOrderingComposer get activity {
    final $$ActivitiesTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.activity,
            referencedTable: $state.db.activitiesTable,
            getReferencedColumn: (t) => t.name,
            builder: (joinBuilder, parentComposers) =>
                $$ActivitiesTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.activitiesTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$RolesTableTableOrderingComposer get role {
    final $$RolesTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.role,
        referencedTable: $state.db.rolesTable,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder, parentComposers) =>
            $$RolesTableTableOrderingComposer(ComposerState($state.db,
                $state.db.rolesTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PromoteMessagesTableTableInsertCompanionBuilder
    = PromoteMessagesTableCompanion Function({
  Value<int> id,
  required String message,
  required int weight,
});
typedef $$PromoteMessagesTableTableUpdateCompanionBuilder
    = PromoteMessagesTableCompanion Function({
  Value<int> id,
  Value<String> message,
  Value<int> weight,
});

class $$PromoteMessagesTableTableTableManager extends RootTableManager<
    _$SettingsDatabase,
    $PromoteMessagesTableTable,
    PromoteMessagesTableData,
    $$PromoteMessagesTableTableFilterComposer,
    $$PromoteMessagesTableTableOrderingComposer,
    $$PromoteMessagesTableTableProcessedTableManager,
    $$PromoteMessagesTableTableInsertCompanionBuilder,
    $$PromoteMessagesTableTableUpdateCompanionBuilder> {
  $$PromoteMessagesTableTableTableManager(
      _$SettingsDatabase db, $PromoteMessagesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$PromoteMessagesTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$PromoteMessagesTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PromoteMessagesTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<int> weight = const Value.absent(),
          }) =>
              PromoteMessagesTableCompanion(
            id: id,
            message: message,
            weight: weight,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String message,
            required int weight,
          }) =>
              PromoteMessagesTableCompanion.insert(
            id: id,
            message: message,
            weight: weight,
          ),
        ));
}

class $$PromoteMessagesTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$SettingsDatabase,
        $PromoteMessagesTableTable,
        PromoteMessagesTableData,
        $$PromoteMessagesTableTableFilterComposer,
        $$PromoteMessagesTableTableOrderingComposer,
        $$PromoteMessagesTableTableProcessedTableManager,
        $$PromoteMessagesTableTableInsertCompanionBuilder,
        $$PromoteMessagesTableTableUpdateCompanionBuilder> {
  $$PromoteMessagesTableTableProcessedTableManager(super.$state);
}

class $$PromoteMessagesTableTableFilterComposer
    extends FilterComposer<_$SettingsDatabase, $PromoteMessagesTableTable> {
  $$PromoteMessagesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PromoteMessagesTableTableOrderingComposer
    extends OrderingComposer<_$SettingsDatabase, $PromoteMessagesTableTable> {
  $$PromoteMessagesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$SettingsDatabaseManager {
  final _$SettingsDatabase _db;
  _$SettingsDatabaseManager(this._db);
  $$KeyedSettingsTableTableTableManager get keyedSettingsTable =>
      $$KeyedSettingsTableTableTableManager(_db, _db.keyedSettingsTable);
  $$TimezonesTableTableTableManager get timezonesTable =>
      $$TimezonesTableTableTableManager(_db, _db.timezonesTable);
  $$ActivitiesTableTableTableManager get activitiesTable =>
      $$ActivitiesTableTableTableManager(_db, _db.activitiesTable);
  $$RolesTableTableTableManager get rolesTable =>
      $$RolesTableTableTableManager(_db, _db.rolesTable);
  $$ActivitiesRolesTableTableTableManager get activitiesRolesTable =>
      $$ActivitiesRolesTableTableTableManager(_db, _db.activitiesRolesTable);
  $$PromoteMessagesTableTableTableManager get promoteMessagesTable =>
      $$PromoteMessagesTableTableTableManager(_db, _db.promoteMessagesTable);
}
