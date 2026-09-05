import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Kurva kerja: sumbu mendatar menit, sumbu tegak jumlah benar per menit.
///
/// Cuma satu deret data, jadi tidak perlu legenda. Garis rata-rata jadi acuan
/// diam; puncak dan lembah diberi label langsung.
///
/// fl_chart digambar tanpa satu pun judul sumbu bawaannya, supaya area plot
/// persis sama dengan kotak yang diberikan. Dengan begitu label puncak, lembah,
/// dan sumbu bisa ditempatkan sendiri lewat aritmetika yang jelas — fl_chart
/// tidak membuka pemetaan koordinat internalnya.
class WorkCurve extends StatelessWidget {
  const WorkCurve({
    super.key,
    required this.values,
    this.dark = false,
    this.showAxes = true,
    this.showPeakValley = true,
    this.showMeanLine = true,
    this.endDot = false,
    this.lineWidth = 3,
    this.scale = 1,
  });

  /// Jumlah benar tiap menit; satu nilai = satu titik.
  final List<int> values;
  final bool dark;
  final bool showAxes;
  final bool showPeakValley;
  final bool showMeanLine;

  /// Titik penutup di ujung kanan — dipakai di kartu ringkas beranda.
  final bool endDot;
  final double lineWidth;

  /// Pengali ukuran teks dan titik, untuk render kartu 1080 px.
  final double scale;

  Color get _line => dark ? PauliColors.greenBright : PauliColors.green;
  Color get _fill => dark
      ? PauliColors.greenBright.withValues(alpha: 0.14)
      : PauliColors.green.withValues(alpha: 0.10);
  Color get _muted => dark ? const Color(0xFF7C8C87) : PauliColors.inkSoft;
  Color get _grid =>
      dark ? const Color(0xFF25332F) : PauliColors.line.withValues(alpha: 0.9);

  TextStyle get _axisStyle =>
      mono(size: 12 * scale, weight: FontWeight.w500, color: _muted);

  double get _yAxisWidth => 30 * scale;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final bounds = _Bounds.of(values);
    final plot = _Plot(curve: this, bounds: bounds);

    if (!showAxes) return plot;

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: _yAxisWidth,
                child: _YAxis(bounds: bounds, style: _axisStyle),
              ),
              SizedBox(width: 8 * scale),
              Expanded(child: plot),
            ],
          ),
        ),
        SizedBox(height: 8 * scale),
        Row(
          children: [
            SizedBox(width: _yAxisWidth + 8 * scale),
            Expanded(child: _XAxis(count: values.length, style: _axisStyle)),
          ],
        ),
      ],
    );
  }
}

/// Area plot: grafik fl_chart plus label puncak dan lembah di atasnya.
class _Plot extends StatelessWidget {
  const _Plot({required this.curve, required this.bounds});

  final WorkCurve curve;
  final _Bounds bounds;

  @override
  Widget build(BuildContext context) {
    final values = curve.values;
    final mean = values.reduce((a, b) => a + b) / values.length;
    final peak = values.reduce(math.max);
    final valley = values.reduce(math.min);

    return LayoutBuilder(
      builder: (context, box) {
        double dx(int i) => values.length == 1
            ? box.maxWidth / 2
            : i / (values.length - 1) * box.maxWidth;
        double dy(num v) =>
            box.maxHeight -
            (v - bounds.min) / (bounds.max - bounds.min) * box.maxHeight;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: _chart(mean)),
            if (curve.showPeakValley && values.length > 1) ...[
              _marker(
                x: dx(values.indexOf(peak)),
                y: dy(peak),
                label: '$peak',
                color: curve._line,
                above: true,
              ),
              if (valley != peak)
                _marker(
                  x: dx(values.indexOf(valley)),
                  y: dy(valley),
                  label: '$valley',
                  color: PauliColors.amber,
                  above: false,
                ),
            ],
            if (curve.endDot)
              _marker(
                x: dx(values.length - 1),
                y: dy(values.last),
                color: curve._line,
              ),
          ],
        );
      },
    );
  }

  Widget _chart(double mean) {
    final values = curve.values;
    final dash = (6 * curve.scale).round();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (values.length - 1).toDouble(),
        minY: bounds.min,
        maxY: bounds.max,
        clipData: const FlClipData.none(),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        gridData: FlGridData(
          show: curve.showAxes,
          drawVerticalLine: false,
          horizontalInterval: bounds.step,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: curve._grid, strokeWidth: 1),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            if (curve.showMeanLine && values.length > 1)
              HorizontalLine(
                y: mean,
                color: curve._muted.withValues(alpha: 0.7),
                strokeWidth: 1.5 * curve.scale,
                dashArray: [dash, dash],
              ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i].toDouble()),
            ],
            isCurved: false,
            color: curve._line,
            barWidth: curve.lineWidth * curve.scale,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: curve._fill),
          ),
        ],
      ),
    );
  }

  Widget _marker({
    required double x,
    required double y,
    required Color color,
    String? label,
    bool above = true,
  }) {
    final scale = curve.scale;
    final r = 5.0 * scale;
    final dot = Container(
      width: r * 2,
      height: r * 2,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    if (label == null) {
      return Positioned(left: x - r, top: y - r, child: dot);
    }

    final text = Text(
      label,
      textAlign: TextAlign.center,
      style: mono(size: 13 * scale, weight: FontWeight.w600, color: color),
    );
    final gap = SizedBox(height: 3 * scale);
    final labelHeight = 18.0 * scale;

    return Positioned(
      left: x - 24 * scale,
      top: above ? y - r - labelHeight - 3 * scale : y - r,
      width: 48 * scale,
      child: Column(children: above ? [text, gap, dot] : [dot, gap, text]),
    );
  }
}

