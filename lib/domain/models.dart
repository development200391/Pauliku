/// Model inti PauliKu.
///
/// Berkas di dalam `domain/` sengaja Dart murni: tidak ada satu pun impor
/// Flutter di sini. Batas itu yang membuat seluruh rumus skoring bisa diuji
/// dengan `flutter test` dalam hitungan detik, tanpa emulator.
library;

/// Satu soal Pauli: dua angka bertumpuk, jawabannya digit terakhir jumlahnya.
class Question {
  final int top;
  final int bottom;

  const Question(this.top, this.bottom);

  /// `7 + 4 = 11` -> `1`. Jumlah maksimum 9+9=18, jadi selalu satu digit.
  int get answer => (top + bottom) % 10;

  @override
  String toString() => '$top+$bottom=$answer';
}

/// Satu ketukan jawaban yang tercatat selama tes.
class AnswerRecord {
  /// Waktu jawaban ditekan, dihitung dari stopwatch sesi.
  final int elapsedMs;
  final int top;
  final int bottom;
  final int given;

  /// Jarak waktu dari jawaban sebelumnya (atau dari awal sesi).
  final int responseMs;

  const AnswerRecord({
    required this.elapsedMs,
    required this.top,
    required this.bottom,
    required this.given,
    required this.responseMs,
  });

  int get expected => (top + bottom) % 10;
  bool get isCorrect => given == expected;
}

/// Hasil satu segmen — satu segmen sama dengan satu menit, jadi satu segmen
/// juga sama dengan satu titik pada kurva kerja.
class PauliSegment {
  final int index; // 0..n-1
  final int answered;
  final int correct;
  final int wrong;
  final double avgResponseMs;

  const PauliSegment({
    required this.index,
    required this.answered,
    required this.correct,
    required this.wrong,
    required this.avgResponseMs,
  });

  /// Menit ke berapa segmen ini, untuk ditampilkan (1-based).
  int get minute => index + 1;
}

/// Satu sesi latihan yang sudah selesai.
class PauliSession {
  final String id;
  final DateTime startedAt;
  final int durationSec; // 600, 3600, ...
  final int intervalSec; // selalu 60; disimpan supaya sesi lama tetap terbaca
  //                        kalau aturannya berubah
  final int seed; // supaya deret bisa dibangkitkan ulang
  final bool interrupted; // sempat masuk latar belakang
  final int totalAnswered;
  final int totalCorrect;
  final int totalWrong;
  final int totalCorrections;
  final List<PauliSegment> segments;

  const PauliSession({
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
    required this.segments,
  });

  int get durationMinutes => durationSec ~/ 60;
}

/// Pengaturan sesi yang dipilih di layar sebelum tes dimulai.
class SessionConfig {
  final int durationSec;
  final bool sound;
  final bool haptics;
  final bool includeZero;
  final bool saveDetails;

  const SessionConfig({
    this.durationSec = 600,
    this.sound = true,
    this.haptics = true,
    this.includeZero = false,
    this.saveDetails = false,
  });

  /// Garis jatuh tiap menit, selalu. Bukan pengaturan.
  static const int intervalSec = 60;

  /// Satu menit = satu titik kurva, jadi jumlah titik selalu sama dengan
  /// durasi dalam menit.
  int get segmentCount => durationSec ~/ intervalSec;

  static const List<int> durationChoices = [300, 600, 1200, 1800, 3600];

  SessionConfig copyWith({
    int? durationSec,
    bool? sound,
    bool? haptics,
    bool? includeZero,
    bool? saveDetails,
  }) {
    return SessionConfig(
      durationSec: durationSec ?? this.durationSec,
      sound: sound ?? this.sound,
      haptics: haptics ?? this.haptics,
      includeZero: includeZero ?? this.includeZero,
      saveDetails: saveDetails ?? this.saveDetails,
    );
  }
}
