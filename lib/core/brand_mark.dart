import 'package:flutter/material.dart';

import 'theme.dart';

/// Ikon PauliKu, digambar ulang dari `docs/icon.svg`.
///
/// Dua busur berbagi satu titik di tengah — titik kuning itu adalah angka yang
/// dipakai dua kali. Digambar dengan [CustomPainter] alih-alih memuat SVG:
/// bentuknya cuma dua kurva dan tiga lingkaran, tidak sepadan dengan satu
/// paket dan satu berkas aset lagi.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MarkPainter()),
    );
  }
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 120; // koordinat asli 120 x 120
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(27 * s),
    );
    canvas.drawRRect(rrect, Paint()..color = PauliColors.dark);

    final arc = Paint()
      ..color = PauliColors.greenBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * s
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(24 * s, 58 * s)
      ..quadraticBezierTo(42 * s, 100 * s, 60 * s, 58 * s)
      ..moveTo(60 * s, 58 * s)
      ..quadraticBezierTo(78 * s, 100 * s, 96 * s, 58 * s);
    canvas.drawPath(path, arc);

    final cream = Paint()..color = PauliColors.cream;
    canvas.drawCircle(Offset(24 * s, 50 * s), 6.5 * s, cream);
    canvas.drawCircle(Offset(96 * s, 50 * s), 6.5 * s, cream);

    // Cincin gelap memisahkan titik tengah dari busur di belakangnya.
    canvas.drawCircle(
      Offset(60 * s, 50 * s),
      13 * s,
      Paint()..color = PauliColors.dark,
    );
    canvas.drawCircle(
      Offset(60 * s, 50 * s),
      10 * s,
      Paint()..color = PauliColors.amber,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
