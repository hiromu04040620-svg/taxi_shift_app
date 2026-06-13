// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ShiftPatternsTable extends ShiftPatterns
    with TableInfo<$ShiftPatternsTable, ShiftPattern> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftPatternsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workStyleMeta = const VerificationMeta(
    'workStyle',
  );
  @override
  late final GeneratedColumn<String> workStyle = GeneratedColumn<String>(
    'work_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<String> cycle = GeneratedColumn<String>(
    'cycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> startDate =
      GeneratedColumn<String>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ShiftPatternsTable.$converterstartDate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> validFrom =
      GeneratedColumn<String>(
        'valid_from',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ShiftPatternsTable.$convertervalidFrom);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> validUntil =
      GeneratedColumn<String>(
        'valid_until',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ShiftPatternsTable.$convertervalidUntiln);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    name,
    workStyle,
    cycle,
    startDate,
    validFrom,
    validUntil,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_patterns';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftPattern> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('work_style')) {
      context.handle(
        _workStyleMeta,
        workStyle.isAcceptableOrUnknown(data['work_style']!, _workStyleMeta),
      );
    } else if (isInserting) {
      context.missing(_workStyleMeta);
    }
    if (data.containsKey('cycle')) {
      context.handle(
        _cycleMeta,
        cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftPattern map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftPattern(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      workStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_style'],
      )!,
      cycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle'],
      )!,
      startDate: $ShiftPatternsTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      validFrom: $ShiftPatternsTable.$convertervalidFrom.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}valid_from'],
        )!,
      ),
      validUntil: $ShiftPatternsTable.$convertervalidUntiln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}valid_until'],
        ),
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ShiftPatternsTable createAlias(String alias) {
    return $ShiftPatternsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterstartDate =
      const DateOnlyConverter();
  static TypeConverter<DateTime, String> $convertervalidFrom =
      const DateOnlyConverter();
  static TypeConverter<DateTime, String> $convertervalidUntil =
      const DateOnlyConverter();
  static TypeConverter<DateTime?, String?> $convertervalidUntiln =
      NullAwareTypeConverter.wrap($convertervalidUntil);
}

