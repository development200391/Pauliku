import 'package:flutter_test/flutter_test.dart';
import 'package:pauliku/domain/pauli_engine.dart';

void main() {
  group('deret berantai', () {
    test('angka bawah selalu naik jadi angka atas soal berikutnya', () {
      final qs = PauliEngine(1).take(200);
      for (var i = 1; i < qs.length; i++) {
        expect(
          qs[i].top,
          qs[i - 1].bottom,
          reason: 'rantai putus di soal ke-$i',
        );
      }
    });

    test('setiap angka di tengah deret dipakai pada dua soal', () {
      final qs = PauliEngine(7).take(50);
      // Deretnya: top soal pertama, lalu semua bottom.
      final deret = [qs.first.top, for (final q in qs) q.bottom];
      expect(deret.length, qs.length + 1);
      for (var i = 1; i < deret.length - 1; i++) {
        expect(qs[i - 1].bottom, deret[i]); // sebagai angka bawah
        expect(qs[i].top, deret[i]); // lalu sebagai angka atas
      }
    });
  });

  group('pembangkit angka', () {
    test('bawaannya 1-9, tanpa nol', () {
      for (final q in PauliEngine(3).take(500)) {
        expect(q.top, inInclusiveRange(1, 9));
        expect(q.bottom, inInclusiveRange(1, 9));
      }
    });

    test('nol ikut kalau dinyalakan', () {
      final digits = {
        for (final q in PauliEngine(11, includeZero: true).take(1000)) q.bottom,
      };
      expect(digits, contains(0));
      expect(digits.every((d) => d >= 0 && d <= 9), isTrue);
    });

    test('tidak pernah ada angka kembar beruntun', () {
      for (final q in PauliEngine(5).take(1000)) {
        expect(q.top == q.bottom, isFalse, reason: 'muncul $q');
      }
      for (final q in PauliEngine(5, includeZero: true).take(1000)) {
        expect(q.top == q.bottom, isFalse, reason: 'muncul $q');
      }
    });
  });

  group('jawaban', () {
    test('selalu digit terakhir dari jumlahnya', () {
      for (final q in PauliEngine(9).take(500)) {
        expect(q.answer, (q.top + q.bottom) % 10);
        expect(q.answer, inInclusiveRange(0, 9));
      }
    });

    test('contoh dari README', () {
      // 7 + 4 = 11 -> 1, 4 + 9 = 13 -> 3
      expect((7 + 4) % 10, 1);
      expect((4 + 9) % 10, 3);
    });
  });

  group('seed', () {
    test('seed yang sama membangkitkan deret yang sama persis', () {
      final a = PauliEngine(20260901).take(300);
      final b = PauliEngine(20260901).take(300);
      expect(a.map((q) => '$q'), b.map((q) => '$q'));
    });

    test('seed berbeda membangkitkan deret berbeda', () {
      final a = PauliEngine(1).take(100).map((q) => '$q').join();
      final b = PauliEngine(2).take(100).map((q) => '$q').join();
      expect(a, isNot(b));
    });
  });
}
