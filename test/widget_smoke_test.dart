import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pauliku/core/theme.dart';
import 'package:pauliku/data/providers.dart';
import 'package:pauliku/domain/models.dart';
import 'package:pauliku/features/about/about_screen.dart';
import 'package:pauliku/features/history/history_screen.dart';
import 'package:pauliku/features/home/home_screen.dart';
import 'package:pauliku/features/result/result_card.dart';
import 'package:pauliku/features/result/result_screen.dart';
import 'package:pauliku/features/result/segment_detail_screen.dart';
import 'package:pauliku/features/setup/setup_screen.dart';

PauliSession sampleSession({
  List<int> perMinute = const [41, 44, 48, 45, 50, 47, 44, 39, 42, 48],
  bool interrupted = false,
  DateTime? startedAt,
}) {
  final segments = [
    for (var i = 0; i < perMinute.length; i++)
      PauliSegment(
        index: i,
        answered: perMinute[i] + 2,
        correct: perMinute[i],
        wrong: 2,
        avgResponseMs: 1200,
      ),
  ];
  return PauliSession(
    id: 'sesi-$interrupted-${perMinute.length}',
    startedAt: startedAt ?? DateTime(2026, 9, 1, 8, 32),
    durationSec: perMinute.length * 60,
    intervalSec: 60,
    seed: 42,
    interrupted: interrupted,
    totalAnswered: segments.fold(0, (a, s) => a + s.answered),
    totalCorrect: segments.fold(0, (a, s) => a + s.correct),
    totalWrong: segments.fold(0, (a, s) => a + s.wrong),
    totalCorrections: 4,
    segments: segments,
  );
}

class _FakeConfig extends ConfigNotifier {
  @override
  Future<SessionConfig> build() async => const SessionConfig();

  @override
  Future<void> save(SessionConfig config) async {}
}

extension on WidgetTester {
  /// Semua layar dirancang untuk layar HP tegak; ukuran bawaan tes (800x600)
  /// akan melaporkan luber yang tidak pernah terjadi di perangkat nyata.
  Future<void> pumpScreen(
    Widget screen, {
    List<PauliSession> history = const [],
    Size size = const Size(390, 844),
  }) async {
    view.physicalSize = size * 3;
    view.devicePixelRatio = 3;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    await pumpWidget(
      ProviderScope(
        overrides: [
          historyProvider.overrideWith((ref) async => history),
          configProvider.overrideWith(_FakeConfig.new),
        ],
        child: MaterialApp(theme: buildPauliTheme(), home: screen),
      ),
    );
    await pumpAndSettle();
  }
}

