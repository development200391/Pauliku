import 'dart:async';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/models.dart';
import '../../domain/pauli_engine.dart';
import '../../domain/scoring.dart';

enum TestPhase { countdown, running, paused, finished }

/// Mesin waktu layar tes: stopwatch, pembagian segmen, aba-aba garis.
class TestController extends ChangeNotifier {
  TestController({required this.config, int? seed})
    : seed = seed ?? DateTime.now().microsecondsSinceEpoch & 0x7fffffff {
    _engine = PauliEngine(this.seed, includeZero: config.includeZero);
    _asked.add(_engine.advance());
  }

  final SessionConfig config;
  final int seed;

  late final PauliEngine _engine;

  /// Sumber kebenaran satu-satunya untuk waktu.
  ///
  /// Jangan pernah menumpuk hitungan dari tick timer: tiap tick meleset
  /// beberapa milidetik, dan dalam 60 menit akumulasinya bisa puluhan detik —
  /// cukup untuk membuat seluruh pembagian segmen berantakan. Timer di bawah
  /// hanya memicu pengecekan; angka waktunya selalu dibaca dari sini.
  ///
  /// Diambil dari `package:clock` alih-alih `Stopwatch()` langsung, supaya
  /// sesi 60 menit bisa diuji dalam milidetik: di dalam `fakeAsync`, stopwatch
  /// ini ikut maju bersama waktu palsu.
  final Stopwatch _watch = clock.stopwatch();
  Timer? _ticker;
  Timer? _countdownTimer;

  final List<Question> _asked = [];
  final List<AnswerRecord> _answers = [];
  int _corrections = 0;
  int _lastAnswerMs = 0;
  int _segment = 0;

  TestPhase _phase = TestPhase.countdown;
  TestPhase get phase => _phase;

  int _countdown = 3;
  int get countdown => _countdown;

  bool _interrupted = false;
  bool get interrupted => _interrupted;

  DateTime? _startedAt;

  /// Dipisah dari [notifyListeners] supaya tick 100 ms cuma menggambar ulang
  /// label menit dan bilah kemajuan — bukan seluruh numpad.
  final ValueNotifier<Duration> elapsed = ValueNotifier(Duration.zero);

  /// Naik satu tiap garis jatuh; layar memakainya untuk memicu animasi kilat.
  final ValueNotifier<int> lineTick = ValueNotifier(0);

  Question get current => _asked[_answers.length];
  int get answeredCount => _answers.length;
  int get corrections => _corrections;

  int get segmentIndex => _segment;
  int get minute => _segment + 1;
  int get totalMinutes => config.segmentCount;

  double get progress =>
      (elapsed.value.inMilliseconds / (config.durationSec * 1000)).clamp(
        0.0,
        1.0,
      );

  Duration get remaining {
    final left = config.durationSec * 1000 - elapsed.value.inMilliseconds;
    return Duration(milliseconds: max(0, left));
  }

  // --- daur hidup sesi ---

  /// Hitung mundur tiga detik. Bukan hiasan: tanpa itu soal pertama muncul saat
  /// jempol masih dalam perjalanan, dan segmen pertama selalu terlihat lebih
  /// rendah dari yang sebenarnya.
  void startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _countdown--;
      if (_countdown <= 0) {
        t.cancel();
        _begin();
      }
      notifyListeners();
    });
  }

  void _begin() {
    _startedAt = clock.now();
    _phase = TestPhase.running;
    _watch.start();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
    notifyListeners();
  }

  void _tick() {
    if (_phase != TestPhase.running) return;
    final e = _watch.elapsed;
    elapsed.value = e;

    if (e.inMilliseconds >= config.durationSec * 1000) {
      finish();
      return;
    }

    final seg = e.inMilliseconds ~/ (SessionConfig.intervalSec * 1000);
    if (seg > _segment) {
      _segment = seg;
      _onLine();
      notifyListeners();
    }
  }

  /// Aba-aba garis. Bukan jeda — pengerjaan tidak berhenti, segmennya berganti
  /// diam-diam di belakang layar.
  void _onLine() {
    if (config.haptics) HapticFeedback.mediumImpact();
    if (config.sound) SystemSound.play(SystemSoundType.click);
    lineTick.value++;
  }

  // --- jawaban ---

  void answer(int digit) {
    if (_phase != TestPhase.running) return;
    final ms = _watch.elapsedMilliseconds;
    final q = current;
    _answers.add(
      AnswerRecord(
        elapsedMs: ms,
        top: q.top,
        bottom: q.bottom,
        given: digit,
        responseMs: ms - _lastAnswerMs,
      ),
    );
    _lastAnswerMs = ms;
    if (_answers.length >= _asked.length) _asked.add(_engine.advance());
    notifyListeners();
  }

  /// Tombol hapus: menarik kembali jawaban terakhir supaya bisa diulang.
  /// Jumlahnya dicatat sebagai pembetulan — penanda keragu-raguan.
  void undo() {
    if (_phase != TestPhase.running || _answers.isEmpty) return;
    _answers.removeLast();
    _corrections++;
    _lastAnswerMs = _answers.isEmpty ? 0 : _answers.last.elapsedMs;
    notifyListeners();
  }

  // --- gangguan di tengah tes ---

  /// Sesi 60 menit hampir pasti kena telepon atau notifikasi. Sesi yang sempat
  /// masuk latar belakang ditandai dan dikecualikan dari grafik tren, supaya
  /// rata-rata jangka panjang tidak tercemar.
  void pauseForBackground() {
    if (_phase != TestPhase.running) return;
    _watch.stop();
    _phase = TestPhase.paused;
    _interrupted = true;
    notifyListeners();
  }

  void resume() {
    if (_phase != TestPhase.paused) return;
    _watch.start();
    _phase = TestPhase.running;
    notifyListeners();
  }

  void finish() {
    if (_phase == TestPhase.finished) return;
    _watch.stop();
    _ticker?.cancel();
    _countdownTimer?.cancel();
    elapsed.value = Duration(
      milliseconds: min(
        _watch.elapsedMilliseconds,
        config.durationSec * 1000,
      ),
    );
    _phase = TestPhase.finished;
    notifyListeners();
  }

  // --- hasil ---

  List<AnswerRecord> get rawAnswers => List.unmodifiable(_answers);

  PauliSession buildSession() {
    final started = _startedAt ?? clock.now();
    final segments = buildSegments(
      _answers,
      segmentCount: config.segmentCount,
      intervalSec: SessionConfig.intervalSec,
    );
    final correct = _answers.where((a) => a.isCorrect).length;
    return PauliSession(
      id: '${started.microsecondsSinceEpoch}-$seed',
      startedAt: started,
      durationSec: config.durationSec,
      intervalSec: SessionConfig.intervalSec,
      seed: seed,
      interrupted: _interrupted,
      totalAnswered: _answers.length,
      totalCorrect: correct,
      totalWrong: _answers.length - correct,
      totalCorrections: _corrections,
      segments: segments,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _countdownTimer?.cancel();
    elapsed.dispose();
    lineTick.dispose();
    super.dispose();
  }
}
