import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/theme.dart';
import '../../domain/models.dart';
import '../result/result_screen.dart';
import 'numpad.dart';
import 'question_display.dart';
import 'test_controller.dart';

/// Satu aturan mengalahkan semua pertimbangan desain lain di layar ini:
/// jangan hambat ritme.
class TestScreen extends StatefulWidget {
  const TestScreen({super.key, required this.config});

  final SessionConfig config;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TestController c;
  late final AnimationController _flash;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Layar mati di tengah tes berarti sesi 60 menit hilang.
    WakelockPlus.enable();

    c = TestController(config: widget.config);
    _flash = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    c.lineTick.addListener(_onLine);
    c.addListener(_onPhase);
    c.startCountdown();
  }

  void _onLine() => _flash.forward(from: 0);

  void _onPhase() {
    if (c.phase == TestPhase.finished && !_navigated) {
      _navigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            session: c.buildSession(),
            rawAnswers: widget.config.saveDetails ? c.rawAnswers : const [],
            persist: true,
          ),
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sesi 60 menit hampir pasti kena telepon atau notifikasi.
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      c.pauseForBackground();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    c.lineTick.removeListener(_onLine);
    c.removeListener(_onPhase);
    _flash.dispose();
    c.dispose();
    super.dispose();
  }

  Future<void> _confirmQuit() async {
    final wasRunning = c.phase == TestPhase.running;
    if (wasRunning) c.pauseForBackground();
    final quit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PauliColors.card,
        title: const Text('Hentikan tes?'),
        content: const Text(
          'Sesi ini tidak akan disimpan dan hasilnya tidak bisa dilihat.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjutkan tes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hentikan'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (quit == true) {
      _navigated = true;
      Navigator.of(context).pop();
    } else {
      c.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Keluar tak sengaja di menit ke-50 itu menyakitkan.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  _Header(controller: c, onQuit: _confirmQuit),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: c,
                      builder: (_, _) => QuestionDisplay(question: c.current),
                    ),
                  ),
                  Numpad(onDigit: c.answer, onDelete: c.undo),
                  const SizedBox(height: 16),
                ],
              ),
              _LineFlash(animation: _flash),
              ListenableBuilder(
                listenable: c,
                builder: (_, _) {
                  if (c.phase == TestPhase.countdown) {
                    return _CountdownOverlay(value: c.countdown);
                  }
                  if (c.phase == TestPhase.paused) {
                    return _PausedOverlay(
                      onResume: c.resume,
                      onQuit: _confirmQuit,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller, required this.onQuit});

  final TestController controller;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PauliSizes.gutter),
      child: ValueListenableBuilder<Duration>(
        valueListenable: controller.elapsed,
        builder: (_, _, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Tidak ada penghitung segmen di sini: satu segmen sama
                  // dengan satu menit, jadi label menit sudah menyatakannya.
                  Text(
                    'MENIT ${controller.minute} / ${controller.totalMinutes}',
                    style: mono(
                      size: 14,
                      weight: FontWeight.w600,
                      color: PauliColors.inkSoft,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onQuit,
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: PauliColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: controller.progress,
                  minHeight: 5,
                  backgroundColor: PauliColors.line,
                  valueColor: const AlwaysStoppedAnimation(PauliColors.green),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Garis tipis melintas layar sekejap. Lebih lama dari ~300 ms justru memotong
/// ritme, jadi durasinya sengaja pendek.
class _LineFlash extends StatelessWidget {
  const _LineFlash({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = animation.value;
          if (t == 0 || t == 1) return const SizedBox.shrink();
          final wipe = Curves.easeOutCubic.transform(t);
          final fade = t < 0.55 ? 1.0 : 1 - (t - 0.55) / 0.45;
          return Align(
            alignment: const Alignment(0, -0.18),
            child: FractionallySizedBox(
              widthFactor: wipe,
              child: Opacity(
                opacity: fade.clamp(0.0, 1.0),
                child: Container(height: 2, color: PauliColors.green),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CountdownOverlay extends StatelessWidget {
  const _CountdownOverlay({required this.value});
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PauliColors.cream,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: mono(
              size: 120,
              weight: FontWeight.w600,
              color: PauliColors.green,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Siapkan jempol',
            style: mono(size: 15, color: PauliColors.inkSoft),
          ),
        ],
      ),
    );
  }
}

class _PausedOverlay extends StatelessWidget {
  const _PausedOverlay({required this.onResume, required this.onQuit});

  final VoidCallback onResume;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PauliColors.cream,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(PauliSizes.gutter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.pause_circle_outline,
            size: 56,
            color: PauliColors.green,
          ),
          const SizedBox(height: 20),
          Text('Tes dijeda', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          const Text(
            'Waktu berhenti saat aplikasi ditinggalkan. Sesi ini ditandai '
            'terganggu dan tidak ikut dihitung di grafik tren.',
            textAlign: TextAlign.center,
            style: TextStyle(color: PauliColors.inkSoft, height: 1.45),
          ),
          const SizedBox(height: 28),
          FilledButton(onPressed: onResume, child: const Text('Lanjutkan')),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onQuit, child: const Text('Hentikan tes')),
        ],
      ),
    );
  }
}
