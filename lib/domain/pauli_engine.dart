import 'dart:math';

import 'models.dart';

/// Pembangkit deret Pauli.
///
/// Pauli bekerja pada **deret berantai**, bukan pasangan lepas. Dari deret
/// `a1 a2 a3 a4`, yang dijumlahkan adalah tetangganya, sehingga setiap angka
/// dipakai dua kali: sekali sebagai angka bawah, sekali sebagai angka atas.
///
/// ```
///   7   4   9   2
///   +---+   |   |     7+4 -> 1
///       +---+   |     4+9 -> 3
///           +---+     9+2 -> 1
/// ```
///
/// Kalau angka bawah tidak naik jadi angka atas, yang dibuat bukan tes Pauli
/// melainkan kuis penjumlahan biasa.
class PauliEngine {
  final Random _rng;
  final bool includeZero;
  int _top;

  PauliEngine(int seed, {this.includeZero = false})
    : _rng = Random(seed),
      _top = 0 {
    _top = _raw();
  }

  /// Angka atas soal berikutnya — sisa rantai dari soal sebelumnya.
  int get top => _top;

  /// Digit 1-9 secara bawaan. Angka 0 dimatikan karena penjumlahan dengan 0
  /// terasa "gratis" dan mengacaukan tempo; sediakan sebagai opsi.
  int _raw() => includeZero ? _rng.nextInt(10) : 1 + _rng.nextInt(9);

  /// Tolak angka baru yang sama persis dengan angka sebelumnya, supaya tidak
  /// muncul `5 5 5` beruntun yang terasa janggal.
  int _nextDistinctFrom(int prev) {
    var v = _raw();
    while (v == prev) {
      v = _raw();
    }
    return v;
  }

  /// Menghasilkan soal berikutnya sambil menggeser deret.
  Question advance() {
    final bottom = _nextDistinctFrom(_top);
    final q = Question(_top, bottom);
    _top = bottom; // <- di sinilah rantainya terjaga
    return q;
  }

  /// Membangkitkan `count` soal berurutan. Dipakai di tes unit dan nanti untuk
  /// fitur "ulangi deret yang sama".
  List<Question> take(int count) =>
      List<Question>.generate(count, (_) => advance());
}
