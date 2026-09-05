// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalSecMeta = const VerificationMeta(
    'intervalSec',
  );
  @override
  late final GeneratedColumn<int> intervalSec = GeneratedColumn<int>(
    'interval_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interruptedMeta = const VerificationMeta(
    'interrupted',
  );
  @override
  late final GeneratedColumn<bool> interrupted = GeneratedColumn<bool>(
    'interrupted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("interrupted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _totalAnsweredMeta = const VerificationMeta(
    'totalAnswered',
  );
  @override
  late final GeneratedColumn<int> totalAnswered = GeneratedColumn<int>(
    'total_answered',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCorrectMeta = const VerificationMeta(
    'totalCorrect',
  );
  @override
  late final GeneratedColumn<int> totalCorrect = GeneratedColumn<int>(
    'total_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalWrongMeta = const VerificationMeta(
    'totalWrong',
  );
  @override
  late final GeneratedColumn<int> totalWrong = GeneratedColumn<int>(
    'total_wrong',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCorrectionsMeta = const VerificationMeta(
    'totalCorrections',
  );
  @override
  late final GeneratedColumn<int> totalCorrections = GeneratedColumn<int>(
    'total_corrections',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    durationSec,
    intervalSec,
    seed,
    interrupted,
    totalAnswered,
    totalCorrect,
    totalWrong,
    totalCorrections,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecMeta);
    }
    if (data.containsKey('interval_sec')) {
      context.handle(
        _intervalSecMeta,
        intervalSec.isAcceptableOrUnknown(
          data['interval_sec']!,
          _intervalSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intervalSecMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('interrupted')) {
      context.handle(
        _interruptedMeta,
        interrupted.isAcceptableOrUnknown(
          data['interrupted']!,
          _interruptedMeta,
        ),
      );
    }
    if (data.containsKey('total_answered')) {
      context.handle(
        _totalAnsweredMeta,
        totalAnswered.isAcceptableOrUnknown(
          data['total_answered']!,
          _totalAnsweredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAnsweredMeta);
    }
    if (data.containsKey('total_correct')) {
      context.handle(
        _totalCorrectMeta,
        totalCorrect.isAcceptableOrUnknown(
          data['total_correct']!,
          _totalCorrectMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCorrectMeta);
    }
    if (data.containsKey('total_wrong')) {
      context.handle(
        _totalWrongMeta,
        totalWrong.isAcceptableOrUnknown(data['total_wrong']!, _totalWrongMeta),
      );
    } else if (isInserting) {
      context.missing(_totalWrongMeta);
    }
    if (data.containsKey('total_corrections')) {
      context.handle(
        _totalCorrectionsMeta,
        totalCorrections.isAcceptableOrUnknown(
          data['total_corrections']!,
          _totalCorrectionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCorrectionsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      )!,
      intervalSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_sec'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      )!,
      interrupted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}interrupted'],
      )!,
      totalAnswered: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_answered'],
      )!,
      totalCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_correct'],
      )!,
      totalWrong: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_wrong'],
      )!,
      totalCorrections: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_corrections'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final String id;
  final DateTime startedAt;
  final int durationSec;
  final int intervalSec;
  final int seed;
  final bool interrupted;
  final int totalAnswered;
  final int totalCorrect;
  final int totalWrong;
  final int totalCorrections;
  const SessionRow({
    required this.id,
    required this.startedAt,
    required this.durationSec,
    required this.intervalSec,
    required this.seed,
    required this.interrupted,
    required this.totalAnswered,
    required this.totalCorrect,
    required this.totalWrong,
    required this.totalCorrections,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['duration_sec'] = Variable<int>(durationSec);
    map['interval_sec'] = Variable<int>(intervalSec);
    map['seed'] = Variable<int>(seed);
    map['interrupted'] = Variable<bool>(interrupted);
    map['total_answered'] = Variable<int>(totalAnswered);
    map['total_correct'] = Variable<int>(totalCorrect);
    map['total_wrong'] = Variable<int>(totalWrong);
    map['total_corrections'] = Variable<int>(totalCorrections);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      durationSec: Value(durationSec),
      intervalSec: Value(intervalSec),
      seed: Value(seed),
      interrupted: Value(interrupted),
      totalAnswered: Value(totalAnswered),
      totalCorrect: Value(totalCorrect),
      totalWrong: Value(totalWrong),
      totalCorrections: Value(totalCorrections),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      intervalSec: serializer.fromJson<int>(json['intervalSec']),
      seed: serializer.fromJson<int>(json['seed']),
      interrupted: serializer.fromJson<bool>(json['interrupted']),
      totalAnswered: serializer.fromJson<int>(json['totalAnswered']),
      totalCorrect: serializer.fromJson<int>(json['totalCorrect']),
      totalWrong: serializer.fromJson<int>(json['totalWrong']),
      totalCorrections: serializer.fromJson<int>(json['totalCorrections']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationSec': serializer.toJson<int>(durationSec),
      'intervalSec': serializer.toJson<int>(intervalSec),
      'seed': serializer.toJson<int>(seed),
      'interrupted': serializer.toJson<bool>(interrupted),
      'totalAnswered': serializer.toJson<int>(totalAnswered),
      'totalCorrect': serializer.toJson<int>(totalCorrect),
      'totalWrong': serializer.toJson<int>(totalWrong),
      'totalCorrections': serializer.toJson<int>(totalCorrections),
    };
  }

  SessionRow copyWith({
    String? id,
    DateTime? startedAt,
    int? durationSec,
    int? intervalSec,
    int? seed,
    bool? interrupted,
    int? totalAnswered,
    int? totalCorrect,
    int? totalWrong,
    int? totalCorrections,
  }) => SessionRow(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    durationSec: durationSec ?? this.durationSec,
    intervalSec: intervalSec ?? this.intervalSec,
    seed: seed ?? this.seed,
    interrupted: interrupted ?? this.interrupted,
    totalAnswered: totalAnswered ?? this.totalAnswered,
    totalCorrect: totalCorrect ?? this.totalCorrect,
    totalWrong: totalWrong ?? this.totalWrong,
    totalCorrections: totalCorrections ?? this.totalCorrections,
  );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      intervalSec: data.intervalSec.present
          ? data.intervalSec.value
          : this.intervalSec,
      seed: data.seed.present ? data.seed.value : this.seed,
      interrupted: data.interrupted.present
          ? data.interrupted.value
          : this.interrupted,
      totalAnswered: data.totalAnswered.present
          ? data.totalAnswered.value
          : this.totalAnswered,
      totalCorrect: data.totalCorrect.present
          ? data.totalCorrect.value
          : this.totalCorrect,
      totalWrong: data.totalWrong.present
          ? data.totalWrong.value
          : this.totalWrong,
      totalCorrections: data.totalCorrections.present
          ? data.totalCorrections.value
          : this.totalCorrections,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('intervalSec: $intervalSec, ')
          ..write('seed: $seed, ')
          ..write('interrupted: $interrupted, ')
          ..write('totalAnswered: $totalAnswered, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('totalWrong: $totalWrong, ')
          ..write('totalCorrections: $totalCorrections')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    durationSec,
    intervalSec,
    seed,
    interrupted,
    totalAnswered,
    totalCorrect,
    totalWrong,
    totalCorrections,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.durationSec == this.durationSec &&
          other.intervalSec == this.intervalSec &&
          other.seed == this.seed &&
          other.interrupted == this.interrupted &&
          other.totalAnswered == this.totalAnswered &&
          other.totalCorrect == this.totalCorrect &&
          other.totalWrong == this.totalWrong &&
          other.totalCorrections == this.totalCorrections);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<int> durationSec;
  final Value<int> intervalSec;
  final Value<int> seed;
  final Value<bool> interrupted;
  final Value<int> totalAnswered;
  final Value<int> totalCorrect;
  final Value<int> totalWrong;
  final Value<int> totalCorrections;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.intervalSec = const Value.absent(),
    this.seed = const Value.absent(),
    this.interrupted = const Value.absent(),
    this.totalAnswered = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.totalWrong = const Value.absent(),
    this.totalCorrections = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required DateTime startedAt,
    required int durationSec,
    required int intervalSec,
    required int seed,
    this.interrupted = const Value.absent(),
    required int totalAnswered,
    required int totalCorrect,
    required int totalWrong,
    required int totalCorrections,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       durationSec = Value(durationSec),
       intervalSec = Value(intervalSec),
       seed = Value(seed),
       totalAnswered = Value(totalAnswered),
       totalCorrect = Value(totalCorrect),
       totalWrong = Value(totalWrong),
       totalCorrections = Value(totalCorrections);
  static Insertable<SessionRow> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<int>? durationSec,
    Expression<int>? intervalSec,
    Expression<int>? seed,
    Expression<bool>? interrupted,
    Expression<int>? totalAnswered,
    Expression<int>? totalCorrect,
    Expression<int>? totalWrong,
    Expression<int>? totalCorrections,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (durationSec != null) 'duration_sec': durationSec,
      if (intervalSec != null) 'interval_sec': intervalSec,
      if (seed != null) 'seed': seed,
      if (interrupted != null) 'interrupted': interrupted,
      if (totalAnswered != null) 'total_answered': totalAnswered,
      if (totalCorrect != null) 'total_correct': totalCorrect,
      if (totalWrong != null) 'total_wrong': totalWrong,
      if (totalCorrections != null) 'total_corrections': totalCorrections,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<int>? durationSec,
    Value<int>? intervalSec,
    Value<int>? seed,
    Value<bool>? interrupted,
    Value<int>? totalAnswered,
    Value<int>? totalCorrect,
    Value<int>? totalWrong,
    Value<int>? totalCorrections,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      durationSec: durationSec ?? this.durationSec,
      intervalSec: intervalSec ?? this.intervalSec,
      seed: seed ?? this.seed,
      interrupted: interrupted ?? this.interrupted,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      totalCorrections: totalCorrections ?? this.totalCorrections,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (intervalSec.present) {
      map['interval_sec'] = Variable<int>(intervalSec.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (interrupted.present) {
      map['interrupted'] = Variable<bool>(interrupted.value);
    }
    if (totalAnswered.present) {
      map['total_answered'] = Variable<int>(totalAnswered.value);
    }
    if (totalCorrect.present) {
      map['total_correct'] = Variable<int>(totalCorrect.value);
    }
    if (totalWrong.present) {
      map['total_wrong'] = Variable<int>(totalWrong.value);
    }
    if (totalCorrections.present) {
      map['total_corrections'] = Variable<int>(totalCorrections.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('intervalSec: $intervalSec, ')
          ..write('seed: $seed, ')
          ..write('interrupted: $interrupted, ')
          ..write('totalAnswered: $totalAnswered, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('totalWrong: $totalWrong, ')
          ..write('totalCorrections: $totalCorrections, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SegmentsTable extends Segments
    with TableInfo<$SegmentsTable, SegmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idxMeta = const VerificationMeta('idx');
  @override
  late final GeneratedColumn<int> idx = GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answeredMeta = const VerificationMeta(
    'answered',
  );
  @override
  late final GeneratedColumn<int> answered = GeneratedColumn<int>(
    'answered',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wrongMeta = const VerificationMeta('wrong');
  @override
  late final GeneratedColumn<int> wrong = GeneratedColumn<int>(
    'wrong',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgResponseMsMeta = const VerificationMeta(
    'avgResponseMs',
  );
  @override
  late final GeneratedColumn<double> avgResponseMs = GeneratedColumn<double>(
    'avg_response_ms',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    idx,
    answered,
    correct,
    wrong,
    avgResponseMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SegmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('idx')) {
      context.handle(
        _idxMeta,
        idx.isAcceptableOrUnknown(data['idx']!, _idxMeta),
      );
    } else if (isInserting) {
      context.missing(_idxMeta);
    }
    if (data.containsKey('answered')) {
      context.handle(
        _answeredMeta,
        answered.isAcceptableOrUnknown(data['answered']!, _answeredMeta),
      );
    } else if (isInserting) {
      context.missing(_answeredMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('wrong')) {
      context.handle(
        _wrongMeta,
        wrong.isAcceptableOrUnknown(data['wrong']!, _wrongMeta),
      );
    } else if (isInserting) {
      context.missing(_wrongMeta);
    }
    if (data.containsKey('avg_response_ms')) {
      context.handle(
        _avgResponseMsMeta,
        avgResponseMs.isAcceptableOrUnknown(
          data['avg_response_ms']!,
          _avgResponseMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgResponseMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, idx};
  @override
  SegmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SegmentRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      idx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idx'],
      )!,
      answered: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answered'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      wrong: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wrong'],
      )!,
      avgResponseMs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_response_ms'],
      )!,
    );
  }

  @override
  $SegmentsTable createAlias(String alias) {
    return $SegmentsTable(attachedDatabase, alias);
  }
}

class SegmentRow extends DataClass implements Insertable<SegmentRow> {
  final String sessionId;
  final int idx;
  final int answered;
  final int correct;
  final int wrong;
  final double avgResponseMs;
  const SegmentRow({
    required this.sessionId,
    required this.idx,
    required this.answered,
    required this.correct,
    required this.wrong,
    required this.avgResponseMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['idx'] = Variable<int>(idx);
    map['answered'] = Variable<int>(answered);
    map['correct'] = Variable<int>(correct);
    map['wrong'] = Variable<int>(wrong);
    map['avg_response_ms'] = Variable<double>(avgResponseMs);
    return map;
  }

  SegmentsCompanion toCompanion(bool nullToAbsent) {
    return SegmentsCompanion(
      sessionId: Value(sessionId),
      idx: Value(idx),
      answered: Value(answered),
      correct: Value(correct),
      wrong: Value(wrong),
      avgResponseMs: Value(avgResponseMs),
    );
  }

  factory SegmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SegmentRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      idx: serializer.fromJson<int>(json['idx']),
      answered: serializer.fromJson<int>(json['answered']),
      correct: serializer.fromJson<int>(json['correct']),
      wrong: serializer.fromJson<int>(json['wrong']),
      avgResponseMs: serializer.fromJson<double>(json['avgResponseMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'idx': serializer.toJson<int>(idx),
      'answered': serializer.toJson<int>(answered),
      'correct': serializer.toJson<int>(correct),
      'wrong': serializer.toJson<int>(wrong),
      'avgResponseMs': serializer.toJson<double>(avgResponseMs),
    };
  }

  SegmentRow copyWith({
    String? sessionId,
    int? idx,
    int? answered,
    int? correct,
    int? wrong,
    double? avgResponseMs,
  }) => SegmentRow(
    sessionId: sessionId ?? this.sessionId,
    idx: idx ?? this.idx,
    answered: answered ?? this.answered,
    correct: correct ?? this.correct,
    wrong: wrong ?? this.wrong,
    avgResponseMs: avgResponseMs ?? this.avgResponseMs,
  );
  SegmentRow copyWithCompanion(SegmentsCompanion data) {
    return SegmentRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      idx: data.idx.present ? data.idx.value : this.idx,
      answered: data.answered.present ? data.answered.value : this.answered,
      correct: data.correct.present ? data.correct.value : this.correct,
      wrong: data.wrong.present ? data.wrong.value : this.wrong,
      avgResponseMs: data.avgResponseMs.present
          ? data.avgResponseMs.value
          : this.avgResponseMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SegmentRow(')
          ..write('sessionId: $sessionId, ')
          ..write('idx: $idx, ')
          ..write('answered: $answered, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('avgResponseMs: $avgResponseMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, idx, answered, correct, wrong, avgResponseMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SegmentRow &&
          other.sessionId == this.sessionId &&
          other.idx == this.idx &&
          other.answered == this.answered &&
          other.correct == this.correct &&
          other.wrong == this.wrong &&
          other.avgResponseMs == this.avgResponseMs);
}

class SegmentsCompanion extends UpdateCompanion<SegmentRow> {
  final Value<String> sessionId;
  final Value<int> idx;
  final Value<int> answered;
  final Value<int> correct;
  final Value<int> wrong;
  final Value<double> avgResponseMs;
  final Value<int> rowid;
  const SegmentsCompanion({
    this.sessionId = const Value.absent(),
    this.idx = const Value.absent(),
    this.answered = const Value.absent(),
    this.correct = const Value.absent(),
    this.wrong = const Value.absent(),
    this.avgResponseMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SegmentsCompanion.insert({
    required String sessionId,
    required int idx,
    required int answered,
    required int correct,
    required int wrong,
    required double avgResponseMs,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       idx = Value(idx),
       answered = Value(answered),
       correct = Value(correct),
       wrong = Value(wrong),
       avgResponseMs = Value(avgResponseMs);
  static Insertable<SegmentRow> custom({
    Expression<String>? sessionId,
    Expression<int>? idx,
    Expression<int>? answered,
    Expression<int>? correct,
    Expression<int>? wrong,
    Expression<double>? avgResponseMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (idx != null) 'idx': idx,
      if (answered != null) 'answered': answered,
      if (correct != null) 'correct': correct,
      if (wrong != null) 'wrong': wrong,
      if (avgResponseMs != null) 'avg_response_ms': avgResponseMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SegmentsCompanion copyWith({
    Value<String>? sessionId,
    Value<int>? idx,
    Value<int>? answered,
    Value<int>? correct,
    Value<int>? wrong,
    Value<double>? avgResponseMs,
    Value<int>? rowid,
  }) {
    return SegmentsCompanion(
      sessionId: sessionId ?? this.sessionId,
      idx: idx ?? this.idx,
      answered: answered ?? this.answered,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
      avgResponseMs: avgResponseMs ?? this.avgResponseMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (idx.present) {
      map['idx'] = Variable<int>(idx.value);
    }
    if (answered.present) {
      map['answered'] = Variable<int>(answered.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (wrong.present) {
      map['wrong'] = Variable<int>(wrong.value);
    }
    if (avgResponseMs.present) {
      map['avg_response_ms'] = Variable<double>(avgResponseMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SegmentsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('idx: $idx, ')
          ..write('answered: $answered, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('avgResponseMs: $avgResponseMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnswersTable extends Answers with TableInfo<$AnswersTable, AnswerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnswersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _elapsedMsMeta = const VerificationMeta(
    'elapsedMs',
  );
  @override
  late final GeneratedColumn<int> elapsedMs = GeneratedColumn<int>(
    'elapsed_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aMeta = const VerificationMeta('a');
  @override
  late final GeneratedColumn<int> a = GeneratedColumn<int>(
    'a',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bMeta = const VerificationMeta('b');
  @override
  late final GeneratedColumn<int> b = GeneratedColumn<int>(
    'b',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedMeta = const VerificationMeta(
    'expected',
  );
  @override
  late final GeneratedColumn<int> expected = GeneratedColumn<int>(
    'expected',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _givenMeta = const VerificationMeta('given');
  @override
  late final GeneratedColumn<int> given = GeneratedColumn<int>(
    'given',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseMsMeta = const VerificationMeta(
    'responseMs',
  );
  @override
  late final GeneratedColumn<int> responseMs = GeneratedColumn<int>(
    'response_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    elapsedMs,
    a,
    b,
    expected,
    given,
    responseMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnswerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('elapsed_ms')) {
      context.handle(
        _elapsedMsMeta,
        elapsedMs.isAcceptableOrUnknown(data['elapsed_ms']!, _elapsedMsMeta),
      );
    } else if (isInserting) {
      context.missing(_elapsedMsMeta);
    }
    if (data.containsKey('a')) {
      context.handle(_aMeta, a.isAcceptableOrUnknown(data['a']!, _aMeta));
    } else if (isInserting) {
      context.missing(_aMeta);
    }
    if (data.containsKey('b')) {
      context.handle(_bMeta, b.isAcceptableOrUnknown(data['b']!, _bMeta));
    } else if (isInserting) {
      context.missing(_bMeta);
    }
    if (data.containsKey('expected')) {
      context.handle(
        _expectedMeta,
        expected.isAcceptableOrUnknown(data['expected']!, _expectedMeta),
      );
    } else if (isInserting) {
      context.missing(_expectedMeta);
    }
    if (data.containsKey('given')) {
      context.handle(
        _givenMeta,
        given.isAcceptableOrUnknown(data['given']!, _givenMeta),
      );
    } else if (isInserting) {
      context.missing(_givenMeta);
    }
    if (data.containsKey('response_ms')) {
      context.handle(
        _responseMsMeta,
        responseMs.isAcceptableOrUnknown(data['response_ms']!, _responseMsMeta),
      );
    } else if (isInserting) {
      context.missing(_responseMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnswerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnswerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      elapsedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_ms'],
      )!,
      a: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}a'],
      )!,
      b: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}b'],
      )!,
      expected: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected'],
      )!,
      given: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}given'],
      )!,
      responseMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_ms'],
      )!,
    );
  }

  @override
  $AnswersTable createAlias(String alias) {
    return $AnswersTable(attachedDatabase, alias);
  }
}

class AnswerRow extends DataClass implements Insertable<AnswerRow> {
  final int id;
  final String sessionId;
  final int elapsedMs;
  final int a;
  final int b;
  final int expected;
  final int given;
  final int responseMs;
  const AnswerRow({
    required this.id,
    required this.sessionId,
    required this.elapsedMs,
    required this.a,
    required this.b,
    required this.expected,
    required this.given,
    required this.responseMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['elapsed_ms'] = Variable<int>(elapsedMs);
    map['a'] = Variable<int>(a);
    map['b'] = Variable<int>(b);
    map['expected'] = Variable<int>(expected);
    map['given'] = Variable<int>(given);
    map['response_ms'] = Variable<int>(responseMs);
    return map;
  }

  AnswersCompanion toCompanion(bool nullToAbsent) {
    return AnswersCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      elapsedMs: Value(elapsedMs),
      a: Value(a),
      b: Value(b),
      expected: Value(expected),
      given: Value(given),
      responseMs: Value(responseMs),
    );
  }

  factory AnswerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnswerRow(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      elapsedMs: serializer.fromJson<int>(json['elapsedMs']),
      a: serializer.fromJson<int>(json['a']),
      b: serializer.fromJson<int>(json['b']),
      expected: serializer.fromJson<int>(json['expected']),
      given: serializer.fromJson<int>(json['given']),
      responseMs: serializer.fromJson<int>(json['responseMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'elapsedMs': serializer.toJson<int>(elapsedMs),
      'a': serializer.toJson<int>(a),
      'b': serializer.toJson<int>(b),
      'expected': serializer.toJson<int>(expected),
      'given': serializer.toJson<int>(given),
      'responseMs': serializer.toJson<int>(responseMs),
    };
  }

  AnswerRow copyWith({
    int? id,
    String? sessionId,
    int? elapsedMs,
    int? a,
    int? b,
    int? expected,
    int? given,
    int? responseMs,
  }) => AnswerRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    elapsedMs: elapsedMs ?? this.elapsedMs,
    a: a ?? this.a,
    b: b ?? this.b,
    expected: expected ?? this.expected,
    given: given ?? this.given,
    responseMs: responseMs ?? this.responseMs,
  );
  AnswerRow copyWithCompanion(AnswersCompanion data) {
    return AnswerRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      elapsedMs: data.elapsedMs.present ? data.elapsedMs.value : this.elapsedMs,
      a: data.a.present ? data.a.value : this.a,
      b: data.b.present ? data.b.value : this.b,
      expected: data.expected.present ? data.expected.value : this.expected,
      given: data.given.present ? data.given.value : this.given,
      responseMs: data.responseMs.present
          ? data.responseMs.value
          : this.responseMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnswerRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('elapsedMs: $elapsedMs, ')
          ..write('a: $a, ')
          ..write('b: $b, ')
          ..write('expected: $expected, ')
          ..write('given: $given, ')
          ..write('responseMs: $responseMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, elapsedMs, a, b, expected, given, responseMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnswerRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.elapsedMs == this.elapsedMs &&
          other.a == this.a &&
          other.b == this.b &&
          other.expected == this.expected &&
          other.given == this.given &&
          other.responseMs == this.responseMs);
}

class AnswersCompanion extends UpdateCompanion<AnswerRow> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> elapsedMs;
  final Value<int> a;
  final Value<int> b;
  final Value<int> expected;
  final Value<int> given;
  final Value<int> responseMs;
  const AnswersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.elapsedMs = const Value.absent(),
    this.a = const Value.absent(),
    this.b = const Value.absent(),
    this.expected = const Value.absent(),
    this.given = const Value.absent(),
    this.responseMs = const Value.absent(),
  });
  AnswersCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int elapsedMs,
    required int a,
    required int b,
    required int expected,
    required int given,
    required int responseMs,
  }) : sessionId = Value(sessionId),
       elapsedMs = Value(elapsedMs),
       a = Value(a),
       b = Value(b),
       expected = Value(expected),
       given = Value(given),
       responseMs = Value(responseMs);
  static Insertable<AnswerRow> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? elapsedMs,
    Expression<int>? a,
    Expression<int>? b,
    Expression<int>? expected,
    Expression<int>? given,
    Expression<int>? responseMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (elapsedMs != null) 'elapsed_ms': elapsedMs,
      if (a != null) 'a': a,
      if (b != null) 'b': b,
      if (expected != null) 'expected': expected,
      if (given != null) 'given': given,
      if (responseMs != null) 'response_ms': responseMs,
    });
  }

  AnswersCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<int>? elapsedMs,
    Value<int>? a,
    Value<int>? b,
    Value<int>? expected,
    Value<int>? given,
    Value<int>? responseMs,
  }) {
    return AnswersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      elapsedMs: elapsedMs ?? this.elapsedMs,
      a: a ?? this.a,
      b: b ?? this.b,
      expected: expected ?? this.expected,
      given: given ?? this.given,
      responseMs: responseMs ?? this.responseMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (elapsedMs.present) {
      map['elapsed_ms'] = Variable<int>(elapsedMs.value);
    }
    if (a.present) {
      map['a'] = Variable<int>(a.value);
    }
    if (b.present) {
      map['b'] = Variable<int>(b.value);
    }
    if (expected.present) {
      map['expected'] = Variable<int>(expected.value);
    }
    if (given.present) {
      map['given'] = Variable<int>(given.value);
    }
    if (responseMs.present) {
      map['response_ms'] = Variable<int>(responseMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnswersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('elapsedMs: $elapsedMs, ')
          ..write('a: $a, ')
          ..write('b: $b, ')
          ..write('expected: $expected, ')
          ..write('given: $given, ')
          ..write('responseMs: $responseMs')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(600),
  );
  static const VerificationMeta _soundMeta = const VerificationMeta('sound');
  @override
  late final GeneratedColumn<bool> sound = GeneratedColumn<bool>(
    'sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hapticsMeta = const VerificationMeta(
    'haptics',
  );
  @override
  late final GeneratedColumn<bool> haptics = GeneratedColumn<bool>(
    'haptics',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _includeZeroMeta = const VerificationMeta(
    'includeZero',
  );
  @override
  late final GeneratedColumn<bool> includeZero = GeneratedColumn<bool>(
    'include_zero',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("include_zero" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _saveDetailsMeta = const VerificationMeta(
    'saveDetails',
  );
  @override
  late final GeneratedColumn<bool> saveDetails = GeneratedColumn<bool>(
    'save_details',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("save_details" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    durationSec,
    sound,
    haptics,
    includeZero,
    saveDetails,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('sound')) {
      context.handle(
        _soundMeta,
        sound.isAcceptableOrUnknown(data['sound']!, _soundMeta),
      );
    }
    if (data.containsKey('haptics')) {
      context.handle(
        _hapticsMeta,
        haptics.isAcceptableOrUnknown(data['haptics']!, _hapticsMeta),
      );
    }
    if (data.containsKey('include_zero')) {
      context.handle(
        _includeZeroMeta,
        includeZero.isAcceptableOrUnknown(
          data['include_zero']!,
          _includeZeroMeta,
        ),
      );
    }
    if (data.containsKey('save_details')) {
      context.handle(
        _saveDetailsMeta,
        saveDetails.isAcceptableOrUnknown(
          data['save_details']!,
          _saveDetailsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      )!,
      sound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound'],
      )!,
      haptics: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics'],
      )!,
      includeZero: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}include_zero'],
      )!,
      saveDetails: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}save_details'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final int durationSec;
  final bool sound;
  final bool haptics;
  final bool includeZero;
  final bool saveDetails;
  const SettingsRow({
    required this.id,
    required this.durationSec,
    required this.sound,
    required this.haptics,
    required this.includeZero,
    required this.saveDetails,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['duration_sec'] = Variable<int>(durationSec);
    map['sound'] = Variable<bool>(sound);
    map['haptics'] = Variable<bool>(haptics);
    map['include_zero'] = Variable<bool>(includeZero);
    map['save_details'] = Variable<bool>(saveDetails);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      durationSec: Value(durationSec),
      sound: Value(sound),
      haptics: Value(haptics),
      includeZero: Value(includeZero),
      saveDetails: Value(saveDetails),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      sound: serializer.fromJson<bool>(json['sound']),
      haptics: serializer.fromJson<bool>(json['haptics']),
      includeZero: serializer.fromJson<bool>(json['includeZero']),
      saveDetails: serializer.fromJson<bool>(json['saveDetails']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'durationSec': serializer.toJson<int>(durationSec),
      'sound': serializer.toJson<bool>(sound),
      'haptics': serializer.toJson<bool>(haptics),
      'includeZero': serializer.toJson<bool>(includeZero),
      'saveDetails': serializer.toJson<bool>(saveDetails),
    };
  }

  SettingsRow copyWith({
    int? id,
    int? durationSec,
    bool? sound,
    bool? haptics,
    bool? includeZero,
    bool? saveDetails,
  }) => SettingsRow(
    id: id ?? this.id,
    durationSec: durationSec ?? this.durationSec,
    sound: sound ?? this.sound,
    haptics: haptics ?? this.haptics,
    includeZero: includeZero ?? this.includeZero,
    saveDetails: saveDetails ?? this.saveDetails,
  );
  SettingsRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      sound: data.sound.present ? data.sound.value : this.sound,
      haptics: data.haptics.present ? data.haptics.value : this.haptics,
      includeZero: data.includeZero.present
          ? data.includeZero.value
          : this.includeZero,
      saveDetails: data.saveDetails.present
          ? data.saveDetails.value
          : this.saveDetails,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('durationSec: $durationSec, ')
          ..write('sound: $sound, ')
          ..write('haptics: $haptics, ')
          ..write('includeZero: $includeZero, ')
          ..write('saveDetails: $saveDetails')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, durationSec, sound, haptics, includeZero, saveDetails);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.durationSec == this.durationSec &&
          other.sound == this.sound &&
          other.haptics == this.haptics &&
          other.includeZero == this.includeZero &&
          other.saveDetails == this.saveDetails);
}

class AppSettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<int> durationSec;
  final Value<bool> sound;
  final Value<bool> haptics;
  final Value<bool> includeZero;
  final Value<bool> saveDetails;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.sound = const Value.absent(),
    this.haptics = const Value.absent(),
    this.includeZero = const Value.absent(),
    this.saveDetails = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.sound = const Value.absent(),
    this.haptics = const Value.absent(),
    this.includeZero = const Value.absent(),
    this.saveDetails = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<int>? durationSec,
    Expression<bool>? sound,
    Expression<bool>? haptics,
    Expression<bool>? includeZero,
    Expression<bool>? saveDetails,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (durationSec != null) 'duration_sec': durationSec,
      if (sound != null) 'sound': sound,
      if (haptics != null) 'haptics': haptics,
      if (includeZero != null) 'include_zero': includeZero,
      if (saveDetails != null) 'save_details': saveDetails,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? durationSec,
    Value<bool>? sound,
    Value<bool>? haptics,
    Value<bool>? includeZero,
    Value<bool>? saveDetails,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      durationSec: durationSec ?? this.durationSec,
      sound: sound ?? this.sound,
      haptics: haptics ?? this.haptics,
      includeZero: includeZero ?? this.includeZero,
      saveDetails: saveDetails ?? this.saveDetails,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (sound.present) {
      map['sound'] = Variable<bool>(sound.value);
    }
    if (haptics.present) {
      map['haptics'] = Variable<bool>(haptics.value);
    }
    if (includeZero.present) {
      map['include_zero'] = Variable<bool>(includeZero.value);
    }
    if (saveDetails.present) {
      map['save_details'] = Variable<bool>(saveDetails.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('durationSec: $durationSec, ')
          ..write('sound: $sound, ')
          ..write('haptics: $haptics, ')
          ..write('includeZero: $includeZero, ')
          ..write('saveDetails: $saveDetails')
          ..write(')'))
        .toString();
  }
}

abstract class _$PauliDatabase extends GeneratedDatabase {
  _$PauliDatabase(QueryExecutor e) : super(e);
  $PauliDatabaseManager get managers => $PauliDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SegmentsTable segments = $SegmentsTable(this);
  late final $AnswersTable answers = $AnswersTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    segments,
    answers,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('segments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('answers', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required DateTime startedAt,
      required int durationSec,
      required int intervalSec,
      required int seed,
      Value<bool> interrupted,
      required int totalAnswered,
      required int totalCorrect,
      required int totalWrong,
      required int totalCorrections,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<int> durationSec,
      Value<int> intervalSec,
      Value<int> seed,
      Value<bool> interrupted,
      Value<int> totalAnswered,
      Value<int> totalCorrect,
      Value<int> totalWrong,
      Value<int> totalCorrections,
      Value<int> rowid,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$PauliDatabase, $SessionsTable, SessionRow> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SegmentsTable, List<SegmentRow>>
  _segmentsRefsTable(_$PauliDatabase db) => MultiTypedResultKey.fromTable(
    db.segments,
    aliasName: 'sessions__id__segments__session_id',
  );

  $$SegmentsTableProcessedTableManager get segmentsRefs {
    final manager = $$SegmentsTableTableManager(
      $_db,
      $_db.segments,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_segmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnswersTable, List<AnswerRow>> _answersRefsTable(
    _$PauliDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.answers,
    aliasName: 'sessions__id__answers__session_id',
  );

  $$AnswersTableProcessedTableManager get answersRefs {
    final manager = $$AnswersTableTableManager(
      $_db,
      $_db.answers,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_answersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$PauliDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalSec => $composableBuilder(
    column: $table.intervalSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAnswered => $composableBuilder(
    column: $table.totalAnswered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalWrong => $composableBuilder(
    column: $table.totalWrong,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCorrections => $composableBuilder(
    column: $table.totalCorrections,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> segmentsRefs(
    Expression<bool> Function($$SegmentsTableFilterComposer f) f,
  ) {
    final $$SegmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableFilterComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> answersRefs(
    Expression<bool> Function($$AnswersTableFilterComposer f) f,
  ) {
    final $$AnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.answers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnswersTableFilterComposer(
            $db: $db,
            $table: $db.answers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$PauliDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalSec => $composableBuilder(
    column: $table.intervalSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAnswered => $composableBuilder(
    column: $table.totalAnswered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalWrong => $composableBuilder(
    column: $table.totalWrong,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCorrections => $composableBuilder(
    column: $table.totalCorrections,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$PauliDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalSec => $composableBuilder(
    column: $table.intervalSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<bool> get interrupted => $composableBuilder(
    column: $table.interrupted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAnswered => $composableBuilder(
    column: $table.totalAnswered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalWrong => $composableBuilder(
    column: $table.totalWrong,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCorrections => $composableBuilder(
    column: $table.totalCorrections,
    builder: (column) => column,
  );

  Expression<T> segmentsRefs<T extends Object>(
    Expression<T> Function($$SegmentsTableAnnotationComposer a) f,
  ) {
    final $$SegmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> answersRefs<T extends Object>(
    Expression<T> Function($$AnswersTableAnnotationComposer a) f,
  ) {
    final $$AnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.answers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.answers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$PauliDatabase,
          $SessionsTable,
          SessionRow,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionRow, $$SessionsTableReferences),
          SessionRow,
          PrefetchHooks Function({bool segmentsRefs, bool answersRefs})
        > {
  $$SessionsTableTableManager(_$PauliDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<int> intervalSec = const Value.absent(),
                Value<int> seed = const Value.absent(),
                Value<bool> interrupted = const Value.absent(),
                Value<int> totalAnswered = const Value.absent(),
                Value<int> totalCorrect = const Value.absent(),
                Value<int> totalWrong = const Value.absent(),
                Value<int> totalCorrections = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                startedAt: startedAt,
                durationSec: durationSec,
                intervalSec: intervalSec,
                seed: seed,
                interrupted: interrupted,
                totalAnswered: totalAnswered,
                totalCorrect: totalCorrect,
                totalWrong: totalWrong,
                totalCorrections: totalCorrections,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                required int durationSec,
                required int intervalSec,
                required int seed,
                Value<bool> interrupted = const Value.absent(),
                required int totalAnswered,
                required int totalCorrect,
                required int totalWrong,
                required int totalCorrections,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                durationSec: durationSec,
                intervalSec: intervalSec,
                seed: seed,
                interrupted: interrupted,
                totalAnswered: totalAnswered,
                totalCorrect: totalCorrect,
                totalWrong: totalWrong,
                totalCorrections: totalCorrections,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, SessionRow>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({segmentsRefs = false, answersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (segmentsRefs) db.segments,
                if (answersRefs) db.answers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (segmentsRefs)
                    await $_getPrefetchedData<
                      SessionRow,
                      $SessionsTable,
                      SegmentRow
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._segmentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableReferences(db, table, p0).segmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                  if (answersRefs)
                    await $_getPrefetchedData<
                      SessionRow,
                      $SessionsTable,
                      AnswerRow
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._answersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionsTableReferences(db, table, p0).answersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PauliDatabase,
      $SessionsTable,
      SessionRow,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRow, $$SessionsTableReferences),
      SessionRow,
      PrefetchHooks Function({bool segmentsRefs, bool answersRefs})
    >;
typedef $$SegmentsTableCreateCompanionBuilder =
    SegmentsCompanion Function({
      required String sessionId,
      required int idx,
      required int answered,
      required int correct,
      required int wrong,
      required double avgResponseMs,
      Value<int> rowid,
    });
typedef $$SegmentsTableUpdateCompanionBuilder =
    SegmentsCompanion Function({
      Value<String> sessionId,
      Value<int> idx,
      Value<int> answered,
      Value<int> correct,
      Value<int> wrong,
      Value<double> avgResponseMs,
      Value<int> rowid,
    });

final class $$SegmentsTableReferences
    extends BaseReferences<_$PauliDatabase, $SegmentsTable, SegmentRow> {
  $$SegmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$PauliDatabase db) =>
      db.sessions.createAlias('segments__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SegmentsTableFilterComposer
    extends Composer<_$PauliDatabase, $SegmentsTable> {
  $$SegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answered => $composableBuilder(
    column: $table.answered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wrong => $composableBuilder(
    column: $table.wrong,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgResponseMs => $composableBuilder(
    column: $table.avgResponseMs,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SegmentsTableOrderingComposer
    extends Composer<_$PauliDatabase, $SegmentsTable> {
  $$SegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answered => $composableBuilder(
    column: $table.answered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wrong => $composableBuilder(
    column: $table.wrong,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgResponseMs => $composableBuilder(
    column: $table.avgResponseMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SegmentsTableAnnotationComposer
    extends Composer<_$PauliDatabase, $SegmentsTable> {
  $$SegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idx =>
      $composableBuilder(column: $table.idx, builder: (column) => column);

  GeneratedColumn<int> get answered =>
      $composableBuilder(column: $table.answered, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get wrong =>
      $composableBuilder(column: $table.wrong, builder: (column) => column);

  GeneratedColumn<double> get avgResponseMs => $composableBuilder(
    column: $table.avgResponseMs,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SegmentsTableTableManager
    extends
        RootTableManager<
          _$PauliDatabase,
          $SegmentsTable,
          SegmentRow,
          $$SegmentsTableFilterComposer,
          $$SegmentsTableOrderingComposer,
          $$SegmentsTableAnnotationComposer,
          $$SegmentsTableCreateCompanionBuilder,
          $$SegmentsTableUpdateCompanionBuilder,
          (SegmentRow, $$SegmentsTableReferences),
          SegmentRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SegmentsTableTableManager(_$PauliDatabase db, $SegmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<int> idx = const Value.absent(),
                Value<int> answered = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> wrong = const Value.absent(),
                Value<double> avgResponseMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SegmentsCompanion(
                sessionId: sessionId,
                idx: idx,
                answered: answered,
                correct: correct,
                wrong: wrong,
                avgResponseMs: avgResponseMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required int idx,
                required int answered,
                required int correct,
                required int wrong,
                required double avgResponseMs,
                Value<int> rowid = const Value.absent(),
              }) => SegmentsCompanion.insert(
                sessionId: sessionId,
                idx: idx,
                answered: answered,
                correct: correct,
                wrong: wrong,
                avgResponseMs: avgResponseMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SegmentsTable, SegmentRow>(table),
                  $$SegmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$SegmentsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$SegmentsTableReferences
                                    ._sessionIdTable(db)
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

typedef $$SegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$PauliDatabase,
      $SegmentsTable,
      SegmentRow,
      $$SegmentsTableFilterComposer,
      $$SegmentsTableOrderingComposer,
      $$SegmentsTableAnnotationComposer,
      $$SegmentsTableCreateCompanionBuilder,
      $$SegmentsTableUpdateCompanionBuilder,
      (SegmentRow, $$SegmentsTableReferences),
      SegmentRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$AnswersTableCreateCompanionBuilder =
    AnswersCompanion Function({
      Value<int> id,
      required String sessionId,
      required int elapsedMs,
      required int a,
      required int b,
      required int expected,
      required int given,
      required int responseMs,
    });
typedef $$AnswersTableUpdateCompanionBuilder =
    AnswersCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<int> elapsedMs,
      Value<int> a,
      Value<int> b,
      Value<int> expected,
      Value<int> given,
      Value<int> responseMs,
    });

final class $$AnswersTableReferences
    extends BaseReferences<_$PauliDatabase, $AnswersTable, AnswerRow> {
  $$AnswersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$PauliDatabase db) =>
      db.sessions.createAlias('answers__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnswersTableFilterComposer
    extends Composer<_$PauliDatabase, $AnswersTable> {
  $$AnswersTableFilterComposer({
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

  ColumnFilters<int> get elapsedMs => $composableBuilder(
    column: $table.elapsedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get a => $composableBuilder(
    column: $table.a,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get b => $composableBuilder(
    column: $table.b,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expected => $composableBuilder(
    column: $table.expected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get given => $composableBuilder(
    column: $table.given,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnswersTableOrderingComposer
    extends Composer<_$PauliDatabase, $AnswersTable> {
  $$AnswersTableOrderingComposer({
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

  ColumnOrderings<int> get elapsedMs => $composableBuilder(
    column: $table.elapsedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get a => $composableBuilder(
    column: $table.a,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get b => $composableBuilder(
    column: $table.b,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expected => $composableBuilder(
    column: $table.expected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get given => $composableBuilder(
    column: $table.given,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnswersTableAnnotationComposer
    extends Composer<_$PauliDatabase, $AnswersTable> {
  $$AnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get elapsedMs =>
      $composableBuilder(column: $table.elapsedMs, builder: (column) => column);

  GeneratedColumn<int> get a =>
      $composableBuilder(column: $table.a, builder: (column) => column);

  GeneratedColumn<int> get b =>
      $composableBuilder(column: $table.b, builder: (column) => column);

  GeneratedColumn<int> get expected =>
      $composableBuilder(column: $table.expected, builder: (column) => column);

  GeneratedColumn<int> get given =>
      $composableBuilder(column: $table.given, builder: (column) => column);

  GeneratedColumn<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnswersTableTableManager
    extends
        RootTableManager<
          _$PauliDatabase,
          $AnswersTable,
          AnswerRow,
          $$AnswersTableFilterComposer,
          $$AnswersTableOrderingComposer,
          $$AnswersTableAnnotationComposer,
          $$AnswersTableCreateCompanionBuilder,
          $$AnswersTableUpdateCompanionBuilder,
          (AnswerRow, $$AnswersTableReferences),
          AnswerRow,
          PrefetchHooks Function({bool sessionId})
        > {
  $$AnswersTableTableManager(_$PauliDatabase db, $AnswersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> elapsedMs = const Value.absent(),
                Value<int> a = const Value.absent(),
                Value<int> b = const Value.absent(),
                Value<int> expected = const Value.absent(),
                Value<int> given = const Value.absent(),
                Value<int> responseMs = const Value.absent(),
              }) => AnswersCompanion(
                id: id,
                sessionId: sessionId,
                elapsedMs: elapsedMs,
                a: a,
                b: b,
                expected: expected,
                given: given,
                responseMs: responseMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required int elapsedMs,
                required int a,
                required int b,
                required int expected,
                required int given,
                required int responseMs,
              }) => AnswersCompanion.insert(
                id: id,
                sessionId: sessionId,
                elapsedMs: elapsedMs,
                a: a,
                b: b,
                expected: expected,
                given: given,
                responseMs: responseMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnswersTable, AnswerRow>(table),
                  $$AnswersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$AnswersTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$AnswersTableReferences
                                    ._sessionIdTable(db)
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

typedef $$AnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$PauliDatabase,
      $AnswersTable,
      AnswerRow,
      $$AnswersTableFilterComposer,
      $$AnswersTableOrderingComposer,
      $$AnswersTableAnnotationComposer,
      $$AnswersTableCreateCompanionBuilder,
      $$AnswersTableUpdateCompanionBuilder,
      (AnswerRow, $$AnswersTableReferences),
      AnswerRow,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> durationSec,
      Value<bool> sound,
      Value<bool> haptics,
      Value<bool> includeZero,
      Value<bool> saveDetails,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> durationSec,
      Value<bool> sound,
      Value<bool> haptics,
      Value<bool> includeZero,
      Value<bool> saveDetails,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$PauliDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
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

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get haptics => $composableBuilder(
    column: $table.haptics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includeZero => $composableBuilder(
    column: $table.includeZero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get saveDetails => $composableBuilder(
    column: $table.saveDetails,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$PauliDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
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

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get haptics => $composableBuilder(
    column: $table.haptics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includeZero => $composableBuilder(
    column: $table.includeZero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get saveDetails => $composableBuilder(
    column: $table.saveDetails,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$PauliDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sound =>
      $composableBuilder(column: $table.sound, builder: (column) => column);

  GeneratedColumn<bool> get haptics =>
      $composableBuilder(column: $table.haptics, builder: (column) => column);

  GeneratedColumn<bool> get includeZero => $composableBuilder(
    column: $table.includeZero,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get saveDetails => $composableBuilder(
    column: $table.saveDetails,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$PauliDatabase,
          $AppSettingsTable,
          SettingsRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$PauliDatabase, $AppSettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$PauliDatabase db, $AppSettingsTable table)
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
                Value<int> id = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<bool> sound = const Value.absent(),
                Value<bool> haptics = const Value.absent(),
                Value<bool> includeZero = const Value.absent(),
                Value<bool> saveDetails = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                durationSec: durationSec,
                sound: sound,
                haptics: haptics,
                includeZero: includeZero,
                saveDetails: saveDetails,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<bool> sound = const Value.absent(),
                Value<bool> haptics = const Value.absent(),
                Value<bool> includeZero = const Value.absent(),
                Value<bool> saveDetails = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                durationSec: durationSec,
                sound: sound,
                haptics: haptics,
                includeZero: includeZero,
                saveDetails: saveDetails,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, SettingsRow>(table),
                  BaseReferences<
                    _$PauliDatabase,
                    $AppSettingsTable,
                    SettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$PauliDatabase,
      $AppSettingsTable,
      SettingsRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$PauliDatabase, $AppSettingsTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;

class $PauliDatabaseManager {
  final _$PauliDatabase _db;
  $PauliDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SegmentsTableTableManager get segments =>
      $$SegmentsTableTableManager(_db, _db.segments);
  $$AnswersTableTableManager get answers =>
      $$AnswersTableTableManager(_db, _db.answers);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
