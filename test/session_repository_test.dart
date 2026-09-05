import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pauliku/data/db/database.dart';
import 'package:pauliku/data/session_repository.dart';
import 'package:pauliku/domain/models.dart';

PauliSession session({
  String id = 'a',
  List<int> perMinute = const [40, 44, 42],
  bool interrupted = false,
  DateTime? startedAt,
}) {
  final segments = [
    for (var i = 0; i < perMinute.length; i++)
      PauliSegment(
        index: i,
        answered: perMinute[i] + 1,
        correct: perMinute[i],
        wrong: 1,
        avgResponseMs: 1100 + i.toDouble(),
      ),
  ];
  return PauliSession(
    id: id,
    startedAt: startedAt ?? DateTime(2026, 9, 1, 8, 30),
    durationSec: perMinute.length * 60,
    intervalSec: 60,
    seed: 12345,
    interrupted: interrupted,
    totalAnswered: segments.fold(0, (a, s) => a + s.answered),
    totalCorrect: segments.fold(0, (a, s) => a + s.correct),
    totalWrong: segments.length,
    totalCorrections: 2,
    segments: segments,
  );
}

void main() {
  late PauliDatabase db;
  late SessionRepository repo;

  setUp(() {
    db = PauliDatabase(NativeDatabase.memory());
    repo = SessionRepository(db);
  });

  tearDown(() => db.close());

  test('sesi kembali utuh beserta segmennya', () async {
    await repo.save(session());
    final all = await repo.recent();

    expect(all, hasLength(1));
    final s = all.single;
    expect(s.id, 'a');
    expect(s.startedAt, DateTime(2026, 9, 1, 8, 30));
    expect(s.durationSec, 180);
    expect(s.intervalSec, 60);
    expect(s.seed, 12345);
    expect(s.totalCorrections, 2);
    expect(s.segments.map((e) => e.correct), [40, 44, 42]);
    expect(s.segments.map((e) => e.index), [0, 1, 2]);
    expect(s.segments.first.avgResponseMs, 1100);
  });

  test('riwayat berurutan dari yang terbaru', () async {
    await repo.save(session(id: 'lama', startedAt: DateTime(2026, 8, 1)));
    await repo.save(session(id: 'baru', startedAt: DateTime(2026, 9, 1)));
    await repo.save(session(id: 'tengah', startedAt: DateTime(2026, 8, 15)));

    final all = await repo.recent();
    expect(all.map((s) => s.id), ['baru', 'tengah', 'lama']);
  });

  test('detail jawaban hanya tersimpan kalau diminta', () async {
    final answers = [
      for (var i = 0; i < 5; i++)
        AnswerRecord(
          elapsedMs: i * 1000,
          top: 7,
          bottom: 4,
          given: 1,
          responseMs: 900,
        ),
    ];

    await repo.save(session(id: 'tanpa-detail'));
    expect(await db.select(db.answers).get(), isEmpty);

    await repo.save(session(id: 'dengan-detail'), rawAnswers: answers);
    final rows = await db.select(db.answers).get();
    expect(rows, hasLength(5));
    expect(rows.first.sessionId, 'dengan-detail');
    expect(rows.first.expected, 1);
    expect(rows.first.given, 1);
  });

  test('menghapus sesi ikut menghapus segmen dan jawabannya', () async {
    await repo.save(
      session(id: 'x'),
      rawAnswers: [
        const AnswerRecord(
          elapsedMs: 0,
          top: 1,
          bottom: 2,
          given: 3,
          responseMs: 500,
        ),
      ],
    );
    expect(await repo.count(), 1);

    await repo.delete('x');

    expect(await repo.count(), 0);
    expect(await db.select(db.segments).get(), isEmpty);
    // Kalau `PRAGMA foreign_keys` tidak menyala, baris ini akan tertinggal
    // sebagai sampah yang tidak bisa dijangkau lagi.
    expect(await db.select(db.answers).get(), isEmpty);
  });

  test('sesi terganggu tetap tersimpan dan tetap bertanda', () async {
    await repo.save(session(id: 'terganggu', interrupted: true));
    final s = (await repo.recent()).single;
    expect(s.interrupted, isTrue);
  });

  group('pengaturan', () {
    test('bawaan dipakai sebelum ada yang disimpan', () async {
      final c = await repo.loadConfig();
      expect(c.durationSec, 600);
      expect(c.sound, isTrue);
      expect(c.haptics, isTrue);
      expect(c.includeZero, isFalse);
      expect(c.saveDetails, isFalse);
    });

    test('pilihan terakhir yang bertahan, bukan bertumpuk', () async {
      await repo.saveConfig(
        const SessionConfig(durationSec: 3600, includeZero: true),
      );
      await repo.saveConfig(
        const SessionConfig(durationSec: 300, saveDetails: true),
      );

      final c = await repo.loadConfig();
      expect(c.durationSec, 300);
      expect(c.includeZero, isFalse);
      expect(c.saveDetails, isTrue);

      // Satu baris saja, bukan satu baris tiap kali disimpan.
      expect(await db.select(db.appSettings).get(), hasLength(1));
    });
  });
}
