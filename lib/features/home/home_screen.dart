import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_mark.dart';
import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../../domain/scoring.dart';
import '../about/about_screen.dart';
import '../history/history_screen.dart';
import '../result/result_screen.dart';
import '../result/work_curve.dart';
import '../setup/setup_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    final sessions = history.valueOrNull ?? const <PauliSession>[];
    final last = sessions.isEmpty ? null : sessions.first;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PauliSizes.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),
              Row(
                children: [
                  const BrandMark(size: 40),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'PauliKu',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _openSetup(context),
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: PauliColors.inkSoft,
                    ),
                    tooltip: 'Pengaturan sesi',
                  ),
                ],
              ),
              const Spacer(),
              if (last != null) ...[
                const SectionLabel('Latihan terakhir'),
                const SizedBox(height: 12),
                _LastSessionCard(session: last),
              ] else
                const _FirstTimeCard(),
              const Spacer(),
              FilledButton(
                onPressed: () => _openSetup(context),
                child: const Text('Mulai latihan'),
              ),
              const SizedBox(height: 8),
              _NavRow(
                label: 'Riwayat',
                trailing: sessions.isEmpty
                    ? 'belum ada'
                    : '${sessions.length} sesi',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
              ),
              _NavRow(
                label: 'Tentang tes Pauli',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _openSetup(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SetupScreen()));
  }
}

class _LastSessionCard extends StatelessWidget {
  const _LastSessionCard({required this.session});

  final PauliSession session;

  @override
  Widget build(BuildContext context) {
    final score = SessionScore.of(session);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(PauliSizes.radius + 2),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultScreen(session: session)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // Durasi yang mengalah: tanggal relatif diukur lebih dulu
                  // dan tetap menempel di kanan, berapa pun skala huruf yang
                  // dipilih pengguna di setelan sistem.
                  Expanded(
                    child: Text(
                      formatDuration(session.durationSec),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: mono(
                        size: 26,
                        weight: FontWeight.w500,
                        color: PauliColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatRelative(session.startedAt),
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 15,
                      color: PauliColors.inkSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 58,
                child: WorkCurve(
                  values: [for (final s in session.segments) s.correct],
                  showAxes: false,
                  showPeakValley: false,
                  showMeanLine: false,
                  endDot: true,
                  lineWidth: 2.5,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 14),
              Row(
                children: [
                  _MiniStat('Jumlah kerja', '${score.workload}'),
                  _MiniStat('Ketelitian', '${score.accuracy.round()}%'),
                  _MiniStat('Rentang', '${score.range}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.label, this.value);

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
            style: const TextStyle(fontSize: 13, color: PauliColors.inkSoft),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: mono(size: 21, weight: FontWeight.w500, color: PauliColors.ink),
          ),
        ],
      ),
    );
  }
}

/// Yang dilihat orang saat pertama membuka aplikasi: aturan tesnya, satu
/// kalimat, dengan contohnya.
class _FirstTimeCard extends StatelessWidget {
  const _FirstTimeCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jumlahkan dua angka, tulis digit terakhirnya.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '7 + 4 = 11  ->  1\n4 + 9 = 13  ->  3',
              style: mono(size: 15, height: 1.7, color: PauliColors.inkSoft),
            ),
            const SizedBox(height: 14),
            const Text(
              'Angka bawah selalu naik jadi angka atas, jadi setiap angka '
              'dipakai dua kali.',
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: PauliColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.label, this.trailing, required this.onTap});

  final String label;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            if (trailing != null)
              Text(
                trailing!,
                style: const TextStyle(
                  fontSize: 15,
                  color: PauliColors.inkSoft,
                ),
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
    );
  }
}