class ShiftPattern extends DataClass implements Insertable<ShiftPattern> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final String name;
  final String workStyle;
  final String cycle;
  final DateTime startDate;
  final DateTime validFrom;
  final DateTime? validUntil;
  final bool isActive;
  const ShiftPattern({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.name,
    required this.workStyle,
    required this.cycle,
    required this.startDate,
    required this.validFrom,
    this.validUntil,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['work_style'] = Variable<String>(workStyle);
    map['cycle'] = Variable<String>(cycle);
    {
      map['start_date'] = Variable<String>(
        $ShiftPatternsTable.$converterstartDate.toSql(startDate),
      );
    }
    {
      map['valid_from'] = Variable<String>(
        $ShiftPatternsTable.$convertervalidFrom.toSql(validFrom),
      );
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<String>(
        $ShiftPatternsTable.$convertervalidUntiln.toSql(validUntil),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ShiftPatternsCompanion toCompanion(bool nullToAbsent) {
    return ShiftPatternsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      name: Value(name),
      workStyle: Value(workStyle),
      cycle: Value(cycle),
      startDate: Value(startDate),
      validFrom: Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      isActive: Value(isActive),
    );
  }

  factory ShiftPattern.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftPattern(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      workStyle: serializer.fromJson<String>(json['workStyle']),
      cycle: serializer.fromJson<String>(json['cycle']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'workStyle': serializer.toJson<String>(workStyle),
      'cycle': serializer.toJson<String>(cycle),
      'startDate': serializer.toJson<DateTime>(startDate),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ShiftPattern copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? name,
    String? workStyle,
    String? cycle,
    DateTime? startDate,
    DateTime? validFrom,
    Value<DateTime?> validUntil = const Value.absent(),
    bool? isActive,
  }) => ShiftPattern(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    workStyle: workStyle ?? this.workStyle,
    cycle: cycle ?? this.cycle,
    startDate: startDate ?? this.startDate,
    validFrom: validFrom ?? this.validFrom,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    isActive: isActive ?? this.isActive,
  );
  ShiftPattern copyWithCompanion(ShiftPatternsCompanion data) {
    return ShiftPattern(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      workStyle: data.workStyle.present ? data.workStyle.value : this.workStyle,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPattern(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workStyle: $workStyle, ')
          ..write('cycle: $cycle, ')
          ..write('startDate: $startDate, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    id,
    name,
    workStyle,
    cycle,
    startDate,
    validFrom,
    validUntil,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftPattern &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.workStyle == this.workStyle &&
          other.cycle == this.cycle &&
          other.startDate == this.startDate &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.isActive == this.isActive);
}

class ShiftPatternsCompanion extends UpdateCompanion<ShiftPattern> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<String> name;
  final Value<String> workStyle;
  final Value<String> cycle;
  final Value<DateTime> startDate;
  final Value<DateTime> validFrom;
  final Value<DateTime?> validUntil;
  final Value<bool> isActive;
  const ShiftPatternsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.workStyle = const Value.absent(),
    this.cycle = const Value.absent(),
    this.startDate = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ShiftPatternsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    required String workStyle,
    required String cycle,
    required DateTime startDate,
    required DateTime validFrom,
    this.validUntil = const Value.absent(),
    required bool isActive,
  }) : name = Value(name),
       workStyle = Value(workStyle),
       cycle = Value(cycle),
       startDate = Value(startDate),
       validFrom = Value(validFrom),
       isActive = Value(isActive);
  static Insertable<ShiftPattern> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? workStyle,
    Expression<String>? cycle,
    Expression<String>? startDate,
    Expression<String>? validFrom,
    Expression<String>? validUntil,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (workStyle != null) 'work_style': workStyle,
      if (cycle != null) 'cycle': cycle,
      if (startDate != null) 'start_date': startDate,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ShiftPatternsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<String>? name,
    Value<String>? workStyle,
    Value<String>? cycle,
    Value<DateTime>? startDate,
    Value<DateTime>? validFrom,
    Value<DateTime?>? validUntil,
    Value<bool>? isActive,
  }) {
    return ShiftPatternsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      workStyle: workStyle ?? this.workStyle,
      cycle: cycle ?? this.cycle,
      startDate: startDate ?? this.startDate,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (workStyle.present) {
      map['work_style'] = Variable<String>(workStyle.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<String>(cycle.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(
        $ShiftPatternsTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(
        $ShiftPatternsTable.$convertervalidFrom.toSql(validFrom.value),
      );
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<String>(
        $ShiftPatternsTable.$convertervalidUntiln.toSql(validUntil.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workStyle: $workStyle, ')
          ..write('cycle: $cycle, ')
          ..write('startDate: $startDate, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ShiftOverridesTable extends ShiftOverrides
    with TableInfo<$ShiftOverridesTable, ShiftOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      ).withConverter<DateTime>($ShiftOverridesTable.$converterdate);
  static const VerificationMeta _shiftTypeMeta = const VerificationMeta(
    'shiftType',
  );
  @override
  late final GeneratedColumn<String> shiftType = GeneratedColumn<String>(
    'shift_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pairedOverrideIdMeta = const VerificationMeta(
    'pairedOverrideId',
  );
  @override
  late final GeneratedColumn<int> pairedOverrideId = GeneratedColumn<int>(
    'paired_override_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_overrides (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    date,
    shiftType,
    status,
    reason,
    pairedOverrideId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shift_type')) {
      context.handle(
        _shiftTypeMeta,
        shiftType.isAcceptableOrUnknown(data['shift_type']!, _shiftTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('paired_override_id')) {
      context.handle(
        _pairedOverrideIdMeta,
        pairedOverrideId.isAcceptableOrUnknown(
          data['paired_override_id']!,
          _pairedOverrideIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftOverride(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: $ShiftOverridesTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      shiftType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      pairedOverrideId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paired_override_id'],
      ),
    );
  }

  @override
  $ShiftOverridesTable createAlias(String alias) {
    return $ShiftOverridesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdate =
      const DateOnlyConverter();
}

class ShiftOverride extends DataClass implements Insertable<ShiftOverride> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final DateTime date;
  final String shiftType;
  final String status;
  final String? reason;
  final int? pairedOverrideId;
  const ShiftOverride({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.date,
    required this.shiftType,
    required this.status,
    this.reason,
    this.pairedOverrideId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    {
      map['date'] = Variable<String>(
        $ShiftOverridesTable.$converterdate.toSql(date),
      );
    }
    map['shift_type'] = Variable<String>(shiftType);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || pairedOverrideId != null) {
      map['paired_override_id'] = Variable<int>(pairedOverrideId);
    }
    return map;
  }

  ShiftOverridesCompanion toCompanion(bool nullToAbsent) {
    return ShiftOverridesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      date: Value(date),
      shiftType: Value(shiftType),
      status: Value(status),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      pairedOverrideId: pairedOverrideId == null && nullToAbsent
          ? const Value.absent()
          : Value(pairedOverrideId),
    );
  }

  factory ShiftOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftOverride(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      shiftType: serializer.fromJson<String>(json['shiftType']),
      status: serializer.fromJson<String>(json['status']),
      reason: serializer.fromJson<String?>(json['reason']),
      pairedOverrideId: serializer.fromJson<int?>(json['pairedOverrideId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'shiftType': serializer.toJson<String>(shiftType),
      'status': serializer.toJson<String>(status),
      'reason': serializer.toJson<String?>(reason),
      'pairedOverrideId': serializer.toJson<int?>(pairedOverrideId),
    };
  }

  ShiftOverride copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    DateTime? date,
    String? shiftType,
    String? status,
    Value<String?> reason = const Value.absent(),
    Value<int?> pairedOverrideId = const Value.absent(),
  }) => ShiftOverride(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    date: date ?? this.date,
    shiftType: shiftType ?? this.shiftType,
    status: status ?? this.status,
    reason: reason.present ? reason.value : this.reason,
    pairedOverrideId: pairedOverrideId.present
        ? pairedOverrideId.value
        : this.pairedOverrideId,
  );
  ShiftOverride copyWithCompanion(ShiftOverridesCompanion data) {
    return ShiftOverride(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      shiftType: data.shiftType.present ? data.shiftType.value : this.shiftType,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      pairedOverrideId: data.pairedOverrideId.present
          ? data.pairedOverrideId.value
          : this.pairedOverrideId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftOverride(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('shiftType: $shiftType, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('pairedOverrideId: $pairedOverrideId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    id,
    date,
    shiftType,
    status,
    reason,
    pairedOverrideId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftOverride &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.date == this.date &&
          other.shiftType == this.shiftType &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.pairedOverrideId == this.pairedOverrideId);
}

class ShiftOverridesCompanion extends UpdateCompanion<ShiftOverride> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> shiftType;
  final Value<String> status;
  final Value<String?> reason;
  final Value<int?> pairedOverrideId;
  const ShiftOverridesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.shiftType = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.pairedOverrideId = const Value.absent(),
  });
  ShiftOverridesCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required DateTime date,
    required String shiftType,
    required String status,
    this.reason = const Value.absent(),
    this.pairedOverrideId = const Value.absent(),
  }) : date = Value(date),
       shiftType = Value(shiftType),
       status = Value(status);
  static Insertable<ShiftOverride> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? shiftType,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<int>? pairedOverrideId,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (shiftType != null) 'shift_type': shiftType,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (pairedOverrideId != null) 'paired_override_id': pairedOverrideId,
    });
  }

  ShiftOverridesCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? shiftType,
    Value<String>? status,
    Value<String?>? reason,
    Value<int?>? pairedOverrideId,
  }) {
    return ShiftOverridesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      date: date ?? this.date,
      shiftType: shiftType ?? this.shiftType,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      pairedOverrideId: pairedOverrideId ?? this.pairedOverrideId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $ShiftOverridesTable.$converterdate.toSql(date.value),
      );
    }
    if (shiftType.present) {
      map['shift_type'] = Variable<String>(shiftType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (pairedOverrideId.present) {
      map['paired_override_id'] = Variable<int>(pairedOverrideId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftOverridesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('shiftType: $shiftType, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('pairedOverrideId: $pairedOverrideId')
          ..write(')'))
        .toString();
  }
}

class $RevenuesTable extends Revenues with TableInfo<$RevenuesTable, Revenue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RevenuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      ).withConverter<DateTime>($RevenuesTable.$converterdate);
  static const VerificationMeta _workSessionIdMeta = const VerificationMeta(
    'workSessionId',
  );
  @override
  late final GeneratedColumn<int> workSessionId = GeneratedColumn<int>(
    'work_session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grossRevenueMeta = const VerificationMeta(
    'grossRevenue',
  );
  @override
  late final GeneratedColumn<int> grossRevenue = GeneratedColumn<int>(
    'gross_revenue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxExcludedRevenueMeta =
      const VerificationMeta('taxExcludedRevenue');
  @override
  late final GeneratedColumn<int> taxExcludedRevenue = GeneratedColumn<int>(
    'tax_excluded_revenue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashAmountMeta = const VerificationMeta(
    'cashAmount',
  );
  @override
  late final GeneratedColumn<int> cashAmount = GeneratedColumn<int>(
    'cash_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardAmountMeta = const VerificationMeta(
    'cardAmount',
  );
  @override
  late final GeneratedColumn<int> cardAmount = GeneratedColumn<int>(
    'card_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appAmountMeta = const VerificationMeta(
    'appAmount',
  );
  @override
  late final GeneratedColumn<int> appAmount = GeneratedColumn<int>(
    'app_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ticketAmountMeta = const VerificationMeta(
    'ticketAmount',
  );
  @override
  late final GeneratedColumn<int> ticketAmount = GeneratedColumn<int>(
    'ticket_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDistanceMeta = const VerificationMeta(
    'totalDistance',
  );
  @override
  late final GeneratedColumn<double> totalDistance = GeneratedColumn<double>(
    'total_distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occupiedDistanceMeta = const VerificationMeta(
    'occupiedDistance',
  );
  @override
  late final GeneratedColumn<double> occupiedDistance = GeneratedColumn<double>(
    'occupied_distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ridesCountMeta = const VerificationMeta(
    'ridesCount',
  );
  @override
  late final GeneratedColumn<int> ridesCount = GeneratedColumn<int>(
    'rides_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelAmountMeta = const VerificationMeta(
    'fuelAmount',
  );
  @override
  late final GeneratedColumn<int> fuelAmount = GeneratedColumn<int>(
    'fuel_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    date,
    workSessionId,
    grossRevenue,
    taxExcludedRevenue,
    cashAmount,
    cardAmount,
    appAmount,
    ticketAmount,
    totalDistance,
    occupiedDistance,
    ridesCount,
    fuelAmount,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'revenues';
  @override
  VerificationContext validateIntegrity(
    Insertable<Revenue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_session_id')) {
      context.handle(
        _workSessionIdMeta,
        workSessionId.isAcceptableOrUnknown(
          data['work_session_id']!,
          _workSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('gross_revenue')) {
      context.handle(
        _grossRevenueMeta,
        grossRevenue.isAcceptableOrUnknown(
          data['gross_revenue']!,
          _grossRevenueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grossRevenueMeta);
    }
    if (data.containsKey('tax_excluded_revenue')) {
      context.handle(
        _taxExcludedRevenueMeta,
        taxExcludedRevenue.isAcceptableOrUnknown(
          data['tax_excluded_revenue']!,
          _taxExcludedRevenueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxExcludedRevenueMeta);
    }
    if (data.containsKey('cash_amount')) {
      context.handle(
        _cashAmountMeta,
        cashAmount.isAcceptableOrUnknown(data['cash_amount']!, _cashAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_cashAmountMeta);
    }
    if (data.containsKey('card_amount')) {
      context.handle(
        _cardAmountMeta,
        cardAmount.isAcceptableOrUnknown(data['card_amount']!, _cardAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_cardAmountMeta);
    }
    if (data.containsKey('app_amount')) {
      context.handle(
        _appAmountMeta,
        appAmount.isAcceptableOrUnknown(data['app_amount']!, _appAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_appAmountMeta);
    }
    if (data.containsKey('ticket_amount')) {
      context.handle(
        _ticketAmountMeta,
        ticketAmount.isAcceptableOrUnknown(
          data['ticket_amount']!,
          _ticketAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ticketAmountMeta);
    }
    if (data.containsKey('total_distance')) {
      context.handle(
        _totalDistanceMeta,
        totalDistance.isAcceptableOrUnknown(
          data['total_distance']!,
          _totalDistanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDistanceMeta);
    }
    if (data.containsKey('occupied_distance')) {
      context.handle(
        _occupiedDistanceMeta,
        occupiedDistance.isAcceptableOrUnknown(
          data['occupied_distance']!,
          _occupiedDistanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occupiedDistanceMeta);
    }
    if (data.containsKey('rides_count')) {
      context.handle(
        _ridesCountMeta,
        ridesCount.isAcceptableOrUnknown(data['rides_count']!, _ridesCountMeta),
      );
    } else if (isInserting) {
      context.missing(_ridesCountMeta);
    }
    if (data.containsKey('fuel_amount')) {
      context.handle(
        _fuelAmountMeta,
        fuelAmount.isAcceptableOrUnknown(data['fuel_amount']!, _fuelAmountMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Revenue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Revenue(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: $RevenuesTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      workSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_session_id'],
      ),
      grossRevenue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gross_revenue'],
      )!,
      taxExcludedRevenue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_excluded_revenue'],
      )!,
      cashAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_amount'],
      )!,
      cardAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_amount'],
      )!,
      appAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}app_amount'],
      )!,
      ticketAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ticket_amount'],
      )!,
      totalDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_distance'],
      )!,
      occupiedDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}occupied_distance'],
      )!,
      ridesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rides_count'],
      )!,
      fuelAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fuel_amount'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $RevenuesTable createAlias(String alias) {
    return $RevenuesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdate =
      const DateOnlyConverter();
}

class Revenue extends DataClass implements Insertable<Revenue> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final DateTime date;
  final int? workSessionId;
  final int grossRevenue;
  final int taxExcludedRevenue;
  final int cashAmount;
  final int cardAmount;
  final int appAmount;
  final int ticketAmount;
  final double totalDistance;
  final double occupiedDistance;
  final int ridesCount;
  final int? fuelAmount;
  final String? note;
  const Revenue({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.date,
    this.workSessionId,
    required this.grossRevenue,
    required this.taxExcludedRevenue,
    required this.cashAmount,
    required this.cardAmount,
    required this.appAmount,
    required this.ticketAmount,
    required this.totalDistance,
    required this.occupiedDistance,
    required this.ridesCount,
    this.fuelAmount,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    {
      map['date'] = Variable<String>($RevenuesTable.$converterdate.toSql(date));
    }
    if (!nullToAbsent || workSessionId != null) {
      map['work_session_id'] = Variable<int>(workSessionId);
    }
    map['gross_revenue'] = Variable<int>(grossRevenue);
    map['tax_excluded_revenue'] = Variable<int>(taxExcludedRevenue);
    map['cash_amount'] = Variable<int>(cashAmount);
    map['card_amount'] = Variable<int>(cardAmount);
    map['app_amount'] = Variable<int>(appAmount);
    map['ticket_amount'] = Variable<int>(ticketAmount);
    map['total_distance'] = Variable<double>(totalDistance);
    map['occupied_distance'] = Variable<double>(occupiedDistance);
    map['rides_count'] = Variable<int>(ridesCount);
    if (!nullToAbsent || fuelAmount != null) {
      map['fuel_amount'] = Variable<int>(fuelAmount);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  RevenuesCompanion toCompanion(bool nullToAbsent) {
    return RevenuesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      date: Value(date),
      workSessionId: workSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(workSessionId),
      grossRevenue: Value(grossRevenue),
      taxExcludedRevenue: Value(taxExcludedRevenue),
      cashAmount: Value(cashAmount),
      cardAmount: Value(cardAmount),
      appAmount: Value(appAmount),
      ticketAmount: Value(ticketAmount),
      totalDistance: Value(totalDistance),
      occupiedDistance: Value(occupiedDistance),
      ridesCount: Value(ridesCount),
      fuelAmount: fuelAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelAmount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Revenue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Revenue(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      workSessionId: serializer.fromJson<int?>(json['workSessionId']),
      grossRevenue: serializer.fromJson<int>(json['grossRevenue']),
      taxExcludedRevenue: serializer.fromJson<int>(json['taxExcludedRevenue']),
      cashAmount: serializer.fromJson<int>(json['cashAmount']),
      cardAmount: serializer.fromJson<int>(json['cardAmount']),
      appAmount: serializer.fromJson<int>(json['appAmount']),
      ticketAmount: serializer.fromJson<int>(json['ticketAmount']),
      totalDistance: serializer.fromJson<double>(json['totalDistance']),
      occupiedDistance: serializer.fromJson<double>(json['occupiedDistance']),
      ridesCount: serializer.fromJson<int>(json['ridesCount']),
      fuelAmount: serializer.fromJson<int?>(json['fuelAmount']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'workSessionId': serializer.toJson<int?>(workSessionId),
      'grossRevenue': serializer.toJson<int>(grossRevenue),
      'taxExcludedRevenue': serializer.toJson<int>(taxExcludedRevenue),
      'cashAmount': serializer.toJson<int>(cashAmount),
      'cardAmount': serializer.toJson<int>(cardAmount),
      'appAmount': serializer.toJson<int>(appAmount),
      'ticketAmount': serializer.toJson<int>(ticketAmount),
      'totalDistance': serializer.toJson<double>(totalDistance),
      'occupiedDistance': serializer.toJson<double>(occupiedDistance),
      'ridesCount': serializer.toJson<int>(ridesCount),
      'fuelAmount': serializer.toJson<int?>(fuelAmount),
      'note': serializer.toJson<String?>(note),
    };
  }

  Revenue copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    DateTime? date,
    Value<int?> workSessionId = const Value.absent(),
    int? grossRevenue,
    int? taxExcludedRevenue,
    int? cashAmount,
    int? cardAmount,
    int? appAmount,
    int? ticketAmount,
    double? totalDistance,
    double? occupiedDistance,
    int? ridesCount,
    Value<int?> fuelAmount = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Revenue(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    date: date ?? this.date,
    workSessionId: workSessionId.present
        ? workSessionId.value
        : this.workSessionId,
    grossRevenue: grossRevenue ?? this.grossRevenue,
    taxExcludedRevenue: taxExcludedRevenue ?? this.taxExcludedRevenue,
    cashAmount: cashAmount ?? this.cashAmount,
    cardAmount: cardAmount ?? this.cardAmount,
    appAmount: appAmount ?? this.appAmount,
    ticketAmount: ticketAmount ?? this.ticketAmount,
    totalDistance: totalDistance ?? this.totalDistance,
    occupiedDistance: occupiedDistance ?? this.occupiedDistance,
    ridesCount: ridesCount ?? this.ridesCount,
    fuelAmount: fuelAmount.present ? fuelAmount.value : this.fuelAmount,
    note: note.present ? note.value : this.note,
  );
  Revenue copyWithCompanion(RevenuesCompanion data) {
    return Revenue(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      workSessionId: data.workSessionId.present
          ? data.workSessionId.value
          : this.workSessionId,
      grossRevenue: data.grossRevenue.present
          ? data.grossRevenue.value
          : this.grossRevenue,
      taxExcludedRevenue: data.taxExcludedRevenue.present
          ? data.taxExcludedRevenue.value
          : this.taxExcludedRevenue,
      cashAmount: data.cashAmount.present
          ? data.cashAmount.value
          : this.cashAmount,
      cardAmount: data.cardAmount.present
          ? data.cardAmount.value
          : this.cardAmount,
      appAmount: data.appAmount.present ? data.appAmount.value : this.appAmount,
      ticketAmount: data.ticketAmount.present
          ? data.ticketAmount.value
          : this.ticketAmount,
      totalDistance: data.totalDistance.present
          ? data.totalDistance.value
          : this.totalDistance,
      occupiedDistance: data.occupiedDistance.present
          ? data.occupiedDistance.value
          : this.occupiedDistance,
      ridesCount: data.ridesCount.present
          ? data.ridesCount.value
          : this.ridesCount,
      fuelAmount: data.fuelAmount.present
          ? data.fuelAmount.value
          : this.fuelAmount,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Revenue(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('workSessionId: $workSessionId, ')
          ..write('grossRevenue: $grossRevenue, ')
          ..write('taxExcludedRevenue: $taxExcludedRevenue, ')
          ..write('cashAmount: $cashAmount, ')
          ..write('cardAmount: $cardAmount, ')
          ..write('appAmount: $appAmount, ')
          ..write('ticketAmount: $ticketAmount, ')
          ..write('totalDistance: $totalDistance, ')
          ..write('occupiedDistance: $occupiedDistance, ')
          ..write('ridesCount: $ridesCount, ')
          ..write('fuelAmount: $fuelAmount, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    id,
    date,
    workSessionId,
    grossRevenue,
    taxExcludedRevenue,
    cashAmount,
    cardAmount,
    appAmount,
    ticketAmount,
    totalDistance,
    occupiedDistance,
    ridesCount,
    fuelAmount,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Revenue &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.date == this.date &&
          other.workSessionId == this.workSessionId &&
          other.grossRevenue == this.grossRevenue &&
          other.taxExcludedRevenue == this.taxExcludedRevenue &&
          other.cashAmount == this.cashAmount &&
          other.cardAmount == this.cardAmount &&
          other.appAmount == this.appAmount &&
          other.ticketAmount == this.ticketAmount &&
          other.totalDistance == this.totalDistance &&
          other.occupiedDistance == this.occupiedDistance &&
          other.ridesCount == this.ridesCount &&
          other.fuelAmount == this.fuelAmount &&
          other.note == this.note);
}

class RevenuesCompanion extends UpdateCompanion<Revenue> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int?> workSessionId;
  final Value<int> grossRevenue;
  final Value<int> taxExcludedRevenue;
  final Value<int> cashAmount;
  final Value<int> cardAmount;
  final Value<int> appAmount;
  final Value<int> ticketAmount;
  final Value<double> totalDistance;
  final Value<double> occupiedDistance;
  final Value<int> ridesCount;
  final Value<int?> fuelAmount;
  final Value<String?> note;
  const RevenuesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.workSessionId = const Value.absent(),
    this.grossRevenue = const Value.absent(),
    this.taxExcludedRevenue = const Value.absent(),
    this.cashAmount = const Value.absent(),
    this.cardAmount = const Value.absent(),
    this.appAmount = const Value.absent(),
    this.ticketAmount = const Value.absent(),
    this.totalDistance = const Value.absent(),
    this.occupiedDistance = const Value.absent(),
    this.ridesCount = const Value.absent(),
    this.fuelAmount = const Value.absent(),
    this.note = const Value.absent(),
  });
  RevenuesCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required DateTime date,
    this.workSessionId = const Value.absent(),
    required int grossRevenue,
    required int taxExcludedRevenue,
    required int cashAmount,
    required int cardAmount,
    required int appAmount,
    required int ticketAmount,
    required double totalDistance,
    required double occupiedDistance,
    required int ridesCount,
    this.fuelAmount = const Value.absent(),
    this.note = const Value.absent(),
  }) : date = Value(date),
       grossRevenue = Value(grossRevenue),
       taxExcludedRevenue = Value(taxExcludedRevenue),
       cashAmount = Value(cashAmount),
       cardAmount = Value(cardAmount),
       appAmount = Value(appAmount),
       ticketAmount = Value(ticketAmount),
       totalDistance = Value(totalDistance),
       occupiedDistance = Value(occupiedDistance),
       ridesCount = Value(ridesCount);
  static Insertable<Revenue> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? workSessionId,
    Expression<int>? grossRevenue,
    Expression<int>? taxExcludedRevenue,
    Expression<int>? cashAmount,
    Expression<int>? cardAmount,
    Expression<int>? appAmount,
    Expression<int>? ticketAmount,
    Expression<double>? totalDistance,
    Expression<double>? occupiedDistance,
    Expression<int>? ridesCount,
    Expression<int>? fuelAmount,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (workSessionId != null) 'work_session_id': workSessionId,
      if (grossRevenue != null) 'gross_revenue': grossRevenue,
      if (taxExcludedRevenue != null)
        'tax_excluded_revenue': taxExcludedRevenue,
      if (cashAmount != null) 'cash_amount': cashAmount,
      if (cardAmount != null) 'card_amount': cardAmount,
      if (appAmount != null) 'app_amount': appAmount,
      if (ticketAmount != null) 'ticket_amount': ticketAmount,
      if (totalDistance != null) 'total_distance': totalDistance,
      if (occupiedDistance != null) 'occupied_distance': occupiedDistance,
      if (ridesCount != null) 'rides_count': ridesCount,
      if (fuelAmount != null) 'fuel_amount': fuelAmount,
      if (note != null) 'note': note,
    });
  }

  RevenuesCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<DateTime>? date,
    Value<int?>? workSessionId,
    Value<int>? grossRevenue,
    Value<int>? taxExcludedRevenue,
    Value<int>? cashAmount,
    Value<int>? cardAmount,
    Value<int>? appAmount,
    Value<int>? ticketAmount,
    Value<double>? totalDistance,
    Value<double>? occupiedDistance,
    Value<int>? ridesCount,
    Value<int?>? fuelAmount,
    Value<String?>? note,
  }) {
    return RevenuesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      date: date ?? this.date,
      workSessionId: workSessionId ?? this.workSessionId,
      grossRevenue: grossRevenue ?? this.grossRevenue,
      taxExcludedRevenue: taxExcludedRevenue ?? this.taxExcludedRevenue,
      cashAmount: cashAmount ?? this.cashAmount,
      cardAmount: cardAmount ?? this.cardAmount,
      appAmount: appAmount ?? this.appAmount,
      ticketAmount: ticketAmount ?? this.ticketAmount,
      totalDistance: totalDistance ?? this.totalDistance,
      occupiedDistance: occupiedDistance ?? this.occupiedDistance,
      ridesCount: ridesCount ?? this.ridesCount,
      fuelAmount: fuelAmount ?? this.fuelAmount,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $RevenuesTable.$converterdate.toSql(date.value),
      );
    }
    if (workSessionId.present) {
      map['work_session_id'] = Variable<int>(workSessionId.value);
    }
    if (grossRevenue.present) {
      map['gross_revenue'] = Variable<int>(grossRevenue.value);
    }
    if (taxExcludedRevenue.present) {
      map['tax_excluded_revenue'] = Variable<int>(taxExcludedRevenue.value);
    }
    if (cashAmount.present) {
      map['cash_amount'] = Variable<int>(cashAmount.value);
    }
    if (cardAmount.present) {
      map['card_amount'] = Variable<int>(cardAmount.value);
    }
    if (appAmount.present) {
      map['app_amount'] = Variable<int>(appAmount.value);
    }
    if (ticketAmount.present) {
      map['ticket_amount'] = Variable<int>(ticketAmount.value);
    }
    if (totalDistance.present) {
      map['total_distance'] = Variable<double>(totalDistance.value);
    }
    if (occupiedDistance.present) {
      map['occupied_distance'] = Variable<double>(occupiedDistance.value);
    }
    if (ridesCount.present) {
      map['rides_count'] = Variable<int>(ridesCount.value);
    }
    if (fuelAmount.present) {
      map['fuel_amount'] = Variable<int>(fuelAmount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RevenuesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('workSessionId: $workSessionId, ')
          ..write('grossRevenue: $grossRevenue, ')
          ..write('taxExcludedRevenue: $taxExcludedRevenue, ')
          ..write('cashAmount: $cashAmount, ')
          ..write('cardAmount: $cardAmount, ')
          ..write('appAmount: $appAmount, ')
          ..write('ticketAmount: $ticketAmount, ')
          ..write('totalDistance: $totalDistance, ')
          ..write('occupiedDistance: $occupiedDistance, ')
          ..write('ridesCount: $ridesCount, ')
          ..write('fuelAmount: $fuelAmount, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $WorkSessionsTable extends WorkSessions
    with TableInfo<$WorkSessionsTable, WorkSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      ).withConverter<DateTime>($WorkSessionsTable.$converterdate);
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    date,
    startTime,
    endTime,
    breakMinutes,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_breakMinutesMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkSession(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: $WorkSessionsTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $WorkSessionsTable createAlias(String alias) {
    return $WorkSessionsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdate =
      const DateOnlyConverter();
}

class WorkSession extends DataClass implements Insertable<WorkSession> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final int breakMinutes;
  final String? note;
  const WorkSession({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    {
      map['date'] = Variable<String>(
        $WorkSessionsTable.$converterdate.toSql(date),
      );
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['break_minutes'] = Variable<int>(breakMinutes);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WorkSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkSessionsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      date: Value(date),
      startTime: Value(startTime),
      endTime: Value(endTime),
      breakMinutes: Value(breakMinutes),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WorkSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkSession(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'note': serializer.toJson<String?>(note),
    };
  }

  WorkSession copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    int? breakMinutes,
    Value<String?> note = const Value.absent(),
  }) => WorkSession(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    date: date ?? this.date,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    note: note.present ? note.value : this.note,
  );
  WorkSession copyWithCompanion(WorkSessionsCompanion data) {
    return WorkSession(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkSession(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    id,
    date,
    startTime,
    endTime,
    breakMinutes,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkSession &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.breakMinutes == this.breakMinutes &&
          other.note == this.note);
}

class WorkSessionsCompanion extends UpdateCompanion<WorkSession> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> breakMinutes;
  final Value<String?> note;
  const WorkSessionsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.note = const Value.absent(),
  });
  WorkSessionsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required int breakMinutes,
    this.note = const Value.absent(),
  }) : date = Value(date),
       startTime = Value(startTime),
       endTime = Value(endTime),
       breakMinutes = Value(breakMinutes);
  static Insertable<WorkSession> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? date,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? breakMinutes,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (note != null) 'note': note,
    });
  }

  WorkSessionsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? breakMinutes,
    Value<String?>? note,
  }) {
    return WorkSessionsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $WorkSessionsTable.$converterdate.toSql(date.value),
      );
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkSessionsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _monthlyClosingDayMeta = const VerificationMeta(
    'monthlyClosingDay',
  );
  @override
  late final GeneratedColumn<int> monthlyClosingDay = GeneratedColumn<int>(
    'monthly_closing_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _ashikiriAmountMeta = const VerificationMeta(
    'ashikiriAmount',
  );
  @override
  late final GeneratedColumn<int> ashikiriAmount = GeneratedColumn<int>(
    'ashikiri_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commissionRateMeta = const VerificationMeta(
    'commissionRate',
  );
  @override
  late final GeneratedColumn<double> commissionRate = GeneratedColumn<double>(
    'commission_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _improvementStandardEnabledMeta =
      const VerificationMeta('improvementStandardEnabled');
  @override
  late final GeneratedColumn<bool> improvementStandardEnabled =
      GeneratedColumn<bool>(
        'improvement_standard_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("improvement_standard_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _maxMonthlyRestraintHoursMeta =
      const VerificationMeta('maxMonthlyRestraintHours');
  @override
  late final GeneratedColumn<int> maxMonthlyRestraintHours =
      GeneratedColumn<int>(
        'max_monthly_restraint_hours',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(262),
      );
  static const VerificationMeta _maxMonthlyShiftsMeta = const VerificationMeta(
    'maxMonthlyShifts',
  );
  @override
  late final GeneratedColumn<int> maxMonthlyShifts = GeneratedColumn<int>(
    'max_monthly_shifts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(13),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPremiumMeta = const VerificationMeta(
    'isPremium',
  );
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
    'is_premium',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium" IN (0, 1))',
    ),
  );
  static const VerificationMeta _customLabelsMeta = const VerificationMeta(
    'customLabels',
  );
  @override
  late final GeneratedColumn<String> customLabels = GeneratedColumn<String>(
    'custom_labels',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    monthlyClosingDay,
    ashikiriAmount,
    commissionRate,
    improvementStandardEnabled,
    maxMonthlyRestraintHours,
    maxMonthlyShifts,
    themeMode,
    isPremium,
    customLabels,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monthly_closing_day')) {
      context.handle(
        _monthlyClosingDayMeta,
        monthlyClosingDay.isAcceptableOrUnknown(
          data['monthly_closing_day']!,
          _monthlyClosingDayMeta,
        ),
      );
    }
    if (data.containsKey('ashikiri_amount')) {
      context.handle(
        _ashikiriAmountMeta,
        ashikiriAmount.isAcceptableOrUnknown(
          data['ashikiri_amount']!,
          _ashikiriAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ashikiriAmountMeta);
    }
    if (data.containsKey('commission_rate')) {
      context.handle(
        _commissionRateMeta,
        commissionRate.isAcceptableOrUnknown(
          data['commission_rate']!,
          _commissionRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commissionRateMeta);
    }
    if (data.containsKey('improvement_standard_enabled')) {
      context.handle(
        _improvementStandardEnabledMeta,
        improvementStandardEnabled.isAcceptableOrUnknown(
          data['improvement_standard_enabled']!,
          _improvementStandardEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_improvementStandardEnabledMeta);
    }
    if (data.containsKey('max_monthly_restraint_hours')) {
      context.handle(
        _maxMonthlyRestraintHoursMeta,
        maxMonthlyRestraintHours.isAcceptableOrUnknown(
          data['max_monthly_restraint_hours']!,
          _maxMonthlyRestraintHoursMeta,
        ),
      );
    }
    if (data.containsKey('max_monthly_shifts')) {
      context.handle(
        _maxMonthlyShiftsMeta,
        maxMonthlyShifts.isAcceptableOrUnknown(
          data['max_monthly_shifts']!,
          _maxMonthlyShiftsMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('is_premium')) {
      context.handle(
        _isPremiumMeta,
        isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta),
      );
    } else if (isInserting) {
      context.missing(_isPremiumMeta);
    }
    if (data.containsKey('custom_labels')) {
      context.handle(
        _customLabelsMeta,
        customLabels.isAcceptableOrUnknown(
          data['custom_labels']!,
          _customLabelsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customLabelsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      monthlyClosingDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_closing_day'],
      )!,
      ashikiriAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ashikiri_amount'],
      )!,
      commissionRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}commission_rate'],
      )!,
      improvementStandardEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}improvement_standard_enabled'],
      )!,
      maxMonthlyRestraintHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_monthly_restraint_hours'],
      )!,
      maxMonthlyShifts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_monthly_shifts'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      isPremium: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premium'],
      )!,
      customLabels: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_labels'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final int monthlyClosingDay;
  final int ashikiriAmount;
  final double commissionRate;
  final bool improvementStandardEnabled;
  final int maxMonthlyRestraintHours;
  final int maxMonthlyShifts;
  final String themeMode;
  final bool isPremium;
  final String customLabels;
  const AppSetting({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.monthlyClosingDay,
    required this.ashikiriAmount,
    required this.commissionRate,
    required this.improvementStandardEnabled,
    required this.maxMonthlyRestraintHours,
    required this.maxMonthlyShifts,
    required this.themeMode,
    required this.isPremium,
    required this.customLabels,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['monthly_closing_day'] = Variable<int>(monthlyClosingDay);
    map['ashikiri_amount'] = Variable<int>(ashikiriAmount);
    map['commission_rate'] = Variable<double>(commissionRate);
    map['improvement_standard_enabled'] = Variable<bool>(
      improvementStandardEnabled,
    );
    map['max_monthly_restraint_hours'] = Variable<int>(
      maxMonthlyRestraintHours,
    );
    map['max_monthly_shifts'] = Variable<int>(maxMonthlyShifts);
    map['theme_mode'] = Variable<String>(themeMode);
    map['is_premium'] = Variable<bool>(isPremium);
    map['custom_labels'] = Variable<String>(customLabels);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      monthlyClosingDay: Value(monthlyClosingDay),
      ashikiriAmount: Value(ashikiriAmount),
      commissionRate: Value(commissionRate),
      improvementStandardEnabled: Value(improvementStandardEnabled),
      maxMonthlyRestraintHours: Value(maxMonthlyRestraintHours),
      maxMonthlyShifts: Value(maxMonthlyShifts),
      themeMode: Value(themeMode),
      isPremium: Value(isPremium),
      customLabels: Value(customLabels),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      monthlyClosingDay: serializer.fromJson<int>(json['monthlyClosingDay']),
      ashikiriAmount: serializer.fromJson<int>(json['ashikiriAmount']),
      commissionRate: serializer.fromJson<double>(json['commissionRate']),
      improvementStandardEnabled: serializer.fromJson<bool>(
        json['improvementStandardEnabled'],
      ),
      maxMonthlyRestraintHours: serializer.fromJson<int>(
        json['maxMonthlyRestraintHours'],
      ),
      maxMonthlyShifts: serializer.fromJson<int>(json['maxMonthlyShifts']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      customLabels: serializer.fromJson<String>(json['customLabels']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'monthlyClosingDay': serializer.toJson<int>(monthlyClosingDay),
      'ashikiriAmount': serializer.toJson<int>(ashikiriAmount),
      'commissionRate': serializer.toJson<double>(commissionRate),
      'improvementStandardEnabled': serializer.toJson<bool>(
        improvementStandardEnabled,
      ),
      'maxMonthlyRestraintHours': serializer.toJson<int>(
        maxMonthlyRestraintHours,
      ),
      'maxMonthlyShifts': serializer.toJson<int>(maxMonthlyShifts),
      'themeMode': serializer.toJson<String>(themeMode),
      'isPremium': serializer.toJson<bool>(isPremium),
      'customLabels': serializer.toJson<String>(customLabels),
    };
  }

  AppSetting copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    int? monthlyClosingDay,
    int? ashikiriAmount,
    double? commissionRate,
    bool? improvementStandardEnabled,
    int? maxMonthlyRestraintHours,
    int? maxMonthlyShifts,
    String? themeMode,
    bool? isPremium,
    String? customLabels,
  }) => AppSetting(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    monthlyClosingDay: monthlyClosingDay ?? this.monthlyClosingDay,
    ashikiriAmount: ashikiriAmount ?? this.ashikiriAmount,
    commissionRate: commissionRate ?? this.commissionRate,
    improvementStandardEnabled:
        improvementStandardEnabled ?? this.improvementStandardEnabled,
    maxMonthlyRestraintHours:
        maxMonthlyRestraintHours ?? this.maxMonthlyRestraintHours,
    maxMonthlyShifts: maxMonthlyShifts ?? this.maxMonthlyShifts,
    themeMode: themeMode ?? this.themeMode,
    isPremium: isPremium ?? this.isPremium,
    customLabels: customLabels ?? this.customLabels,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      monthlyClosingDay: data.monthlyClosingDay.present
          ? data.monthlyClosingDay.value
          : this.monthlyClosingDay,
      ashikiriAmount: data.ashikiriAmount.present
          ? data.ashikiriAmount.value
          : this.ashikiriAmount,
      commissionRate: data.commissionRate.present
          ? data.commissionRate.value
          : this.commissionRate,
      improvementStandardEnabled: data.improvementStandardEnabled.present
          ? data.improvementStandardEnabled.value
          : this.improvementStandardEnabled,
      maxMonthlyRestraintHours: data.maxMonthlyRestraintHours.present
          ? data.maxMonthlyRestraintHours.value
          : this.maxMonthlyRestraintHours,
      maxMonthlyShifts: data.maxMonthlyShifts.present
          ? data.maxMonthlyShifts.value
          : this.maxMonthlyShifts,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      customLabels: data.customLabels.present
          ? data.customLabels.value
          : this.customLabels,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('monthlyClosingDay: $monthlyClosingDay, ')
          ..write('ashikiriAmount: $ashikiriAmount, ')
          ..write('commissionRate: $commissionRate, ')
          ..write('improvementStandardEnabled: $improvementStandardEnabled, ')
          ..write('maxMonthlyRestraintHours: $maxMonthlyRestraintHours, ')
          ..write('maxMonthlyShifts: $maxMonthlyShifts, ')
          ..write('themeMode: $themeMode, ')
          ..write('isPremium: $isPremium, ')
          ..write('customLabels: $customLabels')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    id,
    monthlyClosingDay,
    ashikiriAmount,
    commissionRate,
    improvementStandardEnabled,
    maxMonthlyRestraintHours,
    maxMonthlyShifts,
    themeMode,
    isPremium,
    customLabels,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.monthlyClosingDay == this.monthlyClosingDay &&
          other.ashikiriAmount == this.ashikiriAmount &&
          other.commissionRate == this.commissionRate &&
          other.improvementStandardEnabled == this.improvementStandardEnabled &&
          other.maxMonthlyRestraintHours == this.maxMonthlyRestraintHours &&
          other.maxMonthlyShifts == this.maxMonthlyShifts &&
          other.themeMode == this.themeMode &&
          other.isPremium == this.isPremium &&
          other.customLabels == this.customLabels);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<int> monthlyClosingDay;
  final Value<int> ashikiriAmount;
  final Value<double> commissionRate;
  final Value<bool> improvementStandardEnabled;
  final Value<int> maxMonthlyRestraintHours;
  final Value<int> maxMonthlyShifts;
  final Value<String> themeMode;
  final Value<bool> isPremium;
  final Value<String> customLabels;
  const AppSettingsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.monthlyClosingDay = const Value.absent(),
    this.ashikiriAmount = const Value.absent(),
    this.commissionRate = const Value.absent(),
    this.improvementStandardEnabled = const Value.absent(),
    this.maxMonthlyRestraintHours = const Value.absent(),
    this.maxMonthlyShifts = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.customLabels = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.monthlyClosingDay = const Value.absent(),
    required int ashikiriAmount,
    required double commissionRate,
    required bool improvementStandardEnabled,
    this.maxMonthlyRestraintHours = const Value.absent(),
    this.maxMonthlyShifts = const Value.absent(),
    required String themeMode,
    required bool isPremium,
    required String customLabels,
  }) : ashikiriAmount = Value(ashikiriAmount),
       commissionRate = Value(commissionRate),
       improvementStandardEnabled = Value(improvementStandardEnabled),
       themeMode = Value(themeMode),
       isPremium = Value(isPremium),
       customLabels = Value(customLabels);
  static Insertable<AppSetting> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<int>? monthlyClosingDay,
    Expression<int>? ashikiriAmount,
    Expression<double>? commissionRate,
    Expression<bool>? improvementStandardEnabled,
    Expression<int>? maxMonthlyRestraintHours,
    Expression<int>? maxMonthlyShifts,
    Expression<String>? themeMode,
    Expression<bool>? isPremium,
    Expression<String>? customLabels,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (monthlyClosingDay != null) 'monthly_closing_day': monthlyClosingDay,
      if (ashikiriAmount != null) 'ashikiri_amount': ashikiriAmount,
      if (commissionRate != null) 'commission_rate': commissionRate,
      if (improvementStandardEnabled != null)
        'improvement_standard_enabled': improvementStandardEnabled,
      if (maxMonthlyRestraintHours != null)
        'max_monthly_restraint_hours': maxMonthlyRestraintHours,
      if (maxMonthlyShifts != null) 'max_monthly_shifts': maxMonthlyShifts,
      if (themeMode != null) 'theme_mode': themeMode,
      if (isPremium != null) 'is_premium': isPremium,
      if (customLabels != null) 'custom_labels': customLabels,
    });
  }

  AppSettingsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<int>? monthlyClosingDay,
    Value<int>? ashikiriAmount,
    Value<double>? commissionRate,
    Value<bool>? improvementStandardEnabled,
    Value<int>? maxMonthlyRestraintHours,
    Value<int>? maxMonthlyShifts,
    Value<String>? themeMode,
    Value<bool>? isPremium,
    Value<String>? customLabels,
  }) {
    return AppSettingsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      monthlyClosingDay: monthlyClosingDay ?? this.monthlyClosingDay,
      ashikiriAmount: ashikiriAmount ?? this.ashikiriAmount,
      commissionRate: commissionRate ?? this.commissionRate,
      improvementStandardEnabled:
          improvementStandardEnabled ?? this.improvementStandardEnabled,
      maxMonthlyRestraintHours:
          maxMonthlyRestraintHours ?? this.maxMonthlyRestraintHours,
      maxMonthlyShifts: maxMonthlyShifts ?? this.maxMonthlyShifts,
      themeMode: themeMode ?? this.themeMode,
      isPremium: isPremium ?? this.isPremium,
      customLabels: customLabels ?? this.customLabels,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthlyClosingDay.present) {
      map['monthly_closing_day'] = Variable<int>(monthlyClosingDay.value);
    }
    if (ashikiriAmount.present) {
      map['ashikiri_amount'] = Variable<int>(ashikiriAmount.value);
    }
    if (commissionRate.present) {
      map['commission_rate'] = Variable<double>(commissionRate.value);
    }
    if (improvementStandardEnabled.present) {
      map['improvement_standard_enabled'] = Variable<bool>(
        improvementStandardEnabled.value,
      );
    }
    if (maxMonthlyRestraintHours.present) {
      map['max_monthly_restraint_hours'] = Variable<int>(
        maxMonthlyRestraintHours.value,
      );
    }
    if (maxMonthlyShifts.present) {
      map['max_monthly_shifts'] = Variable<int>(maxMonthlyShifts.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (customLabels.present) {
      map['custom_labels'] = Variable<String>(customLabels.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('monthlyClosingDay: $monthlyClosingDay, ')
          ..write('ashikiriAmount: $ashikiriAmount, ')
          ..write('commissionRate: $commissionRate, ')
          ..write('improvementStandardEnabled: $improvementStandardEnabled, ')
          ..write('maxMonthlyRestraintHours: $maxMonthlyRestraintHours, ')
          ..write('maxMonthlyShifts: $maxMonthlyShifts, ')
          ..write('themeMode: $themeMode, ')
          ..write('isPremium: $isPremium, ')
          ..write('customLabels: $customLabels')
          ..write(')'))
        .toString();
  }
}

class $PresetsTable extends Presets with TableInfo<$PresetsTable, Preset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workStyleMeta = const VerificationMeta(
    'workStyle',
  );
  @override
  late final GeneratedColumn<String> workStyle = GeneratedColumn<String>(
    'work_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleMeta = const VerificationMeta('cycle');
  @override
  late final GeneratedColumn<String> cycle = GeneratedColumn<String>(
    'cycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltinMeta = const VerificationMeta(
    'isBuiltin',
  );
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
    'is_builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, workStyle, cycle, isBuiltin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('work_style')) {
      context.handle(
        _workStyleMeta,
        workStyle.isAcceptableOrUnknown(data['work_style']!, _workStyleMeta),
      );
    } else if (isInserting) {
      context.missing(_workStyleMeta);
    }
    if (data.containsKey('cycle')) {
      context.handle(
        _cycleMeta,
        cycle.isAcceptableOrUnknown(data['cycle']!, _cycleMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleMeta);
    }
    if (data.containsKey('is_builtin')) {
      context.handle(
        _isBuiltinMeta,
        isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      workStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_style'],
      )!,
      cycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle'],
      )!,
      isBuiltin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_builtin'],
      )!,
    );
  }

  @override
  $PresetsTable createAlias(String alias) {
    return $PresetsTable(attachedDatabase, alias);
  }
}

