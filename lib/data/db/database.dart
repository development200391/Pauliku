import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Satu baris per sesi yang selesai.
@DataClassName('SessionRow')
class Sessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationSec => integer()();
  IntColumn get intervalSec => integer()();
  IntColumn get seed => integer()();
  BoolColumn get interrupted => boolean().withDefault(const Constant(false))();
  IntColumn get totalAnswered => integer()();
  IntColumn get totalCorrect => integer()();
  IntColumn get totalWrong => integer()();
  IntColumn get totalCorrections => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Titik-titik kurva. Sesi 60 menit menghasilkan 60 baris — murah.
@DataClassName('SegmentRow')
class Segments extends Table {
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get idx => integer()();
  IntColumn get answered => integer()();
  IntColumn get correct => integer()();
  IntColumn get wrong => integer()();
  RealColumn get avgResponseMs => real()();

  @override
  Set<Column> get primaryKey => {sessionId, idx};
}

/// Jawaban mentah — hanya terisi kalau "simpan detail" dinyalakan.
///
/// Sesi 60 menit menghasilkan 3.000-6.000 baris. SQLite santai menanganinya,
/// tapi kalau disimpan untuk setiap sesi, basis data ikut membengkak tanpa ada
/// yang membacanya. Karena itu bawaannya mati.
@DataClassName('AnswerRow')
class Answers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get elapsedMs => integer()();
  IntColumn get a => integer()();
  IntColumn get b => integer()();
  IntColumn get expected => integer()();
  IntColumn get given => integer()();
  IntColumn get responseMs => integer()();
}

/// Pengaturan aplikasi — satu baris, selalu `id = 0`.
@DataClassName('SettingsRow')
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get durationSec => integer().withDefault(const Constant(600))();
  BoolColumn get sound => boolean().withDefault(const Constant(true))();
  BoolColumn get haptics => boolean().withDefault(const Constant(true))();
  BoolColumn get includeZero => boolean().withDefault(const Constant(false))();
  BoolColumn get saveDetails => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Sessions, Segments, Answers, AppSettings])
class PauliDatabase extends _$PauliDatabase {
  PauliDatabase(super.e);

  PauliDatabase.defaults() : super(driftDatabase(name: 'pauliku'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Tanpa ini, `onDelete: cascade` di atas cuma jadi hiasan: SQLite
      // mematikan penegakan foreign key secara bawaan.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
