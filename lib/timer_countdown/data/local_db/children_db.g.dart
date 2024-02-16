// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_db.dart';

// ignore_for_file: type=lint
class $ChildrenTable extends Children
    with TableInfo<$ChildrenTable, ChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _babyBirthdayMeta =
      const VerificationMeta('babyBirthday');
  @override
  late final GeneratedColumn<DateTime> babyBirthday = GeneratedColumn<DateTime>(
      'baby_birthday', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<bool> gender = GeneratedColumn<bool>(
      'gender', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("gender" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, name, babyBirthday, gender];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'children';
  @override
  VerificationContext validateIntegrity(Insertable<ChildrenData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('baby_birthday')) {
      context.handle(
          _babyBirthdayMeta,
          babyBirthday.isAcceptableOrUnknown(
              data['baby_birthday']!, _babyBirthdayMeta));
    } else if (isInserting) {
      context.missing(_babyBirthdayMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildrenData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      babyBirthday: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}baby_birthday'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}gender'])!,
    );
  }

  @override
  $ChildrenTable createAlias(String alias) {
    return $ChildrenTable(attachedDatabase, alias);
  }
}

class ChildrenData extends DataClass implements Insertable<ChildrenData> {
  final int id;
  final String name;
  final DateTime babyBirthday;
  final bool gender;
  const ChildrenData(
      {required this.id,
      required this.name,
      required this.babyBirthday,
      required this.gender});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['baby_birthday'] = Variable<DateTime>(babyBirthday);
    map['gender'] = Variable<bool>(gender);
    return map;
  }

  ChildrenCompanion toCompanion(bool nullToAbsent) {
    return ChildrenCompanion(
      id: Value(id),
      name: Value(name),
      babyBirthday: Value(babyBirthday),
      gender: Value(gender),
    );
  }

  factory ChildrenData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildrenData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      babyBirthday: serializer.fromJson<DateTime>(json['babyBirthday']),
      gender: serializer.fromJson<bool>(json['gender']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'babyBirthday': serializer.toJson<DateTime>(babyBirthday),
      'gender': serializer.toJson<bool>(gender),
    };
  }

  ChildrenData copyWith(
          {int? id, String? name, DateTime? babyBirthday, bool? gender}) =>
      ChildrenData(
        id: id ?? this.id,
        name: name ?? this.name,
        babyBirthday: babyBirthday ?? this.babyBirthday,
        gender: gender ?? this.gender,
      );
  @override
  String toString() {
    return (StringBuffer('ChildrenData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('babyBirthday: $babyBirthday, ')
          ..write('gender: $gender')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, babyBirthday, gender);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildrenData &&
          other.id == this.id &&
          other.name == this.name &&
          other.babyBirthday == this.babyBirthday &&
          other.gender == this.gender);
}

class ChildrenCompanion extends UpdateCompanion<ChildrenData> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> babyBirthday;
  final Value<bool> gender;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.babyBirthday = const Value.absent(),
    this.gender = const Value.absent(),
  });
  ChildrenCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime babyBirthday,
    required bool gender,
  })  : name = Value(name),
        babyBirthday = Value(babyBirthday),
        gender = Value(gender);
  static Insertable<ChildrenData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? babyBirthday,
    Expression<bool>? gender,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (babyBirthday != null) 'baby_birthday': babyBirthday,
      if (gender != null) 'gender': gender,
    });
  }

  ChildrenCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? babyBirthday,
      Value<bool>? gender}) {
    return ChildrenCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      babyBirthday: babyBirthday ?? this.babyBirthday,
      gender: gender ?? this.gender,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (babyBirthday.present) {
      map['baby_birthday'] = Variable<DateTime>(babyBirthday.value);
    }
    if (gender.present) {
      map['gender'] = Variable<bool>(gender.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('babyBirthday: $babyBirthday, ')
          ..write('gender: $gender')
          ..write(')'))
        .toString();
  }
}

