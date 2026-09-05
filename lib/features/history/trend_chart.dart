import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';

/// Perkembangan antar sesi.
///
/// Yang diplot adalah **rata-rata jawaban benar per menit**, bukan jumlah kerja
/// mentah: jumlah mentah sesi 60 menit selalu enam kali lipat sesi 10 menit,
/// jadi grafiknya cuma akan menggambarkan pilihan durasi, bukan perkembangan.
/// Sesi bertanda terganggu dikecualikan supaya rata-rata jangka panjang tidak
/// tercemar.
class TrendChart extends StatelessWidget {
  const TrendChart({super.key, required this.sessions});

  /// Terbaru lebih dulu — dibalik di dalam supaya waktu mengalir ke kanan.
  final List<PauliSession> sessions;

  static const int _minPoints = 2;

  @override
  Widget build(BuildContext context) {
    final usable = sessions.where((s) => !s.interrupted).toList().reversed
        .toList();

    if (usable.length < _minPoints) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Grafik tren muncul setelah ada dua sesi yang selesai tanpa '
            'terjeda. Sesi yang sempat terjeda tidak ikut dihitung.',
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: PauliColors.inkSoft,
            ),
          ),
        ),
      );
    }

    final rates = [
      for (final s in usable)
        s.segments.isEmpty ? 0.0 : s.totalCorrect / s.segments.length,
    ];
    final lo = rates.reduce(math.min);
    final hi = rates.reduce(math.max);
    final pad = math.max((hi - lo) * 0.25, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rata-rata benar per menit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              '${usable.length} sesi terakhir yang tidak terjeda',
              style: const TextStyle(fontSize: 14, color: PauliColors.inkSoft),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 130,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (rates.length - 1).toDouble(),
                  minY: lo - pad,
                  maxY: hi + pad,
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < rates.length; i++)
                          FlSpot(i.toDouble(), rates[i]),
                      ],
                      isCurved: false,
                      color: PauliColors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                          radius: 3.5,
                          color: PauliColors.green,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: PauliColors.green.withValues(alpha: 0.10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  formatDateShort(usable.first.startedAt),
                  style: mono(size: 11, color: PauliColors.inkSoft),
                ),
                const Spacer(),
                Text(
                  'terkini ${formatDecimal(rates.last)}',
                  style: mono(size: 11, color: PauliColors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