class Preset extends DataClass implements Insertable<Preset> {
  final int id;
  final String name;
  final String workStyle;
  final String cycle;
  final bool isBuiltin;
  const Preset({
    required this.id,
    required this.name,
    required this.workStyle,
    required this.cycle,
    required this.isBuiltin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['work_style'] = Variable<String>(workStyle);
    map['cycle'] = Variable<String>(cycle);
    map['is_builtin'] = Variable<bool>(isBuiltin);
    return map;
  }

  PresetsCompanion toCompanion(bool nullToAbsent) {
    return PresetsCompanion(
      id: Value(id),
      name: Value(name),
      workStyle: Value(workStyle),
      cycle: Value(cycle),
      isBuiltin: Value(isBuiltin),
    );
  }

  factory Preset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preset(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      workStyle: serializer.fromJson<String>(json['workStyle']),
      cycle: serializer.fromJson<String>(json['cycle']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'workStyle': serializer.toJson<String>(workStyle),
      'cycle': serializer.toJson<String>(cycle),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
    };
  }

  Preset copyWith({
    int? id,
    String? name,
    String? workStyle,
    String? cycle,
    bool? isBuiltin,
  }) => Preset(
    id: id ?? this.id,
    name: name ?? this.name,
    workStyle: workStyle ?? this.workStyle,
    cycle: cycle ?? this.cycle,
    isBuiltin: isBuiltin ?? this.isBuiltin,
  );
  Preset copyWithCompanion(PresetsCompanion data) {
    return Preset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      workStyle: data.workStyle.present ? data.workStyle.value : this.workStyle,
      cycle: data.cycle.present ? data.cycle.value : this.cycle,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workStyle: $workStyle, ')
          ..write('cycle: $cycle, ')
          ..write('isBuiltin: $isBuiltin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, workStyle, cycle, isBuiltin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preset &&
          other.id == this.id &&
          other.name == this.name &&
          other.workStyle == this.workStyle &&
          other.cycle == this.cycle &&
          other.isBuiltin == this.isBuiltin);
}

class PresetsCompanion extends UpdateCompanion<Preset> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> workStyle;
  final Value<String> cycle;
  final Value<bool> isBuiltin;
  const PresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.workStyle = const Value.absent(),
    this.cycle = const Value.absent(),
    this.isBuiltin = const Value.absent(),
  });
  PresetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String workStyle,
    required String cycle,
    this.isBuiltin = const Value.absent(),
  }) : name = Value(name),
       workStyle = Value(workStyle),
       cycle = Value(cycle);
  static Insertable<Preset> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? workStyle,
    Expression<String>? cycle,
    Expression<bool>? isBuiltin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (workStyle != null) 'work_style': workStyle,
      if (cycle != null) 'cycle': cycle,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
    });
  }

  PresetsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? workStyle,
    Value<String>? cycle,
    Value<bool>? isBuiltin,
  }) {
    return PresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      workStyle: workStyle ?? this.workStyle,
      cycle: cycle ?? this.cycle,
      isBuiltin: isBuiltin ?? this.isBuiltin,
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
    if (workStyle.present) {
      map['work_style'] = Variable<String>(workStyle.value);
    }
    if (cycle.present) {
      map['cycle'] = Variable<String>(cycle.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workStyle: $workStyle, ')
          ..write('cycle: $cycle, ')
          ..write('isBuiltin: $isBuiltin')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShiftPatternsTable shiftPatterns = $ShiftPatternsTable(this);
  late final $ShiftOverridesTable shiftOverrides = $ShiftOverridesTable(this);
  late final $RevenuesTable revenues = $RevenuesTable(this);
  late final $WorkSessionsTable workSessions = $WorkSessionsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $PresetsTable presets = $PresetsTable(this);
  late final AppSettingsDao appSettingsDao = AppSettingsDao(
    this as AppDatabase,
  );
  late final ShiftPatternsDao shiftPatternsDao = ShiftPatternsDao(
    this as AppDatabase,
  );
  late final ShiftOverridesDao shiftOverridesDao = ShiftOverridesDao(
    this as AppDatabase,
  );
  late final WorkSessionsDao workSessionsDao = WorkSessionsDao(
    this as AppDatabase,
  );
  late final RevenuesDao revenuesDao = RevenuesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shiftPatterns,
    shiftOverrides,
    revenues,
    workSessions,
    appSettings,
    presets,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shift_overrides',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shift_overrides', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ShiftPatternsTableCreateCompanionBuilder =
    ShiftPatternsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      required String name,
      required String workStyle,
      required String cycle,
      required DateTime startDate,
      required DateTime validFrom,
      Value<DateTime?> validUntil,
      required bool isActive,
    });
typedef $$ShiftPatternsTableUpdateCompanionBuilder =
    ShiftPatternsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<String> name,
      Value<String> workStyle,
      Value<String> cycle,
      Value<DateTime> startDate,
      Value<DateTime> validFrom,
      Value<DateTime?> validUntil,
      Value<bool> isActive,
    });

