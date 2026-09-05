import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'db/database.dart';

/// Satu-satunya pintu antara layar dan basis data.
class SessionRepository {
  SessionRepository(this._db);

  final PauliDatabase _db;

  /// Menyimpan sesi beserta segmennya dalam satu transaksi. [rawAnswers] hanya
  /// ikut tersimpan kalau "simpan detail" dinyalakan di pengaturan.
  Future<void> save(
    PauliSession session, {
    List<AnswerRecord> rawAnswers = const [],
  }) async {
    await _db.transaction(() async {
      await _db
          .into(_db.sessions)
          .insert(
            SessionsCompanion.insert(
              id: session.id,
              startedAt: session.startedAt,
              durationSec: session.durationSec,
              intervalSec: session.intervalSec,
              seed: session.seed,
              interrupted: Value(session.interrupted),
              totalAnswered: session.totalAnswered,
              totalCorrect: session.totalCorrect,
              totalWrong: session.totalWrong,
              totalCorrections: session.totalCorrections,
            ),
          );

      await _db.batch((b) {
        b.insertAll(_db.segments, [
          for (final s in session.segments)
            SegmentsCompanion.insert(
              sessionId: session.id,
              idx: s.index,
              answered: s.answered,
              correct: s.correct,
              wrong: s.wrong,
              avgResponseMs: s.avgResponseMs,
            ),
        ]);

        b.insertAll(_db.answers, [
          for (final a in rawAnswers)
            AnswersCompanion.insert(
              sessionId: session.id,
              elapsedMs: a.elapsedMs,
              a: a.top,
              b: a.bottom,
              expected: a.expected,
              given: a.given,
              responseMs: a.responseMs,
            ),
        ]);
      });
    });
  }

  /// Sesi terbaru lebih dulu.
  Future<List<PauliSession>> recent({int limit = 100}) async {
    final rows =
        await (_db.select(_db.sessions)
              ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
              ..limit(limit))
            .get();
    if (rows.isEmpty) return const [];

    final ids = rows.map((r) => r.id).toList();
    final segRows =
        await (_db.select(_db.segments)
              ..where((t) => t.sessionId.isIn(ids))
              ..orderBy([(t) => OrderingTerm.asc(t.idx)]))
            .get();

    final grouped = <String, List<PauliSegment>>{};
    for (final s in segRows) {
      grouped.putIfAbsent(s.sessionId, () => []).add(
        PauliSegment(
          index: s.idx,
          answered: s.answered,
          correct: s.correct,
          wrong: s.wrong,
          avgResponseMs: s.avgResponseMs,
        ),
      );
    }

    return [
      for (final r in rows)
        PauliSession(
          id: r.id,
          startedAt: r.startedAt,
          durationSec: r.durationSec,
          intervalSec: r.intervalSec,
          seed: r.seed,
          interrupted: r.interrupted,
          totalAnswered: r.totalAnswered,
          totalCorrect: r.totalCorrect,
          totalWrong: r.totalWrong,
          totalCorrections: r.totalCorrections,
          segments: grouped[r.id] ?? const [],
        ),
    ];
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.sessions)..where((t) => t.id.equals(id))).go();
  }

  Future<int> count() async {
    final c = _db.sessions.id.count();
    final row = await (_db.selectOnly(_db.sessions)..addColumns([c]))
        .getSingle();
    return row.read(c) ?? 0;
  }

  // --- pengaturan ---

  Future<SessionConfig> loadConfig() async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    if (row == null) return const SessionConfig();
    return SessionConfig(
      durationSec: row.durationSec,
      sound: row.sound,
      haptics: row.haptics,
      includeZero: row.includeZero,
      saveDetails: row.saveDetails,
    );
  }

  Future<void> saveConfig(SessionConfig c) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            id: const Value(0),
            durationSec: Value(c.durationSec),
            sound: Value(c.sound),
            haptics: Value(c.haptics),
            includeZero: Value(c.includeZero),
            saveDetails: Value(c.saveDetails),
          ),
        );
  }
}
