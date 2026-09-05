import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/brand_mark.dart';
import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../domain/scoring.dart';
import 'work_curve.dart';

/// Lebar logis kartu. Dirender dengan `pixelRatio = 1080 / 360` sehingga
/// hasilnya persis 1080 x 1350 — rasio 4:5, pas untuk WhatsApp dan Instagram
/// tanpa terpotong.
const double kCardWidth = 360;
const double kCardHeight = 450;

/// Kartu yang dibagikan setelah selesai.
///
/// Bukan tangkapan layar: dirender di luar layar lewat [RepaintBoundary] supaya
/// hasilnya seragam di HP kecil maupun tablet. Tema gelap supaya menonjol di
/// linimasa dan di ruang obrolan.
class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.session});

  final PauliSession session;

  @override
  Widget build(BuildContext context) {
    final score = SessionScore.of(session);
    return Container(
      width: kCardWidth,
      height: kCardHeight,
      color: PauliColors.dark,
      padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
      // `merge`, bukan `DefaultTextStyle` biasa: kartu ini cuma perlu
      // mengganti warnanya, sementara pilihan typeface tetap ikut aplikasi.
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: PauliColors.cream),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BrandMark(size: 26),
                const SizedBox(width: 10),
                const Text(
                  'PauliKu',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: PauliColors.cream,
                  ),
                ),
                const Spacer(),
                Text(
                  formatDateShort(session.startedAt).toUpperCase(),
                  style: mono(
                    size: 11,
                    color: const Color(0xFF7C8C87),
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // Sesi 60 menit bisa menghasilkan angka empat digit; angkanya
                // yang menyusut, bukan keterangannya yang terpotong.
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${score.workload}',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 62,
                        height: 1,
                        fontWeight: FontWeight.w300,
                        color: PauliColors.cream,
                        fontFeatures: [ui.FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'jawaban benar',
                  style: TextStyle(fontSize: 17, color: Color(0xFFA8B5B0)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Latihan Pauli · ${formatDuration(session.durationSec)} '
              '· satu titik tiap menit',
              style: const TextStyle(fontSize: 14, color: Color(0xFF7C8C87)),
            ),
            const SizedBox(height: 24),
            Text(
              'rata2 ${formatDecimal(score.mean)}',
              style: mono(size: 11, color: const Color(0xFF7C8C87)),
            ),
            // Label puncak digambar di atas area plot. Jaraknya harus cukup,
            // kalau tidak label itu menabrak keterangan rata-rata di atas saat
            // puncaknya kebetulan jatuh di menit-menit awal.
            const SizedBox(height: 20),
            Expanded(
              child: WorkCurve(
                values: [for (final s in session.segments) s.correct],
                dark: true,
                showMeanLine: true,
                lineWidth: 2.6,
              ),
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFF25332F), height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                _CardStat('Ketelitian', '${score.accuracy.round()}%'),
                _CardStat('Puncak', '${score.peak}'),
                _CardStat('Rentang', '${score.range}'),
                _CardStat('Tren', formatSigned(score.trendSlope)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  const _CardStat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7C8C87)),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: PauliColors.cream,
                fontFeatures: [ui.FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Merender [RepaintBoundary] di balik [key] jadi PNG lalu membukanya di menu
/// berbagi bawaan sistem.
Future<void> shareResultCard(GlobalKey key, {String? text}) async {
  final boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 1080 / kCardWidth);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (bytes == null) return;

  final dir = await getTemporaryDirectory();
  final file = File(
    '${dir.path}/pauliku-${DateTime.now().millisecondsSinceEpoch}.png',
  );
  await file.writeAsBytes(bytes.buffer.asUint8List());

  // API share_plus sejak versi 11: `Share.shareXFiles` sudah usang.
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path)],
      text: text ?? 'Hasil latihan Pauli saya',
    ),
  );
}
