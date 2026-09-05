import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../test/test_screen.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(configProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan sesi')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat pengaturan: $e')),
        data: (config) => _Body(config: config),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.config});

  final SessionConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void update(SessionConfig next) =>
        ref.read(configProvider.notifier).save(next);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              PauliSizes.gutter,
              8,
              PauliSizes.gutter,
              24,
            ),
            children: [
              const SectionLabel('Durasi'),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final d in SessionConfig.durationChoices) ...[
                    Expanded(
                      child: _DurationChip(
                        minutes: d ~/ 60,
                        selected: config.durationSec == d,
                        onTap: () => update(config.copyWith(durationSec: d)),
                      ),
                    ),
                    if (d != SessionConfig.durationChoices.last)
                      const SizedBox(width: 10),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'menit',
                style: TextStyle(fontSize: 15, color: PauliColors.inkSoft),
              ),
              const SizedBox(height: 22),
              _IntervalNote(segments: config.segmentCount),
              const SizedBox(height: 26),
              const SectionLabel('Lainnya'),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _SwitchRow(
                      title: 'Bunyi aba-aba',
                      value: config.sound,
                      onChanged: (v) => update(config.copyWith(sound: v)),
                    ),
                    const Divider(),
                    _SwitchRow(
                      title: 'Getar saat garis',
                      value: config.haptics,
                      onChanged: (v) => update(config.copyWith(haptics: v)),
                    ),
                    const Divider(),
                    _SwitchRow(
                      title: 'Sertakan angka 0',
                      subtitle: 'Bikin tempo terasa timpang',
                      value: config.includeZero,
                      onChanged: (v) => update(config.copyWith(includeZero: v)),
                    ),
                    const Divider(),
                    _SwitchRow(
                      title: 'Simpan detail tiap jawaban',
                      subtitle: 'Menambah ukuran penyimpanan',
                      value: config.saveDetails,
                      onChanged: (v) => update(config.copyWith(saveDetails: v)),
                    ),
                  ],
                ),
              ),
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
          child: FilledButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => TestScreen(config: config)),
            ),
            child: const Text('Mulai'),
          ),
        ),
      ],
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.minutes,
    required this.selected,
    required this.onTap,
  });

  final int minutes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? PauliColors.green : PauliColors.card,
      borderRadius: BorderRadius.circular(PauliSizes.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PauliSizes.radius),
        child: Container(
          height: 74,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PauliSizes.radius),
            border: Border.all(
              color: selected ? PauliColors.green : PauliColors.line,
            ),
          ),
          child: Text(
            '$minutes',
            style: mono(
              size: 22,
              weight: FontWeight.w500,
              color: selected ? PauliColors.cream : PauliColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

/// Interval garis bukan pengaturan: satu menit sama dengan satu titik kurva,
/// jadi sumbu mendatarnya langsung terbaca sebagai menit. Yang perlu diketahui
/// pengguna cuma berapa titik yang akan dihasilkan sesi ini.
class _IntervalNote extends StatelessWidget {
  const _IntervalNote({required this.segments});

  final int segments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: PauliColors.green.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(PauliSizes.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '‖',
              style: mono(size: 18, color: PauliColors.green),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Garis jatuh tiap menit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: PauliColors.green,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Sesi ini menghasilkan $segments titik kurva',
                  style: const TextStyle(
                    fontSize: 15,
                    color: PauliColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 17)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: PauliColors.inkSoft,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
