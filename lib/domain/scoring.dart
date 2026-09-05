import 'dart:math';

import 'models.dart';

/// Arah tren kurva kerja.
enum TrendLabel {
  naik('menanjak'),
  landai('landai'),
  turun('menurun');

  const TrendLabel(this.text);
  final String text;
}

/// Semua angka ringkasan sebuah sesi, diturunkan dari daftar segmen.
///
/// Tidak ada tafsir kepribadian di sini dan memang tidak akan ada: yang
/// ditampilkan aplikasi cuma skor mentah dan kurvanya.
class SessionScore {
  final List<PauliSegment> segments;
  final int totalAnswered;
  final int totalCorrect;
  final int totalWrong;
  final int totalCorrections;

  const SessionScore({
    required this.segments,
    required this.totalAnswered,
    required this.totalCorrect,
    required this.totalWrong,
    required this.totalCorrections,
  });

  factory SessionScore.of(PauliSession s) => SessionScore(
    segments: s.segments,
    totalAnswered: s.totalAnswered,
    totalCorrect: s.totalCorrect,
    totalWrong: s.totalWrong,
    totalCorrections: s.totalCorrections,
  );

  List<int> get _perSegment => segments.map((e) => e.correct).toList();

  bool get isEmpty => segments.isEmpty;

  /// Kapasitas dan kecepatan keseluruhan.
  int get workload => totalCorrect;

  /// Kecermatan; turun tajam saat memaksakan kecepatan.
  double get accuracy =>
      totalAnswered == 0 ? 0 : totalCorrect / totalAnswered * 100;

  /// Kemampuan terbaik saat kondisi optimal.
  int get peak => isEmpty ? 0 : _perSegment.reduce(max);

  /// Titik paling jenuh.
  int get valley => isEmpty ? 0 : _perSegment.reduce(min);

  /// Kestabilan; makin kecil makin rata.
  int get range => peak - valley;

  /// Menit ke berapa puncaknya (1-based, kemunculan pertama).
  int get peakMinute => isEmpty ? 0 : _perSegment.indexOf(peak) + 1;

  /// Menit ke berapa lembahnya (1-based, kemunculan pertama).
  int get valleyMinute => isEmpty ? 0 : _perSegment.indexOf(valley) + 1;

  double get mean =>
      isEmpty ? 0 : _perSegment.reduce((a, b) => a + b) / segments.length;

  /// Keajegan; lebih tahan pencilan dibanding rentang. Simpangan baku populasi
  /// — segmennya memang seluruh populasi sesi ini, bukan sampel darinya.
  double get stdev {
    if (segments.length < 2) return 0;
    final m = mean;
    final sumSq = _perSegment
        .map((v) => (v - m) * (v - m))
        .reduce((a, b) => a + b);
    return sqrt(sumSq / segments.length);
  }

  /// Daya tahan: kemiringan regresi linier jawaban benar terhadap menit.
  /// Positif berarti masih kuat sampai akhir.
  double get trendSlope {
    final n = segments.length;
    if (n < 2) return 0;
    final my = mean;
    final mx = (n - 1) / 2;
    var num = 0.0;
    var den = 0.0;
    for (var i = 0; i < n; i++) {
      final dx = i - mx;
      num += dx * (_perSegment[i] - my);
      den += dx * dx;
    }
    return den == 0 ? 0 : num / den;
  }

  /// Ambang 0,5 jawaban per menit: di bawah itu, naik-turunnya kurva lebih
  /// masuk akal dibaca sebagai derau daripada sebagai arah.
  TrendLabel get trend {
    final s = trendSlope;
    if (s >= 0.5) return TrendLabel.naik;
    if (s <= -0.5) return TrendLabel.turun;
    return TrendLabel.landai;
  }

  /// Rata-rata waktu respons seluruh sesi, dibobot jumlah jawaban tiap segmen.
  double get avgResponseMs {
    if (totalAnswered == 0) return 0;
    var sum = 0.0;
    for (final s in segments) {
      sum += s.avgResponseMs * s.answered;
    }
    return sum / totalAnswered;
  }
}

/// Membagi jawaban mentah menjadi segmen per menit.
///
/// Selalu menghasilkan tepat [segmentCount] segmen, termasuk yang kosong —
/// kurva harus punya satu titik untuk tiap menit walaupun menitnya terlewat
/// tanpa satu jawaban pun.
List<PauliSegment> buildSegments(
  List<AnswerRecord> answers, {
  required int segmentCount,
  required int intervalSec,
}) {
  final intervalMs = intervalSec * 1000;
  final answered = List<int>.filled(segmentCount, 0);
  final correct = List<int>.filled(segmentCount, 0);
  final responseSum = List<double>.filled(segmentCount, 0);

  for (final a in answers) {
    var i = a.elapsedMs ~/ intervalMs;
    // Jawaban yang masuk tepat di detik terakhir dibulatkan ke segmen terakhir
    // alih-alih membuat segmen ke-n+1 yang tidak ada di kurva.
    if (i >= segmentCount) i = segmentCount - 1;
    if (i < 0) i = 0;
    answered[i]++;
    if (a.isCorrect) correct[i]++;
    responseSum[i] += a.responseMs;
  }

  return List<PauliSegment>.generate(segmentCount, (i) {
    return PauliSegment(
      index: i,
      answered: answered[i],
      correct: correct[i],
      wrong: answered[i] - correct[i],
      avgResponseMs: answered[i] == 0 ? 0 : responseSum[i] / answered[i],
    );
  });
}
