/// Pemformat angka dan tanggal dalam bahasa Indonesia.
///
/// Ditulis tangan alih-alih memakai `intl`: yang dibutuhkan cuma koma desimal,
/// nama bulan, dan tanggal relatif — tiga hal yang tidak sepadan dengan satu
/// paket tambahan beserta beban inisialisasi lokalnya.
library;

const List<String> _months = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> _monthsShort = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MEI',
  'JUN',
  'JUL',
  'AGU',
  'SEP',
  'OKT',
  'NOV',
  'DES',
];

/// `1 September 2026`
String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

/// `1 SEP 2026` — dipakai di kartu hasil.
String formatDateShort(DateTime d) =>
    '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

/// `08:32`
String formatTime(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

/// `2 hari lalu`, `baru saja`, ...
String formatRelative(DateTime d, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final diff = n.difference(d);
  if (diff.inMinutes < 1) return 'baru saja';
  if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
  if (diff.inHours < 24) return '${diff.inHours} jam lalu';
  if (diff.inDays == 1) return 'kemarin';
  if (diff.inDays < 30) return '${diff.inDays} hari lalu';
  if (diff.inDays < 365) return '${diff.inDays ~/ 30} bulan lalu';
  return '${diff.inDays ~/ 365} tahun lalu';
}

/// Desimal dengan koma, bukan titik: `44,8`.
String formatDecimal(double v, {int digits = 1}) =>
    v.toStringAsFixed(digits).replaceAll('.', ',');

/// Tren selalu dibawa tandanya, dengan minus tipografis: `\u22120,2` / `+1,4`.
///
/// Kemiringan yang membulat jadi nol dibiarkan tanpa tanda: `\u22120,0` menyiratkan
/// penurunan yang sebenarnya tidak terbaca pada angka yang ditampilkan.
String formatSigned(double v, {int digits = 1}) {
  final s = formatDecimal(v.abs(), digits: digits);
  final isZero = !s.contains(RegExp(r'[1-9]'));
  if (isZero) return s;
  return v > 0 ? '+$s' : '\u2212$s';
}

/// `10 menit`
String formatDuration(int seconds) => '${seconds ~/ 60} menit';

/// `12:04` — sisa waktu pada layar tes.
String formatClock(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}
