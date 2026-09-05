import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../domain/models.dart';
import '../../domain/scoring.dart';

/// Tabel per segmen. Sengaja tidak masuk kartu yang dibagikan — terlalu padat
/// untuk dilihat di layar orang lain — tapi berguna saat menelusuri sendiri di
/// menit mana temponya jatuh.
class SegmentDetailScreen extends StatelessWidget {
  const SegmentDetailScreen({super.key, required this.session});

  final PauliSession session;

  @override
  Widget build(BuildContext context) {
    final score = SessionScore.of(session);
    return Scaffold(
      appBar: AppBar(title: const Text('Rincian per segmen')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          PauliSizes.gutter,
          8,
          PauliSizes.gutter,
          32,
        ),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryLine(
                    'Dijawab',
                    '${session.totalAnswered}',
                  ),
                  _SummaryLine('Benar', '${session.totalCorrect}'),
                  _SummaryLine('Salah', '${session.totalWrong}'),
                  _SummaryLine(
                    'Pembetulan',
                    '${session.totalCorrections}',
                  ),
                  _SummaryLine('Simpangan', formatDecimal(score.stdev, digits: 2)),
                  _SummaryLine(
                    'Rata-rata waktu jawab',
                    '${score.avgResponseMs.round()} ms',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionLabel('Tiap menit'),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                const _Row(
                  cells: ['MENIT', 'JAWAB', 'BENAR', 'SALAH', 'MS'],
                  header: true,
                ),
                const Divider(),
                for (final s in session.segments) ...[
                  _Row(
                    cells: [
                      '${s.minute}',
                      '${s.answered}',
                      '${s.correct}',
                      '${s.wrong}',
                      s.answered == 0 ? '–' : '${s.avgResponseMs.round()}',
                    ],
                    highlight: s.correct == score.peak
                        ? PauliColors.green
                        : s.correct == score.valley
                        ? PauliColors.amber
                        : null,
                  ),
                  if (s != session.segments.last) const Divider(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
          const SizedBox(width: 12),
          Text(
            value,
            style: mono(size: 15, weight: FontWeight.w600, color: PauliColors.ink),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.cells, this.header = false, this.highlight});

  final List<String> cells;
  final bool header;
  final Color? highlight;

  @override
  Widget build(BuildContext context) {
    final style = header
        ? mono(size: 11, weight: FontWeight.w600, color: PauliColors.inkSoft)
              .copyWith(letterSpacing: 1.2)
        : mono(size: 14, color: highlight ?? PauliColors.ink);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++)
            Expanded(
              flex: i == 0 ? 3 : 3,
              child: Text(
                cells[i],
                textAlign: i == 0 ? TextAlign.left : TextAlign.right,
                style: highlight != null && !header
                    ? style.copyWith(fontWeight: FontWeight.w700)
                    : style,
              ),
            ),
        ],
      ),
    );
  }
}
