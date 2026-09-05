import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../../domain/scoring.dart';
import '../result/result_screen.dart';
import 'trend_chart.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat riwayat: $e')),
        data: (sessions) {
          if (sessions.isEmpty) return const _Empty();
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              PauliSizes.gutter,
              8,
              PauliSizes.gutter,
              32,
            ),
            children: [
              TrendChart(sessions: sessions),
              const SizedBox(height: 26),
              const SectionLabel('Semua sesi'),
              const SizedBox(height: 12),
              for (final s in sessions) ...[
                _SessionTile(session: s),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({required this.session});

  final PauliSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = SessionScore.of(session);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(PauliSizes.radius + 2),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultScreen(session: session)),
        ),
        onLongPress: () => _confirmDelete(context, ref),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            formatDate(session.startedAt),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (session.interrupted) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.pause_circle_outline,
                            size: 16,
                            color: PauliColors.amber,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatTime(session.startedAt)} · '
                      '${formatDuration(session.durationSec)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: PauliColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${score.workload}',
                    style: mono(
                      size: 20,
                      weight: FontWeight.w600,
                      color: PauliColors.ink,
                    ),
                  ),
                  Text(
                    '${score.accuracy.round()}% tepat',
                    style: const TextStyle(
                      fontSize: 13,
                      color: PauliColors.inkSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: PauliColors.inkSoft,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PauliColors.card,
        title: const Text('Hapus sesi ini?'),
        content: Text(
          '${formatDate(session.startedAt)}, '
          '${formatDuration(session.durationSec)}. '
          'Sesi yang dihapus tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(repositoryProvider).delete(session.id);
    ref.invalidate(historyProvider);
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'Belum ada sesi tersimpan.\nSelesaikan satu latihan dan hasilnya '
          'muncul di sini.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: PauliColors.inkSoft,
          ),
        ),
      ),
    );
  }
}