class $$ShiftPatternsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftPatternsTable> {
  $$ShiftPatternsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workStyle => $composableBuilder(
    column: $table.workStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get startDate =>
      $composableBuilder(
        column: $table.startDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get validFrom =>
      $composableBuilder(
        column: $table.validFrom,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get validUntil =>
      $composableBuilder(
        column: $table.validUntil,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftPatternsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftPatternsTable> {
  $$ShiftPatternsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workStyle => $composableBuilder(
    column: $table.workStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftPatternsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftPatternsTable> {
  $$ShiftPatternsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get workStyle =>
      $composableBuilder(column: $table.workStyle, builder: (column) => column);

  GeneratedColumn<String> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get validUntil =>
      $composableBuilder(
        column: $table.validUntil,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ShiftPatternsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftPatternsTable,
          ShiftPattern,
          $$ShiftPatternsTableFilterComposer,
          $$ShiftPatternsTableOrderingComposer,
          $$ShiftPatternsTableAnnotationComposer,
          $$ShiftPatternsTableCreateCompanionBuilder,
          $$ShiftPatternsTableUpdateCompanionBuilder,
          (
            ShiftPattern,
            BaseReferences<_$AppDatabase, $ShiftPatternsTable, ShiftPattern>,
          ),
          ShiftPattern,
          PrefetchHooks Function()
        > {
  $$ShiftPatternsTableTableManager(_$AppDatabase db, $ShiftPatternsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftPatternsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftPatternsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftPatternsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> workStyle = const Value.absent(),
                Value<String> cycle = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> validFrom = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ShiftPatternsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                workStyle: workStyle,
                cycle: cycle,
                startDate: startDate,
                validFrom: validFrom,
                validUntil: validUntil,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                required String workStyle,
                required String cycle,
                required DateTime startDate,
                required DateTime validFrom,
                Value<DateTime?> validUntil = const Value.absent(),
                required bool isActive,
              }) => ShiftPatternsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                workStyle: workStyle,
                cycle: cycle,
                startDate: startDate,
                validFrom: validFrom,
                validUntil: validUntil,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftPatternsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftPatternsTable,
      ShiftPattern,
      $$ShiftPatternsTableFilterComposer,
      $$ShiftPatternsTableOrderingComposer,
      $$ShiftPatternsTableAnnotationComposer,
      $$ShiftPatternsTableCreateCompanionBuilder,
      $$ShiftPatternsTableUpdateCompanionBuilder,
      (
        ShiftPattern,
        BaseReferences<_$AppDatabase, $ShiftPatternsTable, ShiftPattern>,
      ),
      ShiftPattern,
      PrefetchHooks Function()
    >;
typedef $$ShiftOverridesTableCreateCompanionBuilder =
    ShiftOverridesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      required DateTime date,
      required String shiftType,
      required String status,
      Value<String?> reason,
      Value<int?> pairedOverrideId,
    });
typedef $$ShiftOverridesTableUpdateCompanionBuilder =
    ShiftOverridesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<DateTime> date,
      Value<String> shiftType,
      Value<String> status,
      Value<String?> reason,
      Value<int?> pairedOverrideId,
    });

final class $$ShiftOverridesTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftOverridesTable, ShiftOverride> {
  $$ShiftOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftOverridesTable _pairedOverrideIdTable(_$AppDatabase db) =>
      db.shiftOverrides.createAlias(
        $_aliasNameGenerator(
          db.shiftOverrides.pairedOverrideId,
          db.shiftOverrides.id,
        ),
      );

  $$ShiftOverridesTableProcessedTableManager? get pairedOverrideId {
    final $_column = $_itemColumn<int>('paired_override_id');
    if ($_column == null) return null;
    final manager = $$ShiftOverridesTableTableManager(
      $_db,
      $_db.shiftOverrides,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pairedOverrideIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftOverridesTable> {
  $$ShiftOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get shiftType => $composableBuilder(
    column: $table.shiftType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftOverridesTableFilterComposer get pairedOverrideId {
    final $$ShiftOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pairedOverrideId,
      referencedTable: $db.shiftOverrides,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftOverridesTableFilterComposer(
            $db: $db,
            $table: $db.shiftOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftOverridesTable> {
  $$ShiftOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftType => $composableBuilder(
    column: $table.shiftType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftOverridesTableOrderingComposer get pairedOverrideId {
    final $$ShiftOverridesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pairedOverrideId,
      referencedTable: $db.shiftOverrides,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftOverridesTableOrderingComposer(
            $db: $db,
            $table: $db.shiftOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftOverridesTable> {
  $$ShiftOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get shiftType =>
      $composableBuilder(column: $table.shiftType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  $$ShiftOverridesTableAnnotationComposer get pairedOverrideId {
    final $$ShiftOverridesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pairedOverrideId,
      referencedTable: $db.shiftOverrides,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftOverridesTableAnnotationComposer(
            $db: $db,
            $table: $db.shiftOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftOverridesTable,
          ShiftOverride,
          $$ShiftOverridesTableFilterComposer,
          $$ShiftOverridesTableOrderingComposer,
          $$ShiftOverridesTableAnnotationComposer,
          $$ShiftOverridesTableCreateCompanionBuilder,
          $$ShiftOverridesTableUpdateCompanionBuilder,
          (ShiftOverride, $$ShiftOverridesTableReferences),
          ShiftOverride,
          PrefetchHooks Function({bool pairedOverrideId})
        > {
  $$ShiftOverridesTableTableManager(
    _$AppDatabase db,
    $ShiftOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> shiftType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int?> pairedOverrideId = const Value.absent(),
              }) => ShiftOverridesCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                date: date,
                shiftType: shiftType,
                status: status,
                reason: reason,
                pairedOverrideId: pairedOverrideId,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String shiftType,
                required String status,
                Value<String?> reason = const Value.absent(),
                Value<int?> pairedOverrideId = const Value.absent(),
              }) => ShiftOverridesCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                date: date,
                shiftType: shiftType,
                status: status,
                reason: reason,
                pairedOverrideId: pairedOverrideId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pairedOverrideId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pairedOverrideId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pairedOverrideId,
                                referencedTable: $$ShiftOverridesTableReferences
                                    ._pairedOverrideIdTable(db),
                                referencedColumn:
                                    $$ShiftOverridesTableReferences
                                        ._pairedOverrideIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShiftOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftOverridesTable,
      ShiftOverride,
      $$ShiftOverridesTableFilterComposer,
      $$ShiftOverridesTableOrderingComposer,
      $$ShiftOverridesTableAnnotationComposer,
      $$ShiftOverridesTableCreateCompanionBuilder,
      $$ShiftOverridesTableUpdateCompanionBuilder,
      (ShiftOverride, $$ShiftOverridesTableReferences),
      ShiftOverride,
      PrefetchHooks Function({bool pairedOverrideId})
    >;
typedef $$RevenuesTableCreateCompanionBuilder =
    RevenuesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      required DateTime date,
      Value<int?> workSessionId,
      required int grossRevenue,
      required int taxExcludedRevenue,
      required int cashAmount,
      required int cardAmount,
      required int appAmount,
      required int ticketAmount,
      required double totalDistance,
      required double occupiedDistance,
      required int ridesCount,
      Value<int?> fuelAmount,
      Value<String?> note,
    });
typedef $$RevenuesTableUpdateCompanionBuilder =
    RevenuesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<DateTime> date,
      Value<int?> workSessionId,
      Value<int> grossRevenue,
      Value<int> taxExcludedRevenue,
      Value<int> cashAmount,
      Value<int> cardAmount,
      Value<int> appAmount,
      Value<int> ticketAmount,
      Value<double> totalDistance,
      Value<double> occupiedDistance,
      Value<int> ridesCount,
      Value<int?> fuelAmount,
      Value<String?> note,
    });

class $$RevenuesTableFilterComposer
    extends Composer<_$AppDatabase, $RevenuesTable> {
  $$RevenuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get workSessionId => $composableBuilder(
    column: $table.workSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grossRevenue => $composableBuilder(
    column: $table.grossRevenue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxExcludedRevenue => $composableBuilder(
    column: $table.taxExcludedRevenue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashAmount => $composableBuilder(
    column: $table.cashAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardAmount => $composableBuilder(
    column: $table.cardAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get appAmount => $composableBuilder(
    column: $table.appAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ticketAmount => $composableBuilder(
    column: $table.ticketAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDistance => $composableBuilder(
    column: $table.totalDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get occupiedDistance => $composableBuilder(
    column: $table.occupiedDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ridesCount => $composableBuilder(
    column: $table.ridesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RevenuesTableOrderingComposer
    extends Composer<_$AppDatabase, $RevenuesTable> {
  $$RevenuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workSessionId => $composableBuilder(
    column: $table.workSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grossRevenue => $composableBuilder(
    column: $table.grossRevenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxExcludedRevenue => $composableBuilder(
    column: $table.taxExcludedRevenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashAmount => $composableBuilder(
    column: $table.cashAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardAmount => $composableBuilder(
    column: $table.cardAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get appAmount => $composableBuilder(
    column: $table.appAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ticketAmount => $composableBuilder(
    column: $table.ticketAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDistance => $composableBuilder(
    column: $table.totalDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get occupiedDistance => $composableBuilder(
    column: $table.occupiedDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ridesCount => $composableBuilder(
    column: $table.ridesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RevenuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RevenuesTable> {
  $$RevenuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get workSessionId => $composableBuilder(
    column: $table.workSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grossRevenue => $composableBuilder(
    column: $table.grossRevenue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxExcludedRevenue => $composableBuilder(
    column: $table.taxExcludedRevenue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cashAmount => $composableBuilder(
    column: $table.cashAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cardAmount => $composableBuilder(
    column: $table.cardAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get appAmount =>
      $composableBuilder(column: $table.appAmount, builder: (column) => column);

  GeneratedColumn<int> get ticketAmount => $composableBuilder(
    column: $table.ticketAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalDistance => $composableBuilder(
    column: $table.totalDistance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get occupiedDistance => $composableBuilder(
    column: $table.occupiedDistance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ridesCount => $composableBuilder(
    column: $table.ridesCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$RevenuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RevenuesTable,
          Revenue,
          $$RevenuesTableFilterComposer,
          $$RevenuesTableOrderingComposer,
          $$RevenuesTableAnnotationComposer,
          $$RevenuesTableCreateCompanionBuilder,
          $$RevenuesTableUpdateCompanionBuilder,
          (Revenue, BaseReferences<_$AppDatabase, $RevenuesTable, Revenue>),
          Revenue,
          PrefetchHooks Function()
        > {
  $$RevenuesTableTableManager(_$AppDatabase db, $RevenuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RevenuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RevenuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RevenuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> workSessionId = const Value.absent(),
                Value<int> grossRevenue = const Value.absent(),
                Value<int> taxExcludedRevenue = const Value.absent(),
                Value<int> cashAmount = const Value.absent(),
                Value<int> cardAmount = const Value.absent(),
                Value<int> appAmount = const Value.absent(),
                Value<int> ticketAmount = const Value.absent(),
                Value<double> totalDistance = const Value.absent(),
                Value<double> occupiedDistance = const Value.absent(),
                Value<int> ridesCount = const Value.absent(),
                Value<int?> fuelAmount = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => RevenuesCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                date: date,
                workSessionId: workSessionId,
                grossRevenue: grossRevenue,
                taxExcludedRevenue: taxExcludedRevenue,
                cashAmount: cashAmount,
                cardAmount: cardAmount,
                appAmount: appAmount,
                ticketAmount: ticketAmount,
                totalDistance: totalDistance,
                occupiedDistance: occupiedDistance,
                ridesCount: ridesCount,
                fuelAmount: fuelAmount,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int?> workSessionId = const Value.absent(),
                required int grossRevenue,
                required int taxExcludedRevenue,
                required int cashAmount,
                required int cardAmount,
                required int appAmount,
                required int ticketAmount,
                required double totalDistance,
                required double occupiedDistance,
                required int ridesCount,
                Value<int?> fuelAmount = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => RevenuesCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                date: date,
                workSessionId: workSessionId,
                grossRevenue: grossRevenue,
                taxExcludedRevenue: taxExcludedRevenue,
                cashAmount: cashAmount,
                cardAmount: cardAmount,
                appAmount: appAmount,
                ticketAmount: ticketAmount,
                totalDistance: totalDistance,
                occupiedDistance: occupiedDistance,
                ridesCount: ridesCount,
                fuelAmount: fuelAmount,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RevenuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RevenuesTable,
      Revenue,
      $$RevenuesTableFilterComposer,
      $$RevenuesTableOrderingComposer,
      $$RevenuesTableAnnotationComposer,
      $$RevenuesTableCreateCompanionBuilder,
      $$RevenuesTableUpdateCompanionBuilder,
      (Revenue, BaseReferences<_$AppDatabase, $RevenuesTable, Revenue>),
      Revenue,
      PrefetchHooks Function()
    >;
typedef $$WorkSessionsTableCreateCompanionBuilder =
    WorkSessionsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      required DateTime date,
      required DateTime startTime,
      required DateTime endTime,
      required int breakMinutes,
      Value<String?> note,
    });
typedef $$WorkSessionsTableUpdateCompanionBuilder =
    WorkSessionsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<DateTime> date,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> breakMinutes,
      Value<String?> note,
    });

class $$WorkSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkSessionsTable> {
  $$WorkSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkSessionsTable> {
  $$WorkSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkSessionsTable> {
  $$WorkSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$WorkSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkSessionsTable,
          WorkSession,
          $$WorkSessionsTableFilterComposer,
          $$WorkSessionsTableOrderingComposer,
          $$WorkSessionsTableAnnotationComposer,
          $$WorkSessionsTableCreateCompanionBuilder,
          $$WorkSessionsTableUpdateCompanionBuilder,
          (
            WorkSession,
            BaseReferences<_$AppDatabase, $WorkSessionsTable, WorkSession>,
          ),
          WorkSession,
          PrefetchHooks Function()
        > {
  $$WorkSessionsTableTableManager(_$AppDatabase db, $WorkSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WorkSessionsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                date: date,
                startTime: startTime,
                endTime: endTime,
                breakMinutes: breakMinutes,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required DateTime date,
                required DateTime startTime,
                required DateTime endTime,
                required int breakMinutes,
                Value<String?> note = const Value.absent(),
              }) => WorkSessionsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                date: date,
                startTime: startTime,
                endTime: endTime,
                breakMinutes: breakMinutes,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkSessionsTable,
      WorkSession,
      $$WorkSessionsTableFilterComposer,
      $$WorkSessionsTableOrderingComposer,
      $$WorkSessionsTableAnnotationComposer,
      $$WorkSessionsTableCreateCompanionBuilder,
      $$WorkSessionsTableUpdateCompanionBuilder,
      (
        WorkSession,
        BaseReferences<_$AppDatabase, $WorkSessionsTable, WorkSession>,
      ),
      WorkSession,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<int> monthlyClosingDay,
      required int ashikiriAmount,
      required double commissionRate,
      required bool improvementStandardEnabled,
      Value<int> maxMonthlyRestraintHours,
      Value<int> maxMonthlyShifts,
      required String themeMode,
      required bool isPremium,
      required String customLabels,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<int> monthlyClosingDay,
      Value<int> ashikiriAmount,
      Value<double> commissionRate,
      Value<bool> improvementStandardEnabled,
      Value<int> maxMonthlyRestraintHours,
      Value<int> maxMonthlyShifts,
      Value<String> themeMode,
      Value<bool> isPremium,
      Value<String> customLabels,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyClosingDay => $composableBuilder(
    column: $table.monthlyClosingDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ashikiriAmount => $composableBuilder(
    column: $table.ashikiriAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get commissionRate => $composableBuilder(
    column: $table.commissionRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get improvementStandardEnabled => $composableBuilder(
    column: $table.improvementStandardEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxMonthlyRestraintHours => $composableBuilder(
    column: $table.maxMonthlyRestraintHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxMonthlyShifts => $composableBuilder(
    column: $table.maxMonthlyShifts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customLabels => $composableBuilder(
    column: $table.customLabels,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyClosingDay => $composableBuilder(
    column: $table.monthlyClosingDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ashikiriAmount => $composableBuilder(
    column: $table.ashikiriAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get commissionRate => $composableBuilder(
    column: $table.commissionRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get improvementStandardEnabled => $composableBuilder(
    column: $table.improvementStandardEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxMonthlyRestraintHours => $composableBuilder(
    column: $table.maxMonthlyRestraintHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxMonthlyShifts => $composableBuilder(
    column: $table.maxMonthlyShifts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customLabels => $composableBuilder(
    column: $table.customLabels,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get monthlyClosingDay => $composableBuilder(
    column: $table.monthlyClosingDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ashikiriAmount => $composableBuilder(
    column: $table.ashikiriAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get commissionRate => $composableBuilder(
    column: $table.commissionRate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get improvementStandardEnabled => $composableBuilder(
    column: $table.improvementStandardEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxMonthlyRestraintHours => $composableBuilder(
    column: $table.maxMonthlyRestraintHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxMonthlyShifts => $composableBuilder(
    column: $table.maxMonthlyShifts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumn<String> get customLabels => $composableBuilder(
    column: $table.customLabels,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> monthlyClosingDay = const Value.absent(),
                Value<int> ashikiriAmount = const Value.absent(),
                Value<double> commissionRate = const Value.absent(),
                Value<bool> improvementStandardEnabled = const Value.absent(),
                Value<int> maxMonthlyRestraintHours = const Value.absent(),
                Value<int> maxMonthlyShifts = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<String> customLabels = const Value.absent(),
              }) => AppSettingsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                monthlyClosingDay: monthlyClosingDay,
                ashikiriAmount: ashikiriAmount,
                commissionRate: commissionRate,
                improvementStandardEnabled: improvementStandardEnabled,
                maxMonthlyRestraintHours: maxMonthlyRestraintHours,
                maxMonthlyShifts: maxMonthlyShifts,
                themeMode: themeMode,
                isPremium: isPremium,
                customLabels: customLabels,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> monthlyClosingDay = const Value.absent(),
                required int ashikiriAmount,
                required double commissionRate,
                required bool improvementStandardEnabled,
                Value<int> maxMonthlyRestraintHours = const Value.absent(),
                Value<int> maxMonthlyShifts = const Value.absent(),
                required String themeMode,
                required bool isPremium,
                required String customLabels,
              }) => AppSettingsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                monthlyClosingDay: monthlyClosingDay,
                ashikiriAmount: ashikiriAmount,
                commissionRate: commissionRate,
                improvementStandardEnabled: improvementStandardEnabled,
                maxMonthlyRestraintHours: maxMonthlyRestraintHours,
                maxMonthlyShifts: maxMonthlyShifts,
                themeMode: themeMode,
                isPremium: isPremium,
                customLabels: customLabels,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$PresetsTableCreateCompanionBuilder =
    PresetsCompanion Function({
      Value<int> id,
      required String name,
      required String workStyle,
      required String cycle,
      Value<bool> isBuiltin,
    });
typedef $$PresetsTableUpdateCompanionBuilder =
    PresetsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> workStyle,
      Value<String> cycle,
      Value<bool> isBuiltin,
    });

class $$PresetsTableFilterComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workStyle => $composableBuilder(
    column: $table.workStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workStyle => $composableBuilder(
    column: $table.workStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycle => $composableBuilder(
    column: $table.cycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get workStyle =>
      $composableBuilder(column: $table.workStyle, builder: (column) => column);

  GeneratedColumn<String> get cycle =>
      $composableBuilder(column: $table.cycle, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltin =>
      $composableBuilder(column: $table.isBuiltin, builder: (column) => column);
}

class $$PresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresetsTable,
          Preset,
          $$PresetsTableFilterComposer,
          $$PresetsTableOrderingComposer,
          $$PresetsTableAnnotationComposer,
          $$PresetsTableCreateCompanionBuilder,
          $$PresetsTableUpdateCompanionBuilder,
          (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
          Preset,
          PrefetchHooks Function()
        > {
  $$PresetsTableTableManager(_$AppDatabase db, $PresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> workStyle = const Value.absent(),
                Value<String> cycle = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
              }) => PresetsCompanion(
                id: id,
                name: name,
                workStyle: workStyle,
                cycle: cycle,
                isBuiltin: isBuiltin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String workStyle,
                required String cycle,
                Value<bool> isBuiltin = const Value.absent(),
              }) => PresetsCompanion.insert(
                id: id,
                name: name,
                workStyle: workStyle,
                cycle: cycle,
                isBuiltin: isBuiltin,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresetsTable,
      Preset,
      $$PresetsTableFilterComposer,
      $$PresetsTableOrderingComposer,
      $$PresetsTableAnnotationComposer,
      $$PresetsTableCreateCompanionBuilder,
      $$PresetsTableUpdateCompanionBuilder,
      (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
      Preset,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShiftPatternsTableTableManager get shiftPatterns =>
      $$ShiftPatternsTableTableManager(_db, _db.shiftPatterns);
  $$ShiftOverridesTableTableManager get shiftOverrides =>
      $$ShiftOverridesTableTableManager(_db, _db.shiftOverrides);
  $$RevenuesTableTableManager get revenues =>
      $$RevenuesTableTableManager(_db, _db.revenues);
  $$WorkSessionsTableTableManager get workSessions =>
      $$WorkSessionsTableTableManager(_db, _db.workSessions);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$PresetsTableTableManager get presets =>
      $$PresetsTableTableManager(_db, _db.presets);
}
