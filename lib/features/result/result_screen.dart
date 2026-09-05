import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../../domain/scoring.dart';
import 'result_card.dart';
import 'segment_detail_screen.dart';
import 'work_curve.dart';

/// Semua penilaian ditahan sampai layar ini: selama tes berlangsung tidak ada
/// tanda benar atau salah sama sekali.
class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({
    super.key,
    required this.session,
    this.rawAnswers = const [],
    this.persist = false,
  });

  final PauliSession session;
  final List<AnswerRecord> rawAnswers;

  /// `true` untuk sesi yang baru selesai, `false` saat dibuka dari riwayat.
  final bool persist;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final _cardKey = GlobalKey();
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    if (widget.persist) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _save());
    }
  }

  Future<void> _save() async {
    await ref
        .read(repositoryProvider)
        .save(widget.session, rawAnswers: widget.rawAnswers);
    ref.invalidate(historyProvider);
  }

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      await shareResultCard(_cardKey);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal membuat kartu: $e')));
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final score = SessionScore.of(s);
    final values = [for (final seg in s.segments) seg.correct];

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      PauliSizes.gutter,
                      24,
                      PauliSizes.gutter,
                      8,
                    ),
                    children: [
                      Text(
                        'Hasil latihan',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${formatDate(s.startedAt)} · '
                        '${formatDuration(s.durationSec)} · '
                        '${s.segments.length} titik kurva',
                        style: const TextStyle(
                          fontSize: 16,
                          color: PauliColors.inkSoft,
                        ),
                      ),
                      if (s.interrupted) ...[
                        const SizedBox(height: 14),
                        const _InterruptedNote(),
                      ],
                      const SizedBox(height: 20),
                      _CurveCard(values: values, score: score),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _Stat(
                              label: 'Jumlah kerja',
                              value: '${score.workload}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _Stat(
                              label: 'Ketelitian',
                              value: '${score.accuracy.round()}%',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Label kiri makan dua baris, label kanan satu. Tanpa
                      // `IntrinsicHeight`, `stretch` di dalam ListView minta
                      // tinggi tak terhingga dan tata letaknya gagal.
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _Stat(
                                label: 'Rentang puncak–lembah',
                                value: '${score.range}',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _Stat(
                                label: 'Tren',
                                value: formatSigned(score.trendSlope),
                                suffix: score.trend.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(session: s, score: score),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    PauliSizes.gutter,
                    8,
                    PauliSizes.gutter,
                    16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: FilledButton.icon(
                          onPressed: _sharing ? null : _share,
                          icon: const Icon(Icons.ios_share, size: 20),
                          label: const Text('Bagikan'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).popUntil((r) => r.isFirst),
                          child: const Text('Selesai'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Kartu hidup di dalam pohon widget supaya benar-benar dilukis —
          // `Offstage` dan `Opacity(0)` melewati tahap melukis, jadi
          // `toImage()` di atasnya menghasilkan gambar kosong. Digeser jauh ke
          // bawah layar alih-alih disembunyikan.
          Positioned(
            left: 0,
            top: 4000,
            child: RepaintBoundary(
              key: _cardKey,
              child: ResultCard(session: s),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurveCard extends StatelessWidget {
  const _CurveCard({required this.values, required this.score});

  final List<int> values;
  final SessionScore score;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 210, child: WorkCurve(values: values)),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'menit',
                style: TextStyle(fontSize: 13, color: PauliColors.inkSoft),
              ),
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Rata-rata ${formatDecimal(score.mean)} · '
              'puncak menit ${score.peakMinute} · '
              'terendah menit ${score.valleyMinute}',
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: PauliColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.suffix});

  final String label;
  final String value;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: PauliColors.inkSoft),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: mono(
                      size: 28,
                      weight: FontWeight.w500,
                      color: PauliColors.ink,
                    ),
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      suffix!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: PauliColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.session, required this.score});

  final PauliSession session;
  final SessionScore score;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(PauliSizes.radius + 2),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SegmentDetailScreen(session: session),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(18, 20, 14, 20),
          child: Row(
            children: [
              Text('Rincian per segmen', style: TextStyle(fontSize: 16)),
              Spacer(),
              Icon(Icons.chevron_right, color: PauliColors.inkSoft),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterruptedNote extends StatelessWidget {
  const _InterruptedNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PauliColors.amber.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(PauliSizes.radius),
      ),
      child: const Row(
        children: [
          Icon(Icons.pause_circle_outline, size: 20, color: Color(0xFF8A5B12)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sesi ini sempat terjeda, jadi tidak ikut dihitung di grafik tren.',
              style: TextStyle(fontSize: 14, color: Color(0xFF8A5B12)),
            ),
          ),
        ],
      ),
    );
  }
}