class $ChildSleepTimeStatTable extends ChildSleepTimeStat
    with TableInfo<$ChildSleepTimeStatTable, ChildSleepTimeStatData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildSleepTimeStatTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statIdMeta = const VerificationMeta('statId');
  @override
  late final GeneratedColumn<int> statId = GeneratedColumn<int>(
      'stat_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<int> babyId = GeneratedColumn<int>(
      'baby_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _babySleepDateTimeMeta =
      const VerificationMeta('babySleepDateTime');
  @override
  late final GeneratedColumn<DateTime> babySleepDateTime =
      GeneratedColumn<DateTime>('baby_sleep_date_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _babyWakeUpDateTimeMeta =
      const VerificationMeta('babyWakeUpDateTime');
  @override
  late final GeneratedColumn<DateTime> babyWakeUpDateTime =
      GeneratedColumn<DateTime>('baby_wake_up_date_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [statId, babyId, babySleepDateTime, babyWakeUpDateTime, duration];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'child_sleep_time_stat';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChildSleepTimeStatData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stat_id')) {
      context.handle(_statIdMeta,
          statId.isAcceptableOrUnknown(data['stat_id']!, _statIdMeta));
    }
    if (data.containsKey('baby_id')) {
      context.handle(_babyIdMeta,
          babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta));
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('baby_sleep_date_time')) {
      context.handle(
          _babySleepDateTimeMeta,
          babySleepDateTime.isAcceptableOrUnknown(
              data['baby_sleep_date_time']!, _babySleepDateTimeMeta));
    } else if (isInserting) {
      context.missing(_babySleepDateTimeMeta);
    }
    if (data.containsKey('baby_wake_up_date_time')) {
      context.handle(
          _babyWakeUpDateTimeMeta,
          babyWakeUpDateTime.isAcceptableOrUnknown(
              data['baby_wake_up_date_time']!, _babyWakeUpDateTimeMeta));
    } else if (isInserting) {
      context.missing(_babyWakeUpDateTimeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {statId};
  @override
  ChildSleepTimeStatData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildSleepTimeStatData(
      statId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stat_id'])!,
      babyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}baby_id'])!,
      babySleepDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}baby_sleep_date_time'])!,
      babyWakeUpDateTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}baby_wake_up_date_time'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
    );
  }

  @override
  $ChildSleepTimeStatTable createAlias(String alias) {
    return $ChildSleepTimeStatTable(attachedDatabase, alias);
  }
}

