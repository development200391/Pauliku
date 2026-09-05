import 'package:flutter_test/flutter_test.dart';
import 'package:pauliku/domain/models.dart';
import 'package:pauliku/domain/scoring.dart';

/// Membuat satu jawaban pada detik [second], benar atau salah sesuai [correct].
AnswerRecord answerAt(int second, {bool correct = true, int responseMs = 900}) {
  const top = 7;
  const bottom = 4; // jawaban benarnya 1
  return AnswerRecord(
    elapsedMs: second * 1000,
    top: top,
    bottom: bottom,
    given: correct ? 1 : 2,
    responseMs: responseMs,
  );
}

SessionScore scoreOf(List<int> perMinute, {int answeredPerMinute = 0}) {
  final segments = [
    for (var i = 0; i < perMinute.length; i++)
      PauliSegment(
        index: i,
        answered: answeredPerMinute == 0 ? perMinute[i] : answeredPerMinute,
        correct: perMinute[i],
        wrong: (answeredPerMinute == 0 ? perMinute[i] : answeredPerMinute) -
            perMinute[i],
        avgResponseMs: 1000,
      ),
  ];
  final answered = segments.fold(0, (a, s) => a + s.answered);
  final correct = segments.fold(0, (a, s) => a + s.correct);
  return SessionScore(
    segments: segments,
    totalAnswered: answered,
    totalCorrect: correct,
    totalWrong: answered - correct,
    totalCorrections: 0,
  );
}

void main() {
  group('buildSegments', () {
    test('membagi jawaban ke menit yang benar', () {
      final answers = [
        answerAt(0),
        answerAt(59),
        answerAt(60), // sudah menit kedua
        answerAt(119),
        answerAt(120),
      ];
      final segs = buildSegments(answers, segmentCount: 3, intervalSec: 60);
      expect(segs.map((s) => s.answered), [2, 2, 1]);
    });

    test('selalu menghasilkan satu titik per menit, termasuk yang kosong', () {
      final segs = buildSegments(
        [answerAt(0)],
        segmentCount: 10,
        intervalSec: 60,
      );
      expect(segs.length, 10);
      expect(segs.skip(1).every((s) => s.answered == 0), isTrue);
      expect(segs.skip(1).every((s) => s.avgResponseMs == 0), isTrue);
    });

    test('jawaban di detik terakhir masuk segmen terakhir, bukan segmen baru', () {
      // Jawaban tepat pada milidetik ke-600.000 pada sesi 10 menit.
      final answers = [
        AnswerRecord(
          elapsedMs: 600000,
          top: 1,
          bottom: 2,
          given: 3,
          responseMs: 500,
        ),
      ];
      final segs = buildSegments(answers, segmentCount: 10, intervalSec: 60);
      expect(segs.length, 10);
      expect(segs.last.answered, 1);
    });

    test('memisahkan benar dan salah', () {
      final answers = [
        answerAt(0),
        answerAt(1, correct: false),
        answerAt(2),
      ];
      final segs = buildSegments(answers, segmentCount: 1, intervalSec: 60);
      expect(segs.single.answered, 3);
      expect(segs.single.correct, 2);
      expect(segs.single.wrong, 1);
    });

    test('rata-rata waktu respons dihitung per segmen', () {
      final answers = [
        answerAt(0, responseMs: 800),
        answerAt(10, responseMs: 1200),
        answerAt(70, responseMs: 500),
      ];
      final segs = buildSegments(answers, segmentCount: 2, intervalSec: 60);
      expect(segs[0].avgResponseMs, 1000);
      expect(segs[1].avgResponseMs, 500);
    });
  });

  group('metrik ringkasan', () {
    final s = scoreOf([41, 44, 48, 45, 50, 47, 44, 39, 42, 48]);

    test('jumlah kerja adalah total benar', () {
      expect(s.workload, 448);
    });

    test('puncak, lembah, dan rentang', () {
      expect(s.peak, 50);
      expect(s.valley, 39);
      expect(s.range, 11);
      expect(s.peakMinute, 5);
      expect(s.valleyMinute, 8);
    });

    test('rata-rata', () {
      expect(s.mean, closeTo(44.8, 0.001));
    });

    test('ketelitian', () {
      final t = scoreOf([9, 9], answeredPerMinute: 10);
      expect(t.accuracy, closeTo(90, 0.001));
    });

    test('simpangan baku populasi', () {
      // Nilai [2, 4, 4, 4, 5, 5, 7, 9] punya simpangan populasi tepat 2.
      final t = scoreOf([2, 4, 4, 4, 5, 5, 7, 9]);
      expect(t.stdev, closeTo(2, 0.000001));
    });
  });

  group('tren', () {
    test('deret naik lurus menghasilkan kemiringan persis', () {
      final s = scoreOf([10, 12, 14, 16, 18]);
      expect(s.trendSlope, closeTo(2, 0.000001));
      expect(s.trend, TrendLabel.naik);
    });

    test('deret turun lurus menghasilkan kemiringan negatif', () {
      final s = scoreOf([20, 17, 14, 11, 8]);
      expect(s.trendSlope, closeTo(-3, 0.000001));
      expect(s.trend, TrendLabel.turun);
    });

    test('kurva datar dibaca landai', () {
      final s = scoreOf([30, 30, 30, 30]);
      expect(s.trendSlope, 0);
      expect(s.trend, TrendLabel.landai);
      expect(s.stdev, 0);
      expect(s.range, 0);
    });

    test('goyangan kecil tetap dibaca landai, bukan arah', () {
      final s = scoreOf([44, 45, 44, 45, 44, 45]);
      expect(s.trend, TrendLabel.landai);
    });
  });

  group('kasus batas', () {
    test('sesi tanpa satu pun jawaban tidak meledak', () {
      final segs = buildSegments([], segmentCount: 5, intervalSec: 60);
      final s = SessionScore(
        segments: segs,
        totalAnswered: 0,
        totalCorrect: 0,
        totalWrong: 0,
        totalCorrections: 0,
      );
      expect(s.workload, 0);
      expect(s.accuracy, 0);
      expect(s.peak, 0);
      expect(s.valley, 0);
      expect(s.range, 0);
      expect(s.stdev, 0);
      expect(s.trendSlope, 0);
      expect(s.avgResponseMs, 0);
    });

    test('satu segmen: tidak ada simpangan dan tidak ada tren', () {
      final s = scoreOf([42]);
      expect(s.stdev, 0);
      expect(s.trendSlope, 0);
      expect(s.peak, 42);
      expect(s.valley, 42);
    });
  });

  group('SessionScore.of', () {
    test('membaca angka total dari sesi, bukan menghitung ulang', () {
      final session = PauliSession(
        id: 'x',
        startedAt: DateTime(2026, 9, 1),
        durationSec: 120,
        intervalSec: 60,
        seed: 1,
        interrupted: false,
        totalAnswered: 100,
        totalCorrect: 96,
        totalWrong: 4,
        totalCorrections: 3,
        segments: const [
          PauliSegment(
            index: 0,
            answered: 50,
            correct: 48,
            wrong: 2,
            avgResponseMs: 1000,
          ),
          PauliSegment(
            index: 1,
            answered: 50,
            correct: 48,
            wrong: 2,
            avgResponseMs: 1400,
          ),
        ],
      );
      final s = SessionScore.of(session);
      expect(s.workload, 96);
      expect(s.accuracy, closeTo(96, 0.001));
      expect(s.avgResponseMs, closeTo(1200, 0.001));
    });
  });
}
