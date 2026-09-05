import 'package:flutter_test/flutter_test.dart';
import 'package:pauliku/core/formatters.dart';

void main() {
  test('desimal memakai koma, bukan titik', () {
    expect(formatDecimal(44.8), '44,8');
    expect(formatDecimal(3.3145, digits: 2), '3,31');
  });

  group('tren bertanda', () {
    test('membawa tanda saat memang ada arahnya', () {
      expect(formatSigned(1.44), '+1,4');
      expect(formatSigned(-0.24), '−0,2');
    });

    test('kemiringan yang membulat jadi nol dibiarkan tanpa tanda', () {
      // "−0,0" menyiratkan penurunan yang tidak terbaca pada angka yang
      // ditampilkan; kurvanya landai, bukan menurun.
      expect(formatSigned(0), '0,0');
      expect(formatSigned(-0.04), '0,0');
      expect(formatSigned(0.04), '0,0');
    });
  });

  test('tanggal dan waktu dalam bahasa Indonesia', () {
    final d = DateTime(2026, 9, 1, 8, 5);
    expect(formatDate(d), '1 September 2026');
    expect(formatDateShort(d), '1 SEP 2026');
    expect(formatTime(d), '08:05');
  });

  test('tanggal relatif', () {
    final now = DateTime(2026, 9, 3, 12);
    expect(formatRelative(now.subtract(const Duration(seconds: 20)), now: now), 'baru saja');
    expect(formatRelative(now.subtract(const Duration(minutes: 5)), now: now), '5 menit lalu');
    expect(formatRelative(now.subtract(const Duration(hours: 3)), now: now), '3 jam lalu');
    expect(formatRelative(now.subtract(const Duration(days: 1)), now: now), 'kemarin');
    expect(formatRelative(now.subtract(const Duration(days: 2)), now: now), '2 hari lalu');
  });

  test('durasi dan sisa waktu', () {
    expect(formatDuration(600), '10 menit');
    expect(formatDuration(3600), '60 menit');
    expect(formatClock(const Duration(minutes: 12, seconds: 4)), '12:04');
  });
}