void main() {
  testWidgets('beranda tanpa riwayat menampilkan aturan tesnya', (t) async {
    await t.pumpScreen(const HomeScreen());
    expect(find.text('PauliKu'), findsOneWidget);
    expect(find.text('Mulai latihan'), findsOneWidget);
    expect(
      find.text('Jumlahkan dua angka, tulis digit terakhirnya.'),
      findsOneWidget,
    );
    expect(find.text('belum ada'), findsOneWidget);
  });

  testWidgets('beranda dengan riwayat menampilkan latihan terakhir', (t) async {
    await t.pumpScreen(const HomeScreen(), history: [sampleSession()]);
    expect(find.text('LATIHAN TERAKHIR'), findsOneWidget);
    expect(find.text('10 menit'), findsOneWidget);
    expect(find.text('448'), findsOneWidget); // jumlah kerja
    expect(find.text('1 sesi'), findsOneWidget);
  });

  testWidgets('pengaturan sesi menampilkan lima durasi dan jumlah titik', (
    t,
  ) async {
    await t.pumpScreen(const SetupScreen());
    for (final m in ['5', '10', '20', '30', '60']) {
      expect(find.text(m), findsWidgets);
    }
    expect(find.text('Garis jatuh tiap menit'), findsOneWidget);
    expect(find.text('Sesi ini menghasilkan 10 titik kurva'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(4));
  });

  testWidgets('layar hasil menampilkan kurva dan empat metrik', (t) async {
    await t.pumpScreen(ResultScreen(session: sampleSession()));
    expect(find.text('Hasil latihan'), findsOneWidget);
    expect(
      find.text('1 September 2026 · 10 menit · 10 titik kurva'),
      findsOneWidget,
    );
    // Muncul dua kali: di kartu metrik dan di kartu bagikan yang menunggu di
    // luar layar.
    expect(find.text('448'), findsNWidgets(2));
    expect(find.text('96%'), findsNWidgets(2));
    expect(find.text('11'), findsNWidgets(2)); // rentang puncak-lembah
    expect(find.text('landai'), findsOneWidget);
    expect(
      find.text('Rata-rata 44,8 · puncak menit 5 · terendah menit 8'),
      findsOneWidget,
    );
    expect(find.text('Bagikan'), findsOneWidget);
  });

  testWidgets('sesi terganggu diberi keterangan di layar hasil', (t) async {
    await t.pumpScreen(ResultScreen(session: sampleSession(interrupted: true)));
    expect(
      find.textContaining('tidak ikut dihitung di grafik tren'),
      findsOneWidget,
    );
  });

  testWidgets('rincian per segmen menampilkan satu baris per menit', (t) async {
    await t.pumpScreen(SegmentDetailScreen(session: sampleSession()));
    expect(find.text('MENIT'), findsOneWidget);
    expect(find.text('Pembetulan'), findsOneWidget);
    expect(find.text('4'), findsWidgets);
  });

  testWidgets('riwayat kosong menjelaskan keadaannya', (t) async {
    await t.pumpScreen(const HistoryScreen());
    expect(find.textContaining('Belum ada sesi tersimpan'), findsOneWidget);
  });

  testWidgets('grafik tren menunggu dua sesi yang tidak terjeda', (t) async {
    await t.pumpScreen(
      const HistoryScreen(),
      history: [sampleSession(), sampleSession(interrupted: true)],
    );
    expect(
      find.textContaining('Grafik tren muncul setelah ada dua sesi'),
      findsOneWidget,
    );
  });

  testWidgets('grafik tren muncul setelah dua sesi bersih', (t) async {
    await t.pumpScreen(
      const HistoryScreen(),
      history: [
        sampleSession(startedAt: DateTime(2026, 9, 2)),
        sampleSession(
          perMinute: const [30, 32, 31, 33, 35],
          startedAt: DateTime(2026, 9, 1),
        ),
      ],
    );
    expect(find.text('Rata-rata benar per menit'), findsOneWidget);
    expect(find.text('2 sesi terakhir yang tidak terjeda'), findsOneWidget);
  });

  testWidgets('layar penjelasan memuat batasan aplikasi', (t) async {
    await t.pumpScreen(const AboutScreen());
    expect(find.textContaining('jumlahkan dua angka'), findsOneWidget);

    // Batasan aplikasi ada di dasar halaman, jadi harus digulir dulu.
    await t.scrollUntilVisible(
      find.textContaining('alat latihan, bukan asesmen'),
      400,
    );
    await t.scrollUntilVisible(find.textContaining('panker'), 400);
    expect(find.textContaining('panker'), findsOneWidget);
  });

  testWidgets('kartu hasil dirender persis 1080 x 1350', (t) async {
    final key = GlobalKey();
    await t.pumpScreen(
      Center(
        child: RepaintBoundary(key: key, child: ResultCard(session: sampleSession())),
      ),
    );

    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await t.runAsync(
      () => boundary.toImage(pixelRatio: 1080 / kCardWidth),
    );

    expect(image, isNotNull);
    expect(image!.width, 1080);
    expect(image.height, 1350);

    final bytes = await t.runAsync(
      () => image.toByteData(format: ui.ImageByteFormat.png),
    );
    expect(bytes, isNotNull);
    expect(bytes!.lengthInBytes, greaterThan(0));
    image.dispose();
  });

  testWidgets('sesi 60 menit tetap muat di kartu tanpa luber', (t) async {
    await t.pumpScreen(
      Center(
        child: ResultCard(
          session: sampleSession(
            perMinute: [for (var i = 0; i < 60; i++) 40 + (i % 9)],
          ),
        ),
      ),
    );
    expect(find.text('jawaban benar'), findsOneWidget);
  });
}