class ChildSleepTimeStatData extends DataClass
    implements Insertable<ChildSleepTimeStatData> {
  final int statId;
  final int babyId;
  final DateTime babySleepDateTime;
  final DateTime babyWakeUpDateTime;
  final int duration;
  const ChildSleepTimeStatData(
      {required this.statId,
      required this.babyId,
      required this.babySleepDateTime,
      required this.babyWakeUpDateTime,
      required this.duration});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stat_id'] = Variable<int>(statId);
    map['baby_id'] = Variable<int>(babyId);
    map['baby_sleep_date_time'] = Variable<DateTime>(babySleepDateTime);
    map['baby_wake_up_date_time'] = Variable<DateTime>(babyWakeUpDateTime);
    map['duration'] = Variable<int>(duration);
    return map;
  }

  ChildSleepTimeStatCompanion toCompanion(bool nullToAbsent) {
    return ChildSleepTimeStatCompanion(
      statId: Value(statId),
      babyId: Value(babyId),
      babySleepDateTime: Value(babySleepDateTime),
      babyWakeUpDateTime: Value(babyWakeUpDateTime),
      duration: Value(duration),
    );
  }

  factory ChildSleepTimeStatData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildSleepTimeStatData(
      statId: serializer.fromJson<int>(json['statId']),
      babyId: serializer.fromJson<int>(json['babyId']),
      babySleepDateTime:
          serializer.fromJson<DateTime>(json['babySleepDateTime']),
      babyWakeUpDateTime:
          serializer.fromJson<DateTime>(json['babyWakeUpDateTime']),
      duration: serializer.fromJson<int>(json['duration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'statId': serializer.toJson<int>(statId),
      'babyId': serializer.toJson<int>(babyId),
      'babySleepDateTime': serializer.toJson<DateTime>(babySleepDateTime),
      'babyWakeUpDateTime': serializer.toJson<DateTime>(babyWakeUpDateTime),
      'duration': serializer.toJson<int>(duration),
    };
  }

  ChildSleepTimeStatData copyWith(
          {int? statId,
          int? babyId,
          DateTime? babySleepDateTime,
          DateTime? babyWakeUpDateTime,
          int? duration}) =>
      ChildSleepTimeStatData(
        statId: statId ?? this.statId,
        babyId: babyId ?? this.babyId,
        babySleepDateTime: babySleepDateTime ?? this.babySleepDateTime,
        babyWakeUpDateTime: babyWakeUpDateTime ?? this.babyWakeUpDateTime,
        duration: duration ?? this.duration,
      );
  @override
  String toString() {
    return (StringBuffer('ChildSleepTimeStatData(')
          ..write('statId: $statId, ')
          ..write('babyId: $babyId, ')
          ..write('babySleepDateTime: $babySleepDateTime, ')
          ..write('babyWakeUpDateTime: $babyWakeUpDateTime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      statId, babyId, babySleepDateTime, babyWakeUpDateTime, duration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildSleepTimeStatData &&
          other.statId == this.statId &&
          other.babyId == this.babyId &&
          other.babySleepDateTime == this.babySleepDateTime &&
          other.babyWakeUpDateTime == this.babyWakeUpDateTime &&
          other.duration == this.duration);
}

class ChildSleepTimeStatCompanion
    extends UpdateCompanion<ChildSleepTimeStatData> {
  final Value<int> statId;
  final Value<int> babyId;
  final Value<DateTime> babySleepDateTime;
  final Value<DateTime> babyWakeUpDateTime;
  final Value<int> duration;
  const ChildSleepTimeStatCompanion({
    this.statId = const Value.absent(),
    this.babyId = const Value.absent(),
    this.babySleepDateTime = const Value.absent(),
    this.babyWakeUpDateTime = const Value.absent(),
    this.duration = const Value.absent(),
  });
  ChildSleepTimeStatCompanion.insert({
    this.statId = const Value.absent(),
    required int babyId,
    required DateTime babySleepDateTime,
    required DateTime babyWakeUpDateTime,
    required int duration,
  })  : babyId = Value(babyId),
        babySleepDateTime = Value(babySleepDateTime),
        babyWakeUpDateTime = Value(babyWakeUpDateTime),
        duration = Value(duration);
  static Insertable<ChildSleepTimeStatData> custom({
    Expression<int>? statId,
    Expression<int>? babyId,
    Expression<DateTime>? babySleepDateTime,
    Expression<DateTime>? babyWakeUpDateTime,
    Expression<int>? duration,
  }) {
    return RawValuesInsertable({
      if (statId != null) 'stat_id': statId,
      if (babyId != null) 'baby_id': babyId,
      if (babySleepDateTime != null) 'baby_sleep_date_time': babySleepDateTime,
      if (babyWakeUpDateTime != null)
        'baby_wake_up_date_time': babyWakeUpDateTime,
      if (duration != null) 'duration': duration,
    });
  }

  ChildSleepTimeStatCompanion copyWith(
      {Value<int>? statId,
      Value<int>? babyId,
      Value<DateTime>? babySleepDateTime,
      Value<DateTime>? babyWakeUpDateTime,
      Value<int>? duration}) {
    return ChildSleepTimeStatCompanion(
      statId: statId ?? this.statId,
      babyId: babyId ?? this.babyId,
      babySleepDateTime: babySleepDateTime ?? this.babySleepDateTime,
      babyWakeUpDateTime: babyWakeUpDateTime ?? this.babyWakeUpDateTime,
      duration: duration ?? this.duration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (statId.present) {
      map['stat_id'] = Variable<int>(statId.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<int>(babyId.value);
    }
    if (babySleepDateTime.present) {
      map['baby_sleep_date_time'] = Variable<DateTime>(babySleepDateTime.value);
    }
    if (babyWakeUpDateTime.present) {
      map['baby_wake_up_date_time'] =
          Variable<DateTime>(babyWakeUpDateTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildSleepTimeStatCompanion(')
          ..write('statId: $statId, ')
          ..write('babyId: $babyId, ')
          ..write('babySleepDateTime: $babySleepDateTime, ')
          ..write('babyWakeUpDateTime: $babyWakeUpDateTime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }
}

abstract class _$ChildrenDatabase extends GeneratedDatabase {
  _$ChildrenDatabase(QueryExecutor e) : super(e);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $ChildSleepTimeStatTable childSleepTimeStat =
      $ChildSleepTimeStatTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [children, childSleepTimeStat];
}
