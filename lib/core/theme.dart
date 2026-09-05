import 'package:flutter/material.dart';

/// Palet dari bagian "Identitas visual" di README.
abstract final class PauliColors {
  /// Latar ikon dan tema gelap kartu hasil.
  static const dark = Color(0xFF101A18);

  /// Aksen tema terang, tombol utama.
  static const green = Color(0xFF0F6B57);

  /// Busur ikon, garis kurva di tema gelap.
  static const greenBright = Color(0xFF4ECFA8);

  /// Titik puncak, angka yang dipakai dua kali.
  static const amber = Color(0xFFE9A13B);

  /// Latar terang, teks di atas hijau.
  static const cream = Color(0xFFF0EDE3);

  /// Permukaan kartu — sedikit lebih terang dari latar supaya kartunya naik.
  static const card = Color(0xFFFBFAF5);

  static const ink = Color(0xFF15201E);
  static const inkSoft = Color(0xFF6B7570);
  static const line = Color(0xFFDDD8CA);
}

abstract final class PauliSizes {
  /// Di kecepatan satu ketukan per detik, tombol kecil menghasilkan salah
  /// tekan yang terbaca sebagai "tidak teliti" padahal cuma masalah tata letak.
  static const double minTap = 56;
  static const double gutter = 20;
  static const double radius = 14;
}

/// Angka di seluruh aplikasi memakai typeface monospace supaya lebarnya tetap
/// dan tidak "bergoyang" saat berganti soal.
const String kMonoFamily = 'monospace';

const List<String> kMonoFallback = [
  'RobotoMono',
  'Menlo',
  'Consolas',
  'Courier New',
  'monospace',
];

TextStyle mono({
  double size = 16,
  FontWeight weight = FontWeight.w500,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: kMonoFamily,
    fontFamilyFallback: kMonoFallback,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

ThemeData buildPauliTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: PauliColors.green,
    primary: PauliColors.green,
    onPrimary: PauliColors.cream,
    secondary: PauliColors.amber,
    surface: PauliColors.cream,
    onSurface: PauliColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: PauliColors.cream,
    splashFactory: InkRipple.splashFactory,
    appBarTheme: const AppBarTheme(
      backgroundColor: PauliColors.cream,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: PauliColors.ink,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: PauliColors.ink),
    ),
    cardTheme: CardThemeData(
      color: PauliColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PauliSizes.radius + 2),
        side: const BorderSide(color: PauliColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: PauliColors.green,
        foregroundColor: PauliColors.cream,
        minimumSize: const Size.fromHeight(60),
        textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PauliSizes.radius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: PauliColors.ink,
        backgroundColor: PauliColors.card,
        minimumSize: const Size.fromHeight(60),
        side: const BorderSide(color: PauliColors.line),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PauliSizes.radius),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? PauliColors.cream
            : PauliColors.card,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? PauliColors.green
            : PauliColors.line,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    dividerTheme: const DividerThemeData(
      color: PauliColors.line,
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: PauliColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: PauliColors.ink,
      ),
      bodyMedium: TextStyle(fontSize: 15, color: PauliColors.ink),
      bodySmall: TextStyle(fontSize: 13, color: PauliColors.inkSoft),
    ),
  );
}

/// Label kecil huruf kapital berjarak, dipakai di atas tiap bagian.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: mono(
        size: 12,
        weight: FontWeight.w600,
        color: PauliColors.inkSoft,
        letterSpacing: 2,
      ),
    );
  }
}