/// Batas dan jarak garis bantu sumbu tegak.
class _Bounds {
  const _Bounds(this.min, this.max, this.step);

  final double min;
  final double max;
  final double step;

  static const _stepChoices = [1, 2, 5, 10, 20, 25, 50, 100];

  /// Memilih batas "bulat" supaya angka di sumbu enak dibaca, dan menjaga
  /// jumlah garis bantu di kisaran dua sampai lima.
  static _Bounds of(List<int> values) {
    final lo = values.reduce(math.min);
    final hi = values.reduce(math.max);
    if (hi == 0) return const _Bounds(0, 10, 5);

    final spread = math.max(hi - lo, 1);
    final step = _stepChoices
        .firstWhere((s) => spread / s <= 4, orElse: () => _stepChoices.last)
        .toDouble();

    var lower = (lo / step).floor() * step;
    var upper = (hi / step).ceil() * step;
    if (upper <= lower) upper = lower + step;
    // Kalau seluruh menit bernilai sama, batas bawahnya persis menempel garis
    // datar itu — turunkan satu langkah supaya kurvanya tetap terlihat.
    if (lower >= lo.toDouble()) lower = math.min(lower, lo - step / 2);
    return _Bounds(lower, upper, step);
  }

  List<double> get ticks {
    final out = <double>[];
    // Batas bawah bisa jatuh di antara garis bantu, jadi mulai dari kelipatan
    // step pertama yang berada di dalam rentang.
    var v = (min / step).ceil() * step;
    while (v <= max + 0.001) {
      out.add(v);
      v += step;
    }
    return out;
  }
}

class _YAxis extends StatelessWidget {
  const _YAxis({required this.bounds, required this.style});

  final _Bounds bounds;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final lineHeight = (style.fontSize ?? 12) * 1.35;
    return LayoutBuilder(
      builder: (context, box) {
        return Stack(
          // Label paling atas dan paling bawah setengahnya jatuh di luar area
          // plot; tanpa ini keduanya terpotong separuh.
          clipBehavior: Clip.none,
          children: [
            for (final t in bounds.ticks)
              Positioned(
                right: 0,
                width: box.maxWidth,
                top:
                    box.maxHeight *
                        (bounds.max - t) /
                        (bounds.max - bounds.min) -
                    lineHeight / 2,
                child: Text(
                  t.toStringAsFixed(0),
                  style: style,
                  textAlign: TextAlign.right,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _XAxis extends StatelessWidget {
  const _XAxis({required this.count, required this.style});

  final int count;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    // Menit pertama, tengah, dan terakhir sudah cukup: sumbu ini tidak dipakai
    // untuk membaca nilai, cuma untuk tahu di mana posisi kita.
    return Row(
      children: [
        Text('1', style: style),
        const Spacer(),
        if (count >= 4) Text('${(count / 2).ceil()}', style: style),
        const Spacer(),
        Text('$count', style: style),
      ],
    );
  }
}
