import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pauliku/domain/models.dart';
import 'package:pauliku/domain/scoring.dart';
import 'package:pauliku/features/test/test_controller.dart';

/// Menjalankan sesi di dalam waktu palsu.
///
/// Inilah sebabnya stopwatch di controller diambil dari `package:clock`: sesi
/// 60 menit bisa dijalankan penuh dalam beberapa milidetik, sehingga pembagian
/// segmennya bisa benar-benar diuji, bukan cuma diandaikan.
void runSession(
  SessionConfig config,
  void Function(TestController c, FakeAsync async) body,
) {
  fakeAsync((async) {
    final c = TestController(config: config, seed: 42);
    c.startCountdown();
    async.elapse(const Duration(seconds: 3)); // hitung mundur
    expect(c.phase, TestPhase.running);
    body(c, async);
    c.dispose();
  });
}

const config10 = SessionConfig(
  durationSec: 600,
  sound: false,
  haptics: false,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('hitung mundur', () {
    test('tes belum berjalan sebelum hitungan habis', () {
      fakeAsync((async) {
        final c = TestController(config: config10, seed: 1);
        expect(c.phase, TestPhase.countdown);
        expect(c.countdown, 3);

        c.startCountdown();
        async.elapse(const Duration(seconds: 2));
        expect(c.phase, TestPhase.countdown);

        // Jawaban sebelum aba-aba mulai tidak boleh tercatat.
        c.answer(5);
        expect(c.answeredCount, 0);

        async.elapse(const Duration(seconds: 1));
        expect(c.phase, TestPhase.running);
        c.dispose();
      });
    });
  });

  group('deret di layar', () {
    test('angka bawah naik jadi angka atas setelah dijawab', () {
      runSession(config10, (c, async) {
        final first = c.current;
        c.answer(first.answer);
        expect(c.current.top, first.bottom);
      });
    });

    test('undo mengembalikan soal yang sama, bukan soal baru', () {
      runSession(config10, (c, async) {
        final q = c.current;
        c.answer(9);
        expect(c.answeredCount, 1);

        c.undo();
        expect(c.answeredCount, 0);
        expect(c.corrections, 1);
        expect(c.current.top, q.top);
        expect(c.current.bottom, q.bottom);
      });
    });

    test('undo tidak meninggalkan jejak di hasil selain pembetulan', () {
      runSession(config10, (c, async) {
        c.answer(0);
        c.undo();
        async.elapse(const Duration(minutes: 10));

        final s = c.buildSession();
        expect(s.totalAnswered, 0);
        expect(s.totalWrong, 0);
        expect(s.totalCorrections, 1);
      });
    });
  });

  group('segmen dan durasi', () {
    test('jawaban jatuh di menit tempat ia ditekan', () {
      runSession(config10, (c, async) {
        c.answer(c.current.answer); // menit 1
        async.elapse(const Duration(minutes: 3));
        c.answer(c.current.answer); // menit 4
        async.elapse(const Duration(minutes: 7));

        final s = c.buildSession();
        expect(s.segments[0].answered, 1);
        expect(s.segments[3].answered, 1);
        expect(s.totalAnswered, 2);
      });
    });

    test('label menit ikut bergeser tiap 60 detik', () {
      runSession(config10, (c, async) {
        expect(c.minute, 1);
        async.elapse(const Duration(seconds: 59));
        expect(c.minute, 1);
        async.elapse(const Duration(seconds: 2));
        expect(c.minute, 2);
      });
    });

    test('aba-aba garis berbunyi sekali tiap menit, tanpa aba-aba penutup', () {
      runSession(config10, (c, async) {
        async.elapse(const Duration(minutes: 10));
        // Sesi 10 menit: garis di menit 2 sampai 10, sembilan kali. Menit
        // pertama tidak didahului garis dan menit terakhir ditutup oleh
        // berakhirnya sesi, bukan oleh garis.
        expect(c.lineTick.value, 9);
      });
    });

    test('sesi berhenti sendiri tepat pada durasinya', () {
      runSession(config10, (c, async) {
        async.elapse(const Duration(minutes: 9, seconds: 59));
        expect(c.phase, TestPhase.running);
        async.elapse(const Duration(seconds: 1));
        expect(c.phase, TestPhase.finished);
      });
    });

    test('sesi 60 menit menghasilkan tepat 60 titik kurva', () {
      runSession(const SessionConfig(durationSec: 3600, sound: false, haptics: false), (
        c,
        async,
      ) {
        async.elapse(const Duration(minutes: 60));
        final s = c.buildSession();
        expect(s.segments.length, 60);
        expect(s.durationSec, 3600);
        expect(s.intervalSec, 60);
      });
    });

    test('jawaban terus-menerus selama sepuluh menit tersebar rata', () {
      runSession(config10, (c, async) {
        // Satu jawaban tiap dua detik selama sepuluh menit.
        for (var i = 0; i < 300; i++) {
          c.answer(c.current.answer);
          async.elapse(const Duration(seconds: 2));
        }
        final s = c.buildSession();
        expect(s.totalAnswered, 300);
        expect(s.totalCorrect, 300);
        expect(s.segments.length, 10);
        expect(s.segments.every((seg) => seg.answered == 30), isTrue);
        expect(SessionScore.of(s).workload, 300);
      });
    });
  });

  group('gangguan', () {
    test('waktu berhenti selama aplikasi di latar belakang', () {
      runSession(config10, (c, async) {
        async.elapse(const Duration(minutes: 2));
        c.pauseForBackground();

        async.elapse(const Duration(minutes: 30));
        expect(c.phase, TestPhase.paused);
        expect(c.elapsed.value.inMinutes, 2);

        c.resume();
        async.elapse(const Duration(minutes: 1));
        expect(c.elapsed.value.inMinutes, 3);
      });
    });

    test('sesi yang sempat terjeda ditandai terganggu', () {
      runSession(config10, (c, async) {
        expect(c.interrupted, isFalse);
        c.pauseForBackground();
        c.resume();
        async.elapse(const Duration(minutes: 10));
        expect(c.buildSession().interrupted, isTrue);
      });
    });

    test('jawaban ditolak selagi terjeda', () {
      runSession(config10, (c, async) {
        c.pauseForBackground();
        c.answer(1);
        c.undo();
        expect(c.answeredCount, 0);
        expect(c.corrections, 0);
      });
    });
  });

  group('hasil', () {
    test('benar dan salah dipisahkan dengan tepat', () {
      runSession(config10, (c, async) {
        for (var i = 0; i < 10; i++) {
          final q = c.current;
          // Lima jawaban pertama benar, lima berikutnya sengaja meleset.
          c.answer(i < 5 ? q.answer : (q.answer + 1) % 10);
          async.elapse(const Duration(seconds: 1));
        }
        async.elapse(const Duration(minutes: 10));

        final s = c.buildSession();
        expect(s.totalAnswered, 10);
        expect(s.totalCorrect, 5);
        expect(s.totalWrong, 5);
        expect(SessionScore.of(s).accuracy, 50);
      });
    });

    test('seed ikut tersimpan supaya deretnya bisa dibangkitkan ulang', () {
      runSession(config10, (c, async) {
        async.elapse(const Duration(minutes: 10));
        expect(c.buildSession().seed, 42);
      });
    });
  });
}
