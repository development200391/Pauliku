import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../domain/models.dart';

/// Dua angka bertumpuk, garis, lalu kotak jawaban kosong.
///
/// Tidak ada animasi pergantian soal. Angka yang berubah seketika sudah jadi
/// bukti bahwa ketukan tercatat; transisi apa pun di sini cuma menunda ketukan
/// berikutnya.
class QuestionDisplay extends StatelessWidget {
  const QuestionDisplay({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Digit('${question.top}'),
        _Digit('${question.bottom}'),
        const SizedBox(height: 14),
        Container(width: 104, height: 4, color: PauliColors.ink),
        const SizedBox(height: 26),
        CustomPaint(
          painter: _DashedBoxPainter(),
          child: const SizedBox(
            width: 92,
            height: 84,
            child: Center(
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 34,
                  color: PauliColors.inkSoft,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Digit extends StatelessWidget {
  const _Digit(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 92,
        height: 1.05,
        fontWeight: FontWeight.w400,
        color: PauliColors.ink,
        // Angka pakai lebar tetap supaya posisinya tidak bergeser saat 1
        // berganti jadi 8.
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _DashedBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PauliColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(12),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final end = (d + 9).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(d, end), paint);
        d += 16;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
