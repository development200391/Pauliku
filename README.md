<div align="center">

<img src="docs/icon.svg" width="88" alt="PauliKu">

# PauliKu

**Latihan tes Pauli (tes koran) di Android & iOS.**
Soalnya sepele — dua angka acak. Yang mahal adalah menghitung hasilnya, dan itu yang dikerjakan aplikasi ini.

`Flutter` · `Offline penuh` · `Tanpa akun`

</div>

---

> **Status:** v0.3 — aplikasinya jalan penuh: pembangkit deret, layar tes, skoring, kurva, kartu PNG, dan riwayat sudah ada. Sisa menuju v1.0 ada di [Roadmap](#roadmap).
> Dokumen ini adalah acuan tunggal selama pengerjaan. Kalau ada keputusan baru, ubah di sini dulu.

## Daftar isi

- [Tentang tes Pauli](#tentang-tes-pauli)
- [Apa yang dikerjakan aplikasi ini](#apa-yang-dikerjakan-aplikasi-ini)
- [Tampilan](#tampilan)
- [Prinsip \& batasan](#prinsip--batasan)
- [Mekanik soal — deret berantai](#mekanik-soal--deret-berantai)
- [Timer \& aba-aba garis](#timer--aba-aba-garis)
- [Layar tes](#layar-tes)
- [Skoring \& kurva](#skoring--kurva)
- [Model data](#model-data)
- [Arsitektur](#arsitektur)
- [Paket](#paket)
- [Menjalankan](#menjalankan)
- [Kartu hasil](#kartu-hasil)
- [Roadmap](#roadmap)
- [Identitas visual](#identitas-visual)
- [Rilis](#rilis)
- [Yang gampang salah](#yang-gampang-salah)
- [Lisensi](#lisensi)

---

## Tentang tes Pauli

Tes Pauli — di Indonesia lebih dikenal sebagai **tes koran**, karena lembar kertasnya selebar koran — adalah tes penjumlahan berdurasi panjang yang dipakai di banyak proses rekrutmen. Aturannya satu kalimat: **jumlahkan dua angka, tulis digit terakhirnya.**

```
7 + 4 = 11  ->  tulis 1
4 + 9 = 13  ->  tulis 3
```

Yang diukur bukan kemampuan berhitung, melainkan **pola kerja**: kecepatan, ketelitian, kestabilan, dan daya tahan saat mulai lelah. Karena itu hasilnya dibaca sebagai kurva, bukan sebagai satu angka nilai.

Kerabat dekatnya adalah **tes Kraepelin**: susunannya kolom dan dijumlahkan dari bawah ke atas, sementara Pauli dari atas ke bawah dengan durasi lebih panjang (umumnya 60 menit, aba-aba "garis" tiap 3 menit). PauliKu mengikuti aturan Pauli; mode Kraepelin ada di roadmap.

## Apa yang dikerjakan aplikasi ini

- Soal dibangkitkan acak di HP — tidak ada bank soal, tidak perlu jaringan.
- Satu pasang angka per layar dengan numpad 0–9. Satu ketukan per soal.
- Durasi bisa dipilih, dari latihan 5 menit sampai simulasi penuh 60 menit. Aba-aba garis tetap tiap menit.
- Begitu selesai, seluruh perhitungan yang di kertas makan waktu belasan menit langsung selesai: jumlah per segmen, puncak, lembah, simpangan, tren.
- Hasilnya jadi kartu PNG yang tinggal dibagikan.
- Riwayat tersimpan lokal supaya perkembangan antar sesi kelihatan.

## Tampilan

Mockup rancangan; aplikasinya sekarang mengikuti tata letak ini. Tema kertas dengan aksen hijau pine, angka monospace supaya tidak bergoyang saat berganti soal.

| Beranda | Pengaturan sesi | Layar tes | Hasil |
|:---:|:---:|:---:|:---:|
| <img src="docs/screens/beranda.png" width="185" alt="Beranda"> | <img src="docs/screens/pengaturan.png" width="185" alt="Pengaturan sesi"> | <img src="docs/screens/layar-tes.png" width="185" alt="Layar tes"> | <img src="docs/screens/hasil.png" width="185" alt="Hasil"> |

Kartu yang dibagikan setelah selesai &mdash; dirender 1080 &times; 1350, tema gelap supaya menonjol di WhatsApp:

<img src="docs/screens/kartu-hasil.png" width="400" alt="Kartu hasil">

Semua angka di gambar adalah contoh, bukan data nyata.

## Prinsip & batasan

**1. Alat latihan, bukan asesmen.**
Norma dan interpretasi resmi Pauli dipegang penerbit tes psikologi dan tidak dipublikasikan bebas. PauliKu menampilkan **skor mentah dan kurvanya** — bukan kesimpulan kepribadian, bukan prediksi kelulusan. Selain soal etika, klaim semacam itu juga rawan ditolak saat review Play Store.

**2. Offline penuh.**
Tanpa server, tanpa login, tanpa data pribadi. Konsekuensinya menguntungkan: formulir Data Safety di Play Store jadi paling sederhana, dan aplikasi tetap jalan saat sesi 60 menit tanpa sinyal.

**3. Nilai jualnya umpan balik, bukan soal.**
Membangkitkan dua angka acak itu sepuluh baris kode. Menghitung dan menggambar kurvanya adalah bagian yang selama ini dikerjakan manual. Ke sanalah sebagian besar tenaga pengembangan diarahkan.

## Mekanik soal — deret berantai

> Ini bagian yang paling sering keliru di aplikasi sejenis, dan yang membedakan Pauli asli dari sekadar kuis penjumlahan.

Pauli bekerja pada **deret berantai**, bukan pasangan lepas. Dari deret `a₁ a₂ a₃ a₄`, yang dijumlahkan adalah tetangganya — sehingga **setiap angka dipakai dua kali**, sekali sebagai angka bawah dan sekali sebagai angka atas.

```
  BENAR — deret berantai              KELIRU — pasangan lepas

    7   4   9   2   6                   7 4   9 2   6 3
    └─┬─┘   │   │   │                   └─┘   └─┘   └─┘
      1 └─┬─┘   │   │                    1     1     9
          3 └─┬─┘   │
              1 └─┬─┘                   tiap angka cuma sekali
                  8

  angka 4, 9, 2 masing-masing
  dipakai pada dua soal
```

Di layar satu-soal, ini diterjemahkan begini: angka atas dan bawah ditumpuk; begitu jawaban ditekan, **angka bawah naik menjadi angka atas** dan satu angka baru muncul di bawah.

```dart
// Inti pembangkitnya — sengaja sesederhana ini.
class PauliEngine {
  final Random _rng;
  int _top;

  PauliEngine(int seed)
      : _rng = Random(seed),
        _top = 0 {
    _top = _next();
  }

  int _next() => 1 + _rng.nextInt(9); // 1..9

  /// Menghasilkan soal berikutnya sambil menggeser deret.
  Question advance() {
    final bottom = _next();
    final q = Question(top: _top, bottom: bottom, answer: (_top + bottom) % 10);
    _top = bottom; // <- di sinilah rantainya terjaga
    return q;
  }
}
```

Aturan pembangkit:

- Digit **1–9**. Angka 0 dimatikan secara bawaan karena penjumlahan dengan 0 terasa "gratis" dan mengacaukan tempo — sediakan sebagai opsi di pengaturan.
- Jawaban `(a + b) % 10`. Jumlah maksimum 9+9=18, jadi jawabannya selalu satu digit dan numpad 0–9 sudah cukup.
- Tolak angka baru yang sama persis dengan angka sebelumnya, supaya tidak muncul `5 5 5` beruntun yang terasa janggal.
- **Simpan seed** tiap sesi. Dengan seed, deret yang sama bisa dibangkitkan ulang — berguna untuk menguji rumus skoring dan untuk fitur "ulangi deret yang sama".

## Timer & aba-aba garis

Aba-aba "garis" bukan jeda. Ia hanya menancapkan penanda, dan penanda itulah yang jadi titik-titik kurva.

**Garis jatuh tiap menit, selalu.** Satu menit sama dengan satu titik kurva, jadi jumlah titik selalu sama dengan durasi dalam menit: sesi 10 menit menghasilkan 10 titik, sesi 60 menit menghasilkan 60 titik. Intervalnya tidak bisa diatur &mdash; satu pengaturan lebih sedikit untuk dipikirkan, dan sumbu mendatar kurvanya langsung terbaca sebagai menit tanpa perlu dikonversi.

| Pengaturan | Pilihan | Bawaan |
|---|---|---|
| Durasi | 5 / 10 / 20 / 30 / 60 menit | 10 menit |
| Interval garis | tetap 1 menit | &mdash; |

> [!NOTE]
> Ini menyimpang dari Pauli di kertas, yang aba-abanya jatuh tiap 3 menit. Konsekuensinya: pada simulasi 60 menit, aba-aba berbunyi 60 kali, bukan 20. Kalau nanti mode simulasi ingin terasa persis seperti tes aslinya, pisahkan kedua hal itu &mdash; bunyi aba-aba tiap 3 menit, tapi titik kurva tetap direkam tiap menit.

> [!WARNING]
> Hitung waktu dari `Stopwatch` atau selisih `DateTime`, **jangan** menumpuk hitungan dari `Timer.periodic`. Tiap tick meleset beberapa milidetik; dalam 60 menit akumulasinya bisa puluhan detik dan seluruh pembagian segmen jadi berantakan. `Timer.periodic` tetap dipakai, tapi hanya untuk memicu pengecekan — angka waktunya selalu dibaca dari stopwatch.

Saat garis jatuh:

- Getar pendek lewat `HapticFeedback.mediumImpact()` (bawaan Flutter, tidak perlu paket) plus bunyi klik singkat yang bisa dimatikan.
- Garis tipis melintas layar sekejap — 200–300 ms. Lebih lama dari itu justru memotong ritme.
- Pengerjaan **tidak berhenti**. Segmen berganti diam-diam di belakang layar.

**Gangguan di tengah tes.** Sesi 60 menit hampir pasti kena telepon atau notifikasi. Pakai `WidgetsBindingObserver`: begitu aplikasi masuk latar belakang, tes dijeda dan sesi ditandai `interrupted`. Sesi bertanda ini tetap disimpan tapi dikecualikan dari grafik tren, supaya rata-rata jangka panjang tidak tercemar. Selama tes berjalan, `wakelock_plus` menahan layar tetap menyala.

## Layar tes

Satu aturan mengalahkan semua pertimbangan desain lain di layar ini: **jangan hambat ritme.**

```
┌─────────────────────────┐
│ MENIT 12 / 60           │
│ ▓▓▓▓░░░░░░░░░░░░░░░░░░░ │
│                         │
│            7            │
│            4            │
│          ─────          │
│           [ ? ]         │
│                         │
│      1     2     3      │
│      4     5     6      │
│      7     8     9      │
│    hapus      0         │
└─────────────────────────┘
```

- **Tanpa tombol kirim.** Tekan angka = tercatat dan langsung lanjut.
- **Tanpa umpan balik benar/salah selama tes.** Tanda centang atau silang memecah konsentrasi, dan tes aslinya juga tidak memberi tahu. Semua penilaian ditahan sampai layar hasil.
- **Tombol minimal 56 dp.** Di kecepatan satu ketukan per detik, tombol kecil menghasilkan salah tekan yang terbaca sebagai "tidak teliti" padahal cuma masalah tata letak.
- **Numpad di zona jempol**, tombol hapus dipisah dari deretan angka. Karena tidak ada tombol kirim, hapus berarti *menarik kembali jawaban terakhir*: soalnya kembali persis seperti semula untuk dijawab ulang, dan hitungan pembetulan naik satu.
- **Tombol kembali dikunci** dengan `PopScope` + dialog konfirmasi. Keluar tak sengaja di menit ke-50 itu menyakitkan.
- **Tidak ada penghitung segmen.** Karena satu segmen sama dengan satu menit, label menit sudah menyatakannya &mdash; dua angka yang berarti sama hanya menambah beban baca.
- **Catat `responseMs` tiap jawaban.** Murah disimpan, dan membuka analisis tempo yang tidak mungkin dilakukan di kertas.

Alur layar:

```mermaid
flowchart LR
  A[Beranda] --> B[Pengaturan sesi]
  B --> C[Hitung mundur 3 detik]
  C --> D[Layar tes]
  D --> E[Hasil + kartu PNG]
  E --> F[Riwayat]
  F --> A
  A --> F
```

Hitung mundurnya bukan hiasan: tanpa itu, soal pertama muncul saat jempol masih dalam perjalanan, dan segmen pertama selalu terlihat lebih rendah dari yang sebenarnya.

## Skoring & kurva

Tiap segmen menyimpan empat angka: berapa dijawab, berapa benar, berapa salah, dan rata-rata waktu respons. Semua metrik ringkasan diturunkan dari situ.

| Metrik | Rumus | Yang dibaca darinya |
|---|---|---|
| Jumlah kerja | `Σ benar` | kapasitas dan kecepatan keseluruhan |
| Ketelitian | `benar / dijawab × 100%` | kecermatan; turun tajam saat memaksakan kecepatan |
| Puncak | `max(benar per segmen)` | kemampuan terbaik saat kondisi optimal |
| Lembah | `min(benar per segmen)` | titik paling jenuh |
| Rentang | `puncak − lembah` | kestabilan; makin kecil makin rata |
| Simpangan | `stdev(benar per segmen)` | keajegan, lebih tahan pencilan dibanding rentang |
| Tren | kemiringan regresi linier | daya tahan; positif berarti kuat sampai akhir |
| Pembetulan | `Σ jawaban dihapus` | keragu-raguan |

**Soal penamaan.** Istilah aslinya — *panker, janker, hanker, tianker* — sengaja tidak dipakai sebagai label utama. Definisinya berbeda-beda antar sumber, normanya tidak dipublikasikan resmi, dan salah satunya berbunyi buruk di telinga orang Indonesia. Pakai bahasa yang jelas di antarmuka; istilah aslinya boleh muncul sebagai keterangan kecil di layar penjelasan.

**Kurvanya.** Sumbu mendatar menit, sumbu tegak jumlah benar per menit. Garis rata-rata jadi acuan diam; puncak dan lembah diberi label langsung. Cukup satu deret data, jadi tidak perlu legenda.

**Grafik tren antar sesi memakai satuan yang berbeda:** rata-rata benar *per menit*, bukan jumlah kerja mentah. Jumlah mentah sesi 60 menit selalu enam kali lipat sesi 10 menit, jadi grafik yang memakainya cuma akan menggambarkan pilihan durasi dan bukan perkembangan.

## Model data

```dart
class PauliSession {
  final String   id;
  final DateTime startedAt;
  final int      durationSec;    // 600, 3600, ...
  final int      intervalSec;    // selalu 60; disimpan supaya sesi lama
                                 // tetap terbaca kalau aturannya berubah
  final int      seed;           // supaya deret bisa dibangkitkan ulang
  final bool     interrupted;    // sempat masuk latar belakang
  final int      totalAnswered;
  final int      totalCorrect;
  final int      totalWrong;
  final int      totalCorrections;
  final List<PauliSegment> segments;
}

class PauliSegment {
  final int    index;          // 0..n-1
  final int    answered;
  final int    correct;
  final int    wrong;
  final double avgResponseMs;
}

// Opsional — hanya kalau "simpan detail" diaktifkan
class PauliAnswer {
  final String sessionId;      // id sesi di atas, bukan rowid bawaan SQLite:
                               // sesi sudah punya id sebelum sempat disimpan
  final int elapsedMs;
  final int a, b;              // angka atas & bawah
  final int expected, given;
  final int responseMs;
}
```

> [!NOTE]
> Sesi 60 menit menghasilkan 3.000–6.000 baris `PauliAnswer`. SQLite santai menanganinya, tapi kalau disimpan untuk setiap sesi, basis data ikut membengkak tanpa ada yang membacanya. Matikan secara bawaan; jadikan saklar di pengaturan.

## Arsitektur

```
lib/
  main.dart
  app.dart
  core/
    theme.dart              warna, tipografi, ukuran tombol
    formatters.dart         tanggal & desimal Indonesia, tanpa intl
    brand_mark.dart         ikon aplikasi sebagai CustomPainter
  domain/                   <- Dart murni, TANPA impor Flutter
    pauli_engine.dart       pembangkit deret berantai + seed
    scoring.dart            semua rumus di bagian Skoring
    models.dart
  data/
    db/database.dart        drift: tabel + migrasi (.g.dart hasil generasi)
    session_repository.dart
    providers.dart          riverpod: basis data, riwayat, pengaturan
  features/
    home/
    setup/                  durasi, suara, getar, angka nol, simpan detail
    about/                  penjelasan tes, deret berantai, arti tiap metrik
    test/
      test_screen.dart
      test_controller.dart  stopwatch, segmen, aba-aba garis
      numpad.dart
      question_display.dart
    result/
      result_screen.dart
      result_card.dart      widget yang dirender jadi PNG
      work_curve.dart       kurva kerja, dipakai ulang di kartu & beranda
      segment_detail_screen.dart
    history/
      history_screen.dart
      trend_chart.dart

test/
  pauli_engine_test.dart
  scoring_test.dart         <- yang paling penting
  test_controller_test.dart
  session_repository_test.dart
  widget_smoke_test.dart
```

Satu batas dijaga ketat: **`domain/` tidak boleh mengimpor Flutter.** Kalau bersih, seluruh rumus skoring bisa diuji dengan `flutter test` dalam hitungan detik tanpa emulator. Kalau tercampur widget, satu-satunya cara memastikan hitungannya benar adalah mengerjakan tes 60 menit dengan tangan — dan itu tidak akan dilakukan berulang kali.

## Paket

Versi dicek di pub.dev pada 1 September 2026.

| Paket | Versi | Untuk apa |
|---|---|---|
| `flutter_riverpod` | ^2.6 | state management; ringan dan enak diuji |
| `drift` + `drift_flutter` | ^2.34 | riwayat lokal, query tren antar sesi |
| `fl_chart` | ^1.2 | kurva kerja dan grafik tren |
| `share_plus` | ^13.3 | membagikan PNG hasil |
| `path_provider` | ^2.1 | lokasi file sementara untuk PNG |
| `wakelock_plus` | ^1.8 | layar tetap menyala selama tes |
| `clock` | ^1.1 | sumber waktu yang bisa dipalsukan saat diuji |

Di sisi `dev_dependencies`: `drift_dev` + `build_runner` untuk kode generasi drift, dan `fake_async` untuk menjalankan sesi 60 menit di dalam tes.

> [!WARNING]
> **`sqlite3_flutter_libs` sudah tidak diperlukan.** Sejak `sqlite3` versi 3.x, paket itu ditandai usang dan versi 0.6.0 sudah dikosongkan isinya. Yang dipakai sekarang `drift_flutter`, yang sekaligus menyediakan `driftDatabase(name: ...)` untuk membuka basis data tanpa kode khusus tiap platform.

> [!NOTE]
> **Stopwatch diambil dari `package:clock`, bukan `Stopwatch()` langsung.** Perilakunya identik di aplikasi, tapi di dalam `fakeAsync` stopwatch itu ikut maju bersama waktu palsu — sehingga sesi 60 menit penuh bisa diuji dalam hitungan milidetik. Tanpa itu, satu-satunya cara memastikan pembagian segmennya benar adalah duduk mengerjakan tes 60 menit.

> [!WARNING]
> **API `share_plus` sudah berubah.** Banyak tutorial masih memakai `Share.shareXFiles(...)` yang kini usang. Yang berlaku sejak versi 11 ke atas:
> ```dart
> await SharePlus.instance.share(
>   ShareParams(files: [XFile(path)], text: 'Hasil latihan Pauli saya'),
> );
> ```

Tidak perlu paket tambahan untuk merender PNG (`RepaintBoundary` + `toImage()` sudah ada di Flutter) maupun untuk getar (`HapticFeedback` ada di `services.dart`).

Kalau nanti terasa berat, `drift` bisa diganti `sqflite` atau `hive_ce`. Drift dipilih karena begitu fitur tren masuk ("rata-rata 10 sesi terakhir", "puncak tertinggi bulan ini"), query semacam itu jadi jauh lebih ringkas.

## Menjalankan

```bash
flutter pub get
dart run build_runner build   # untuk drift; hasilnya lib/data/db/database.g.dart
flutter run
```

> [!NOTE]
> `--delete-conflicting-outputs` sudah tidak berlaku di `build_runner` 2.15 ke atas — flagnya diterima tapi diabaikan dengan peringatan.

**Yang dibutuhkan untuk membangun ke Android:**

| Komponen | Versi | Kenapa |
|---|---|---|
| JDK | 21 | Gradle 9.1 + AGP 9.0 |
| Platform + build-tools | android-36 / 36.0.0 | `compileSdk` bawaan Flutter 3.44 |
| **NDK** | 28.2.13676358 | wajib, lihat catatan di bawah |

> [!WARNING]
> **NDK bukan opsional di proyek ini.** Sejak `sqlite3` 3.x, SQLite tidak lagi dikirim sebagai pustaka siap pakai melainkan **dikompilasi dari sumber C** lewat build hook `native_toolchain_c` — termasuk untuk Android. Native assets sendiri sudah aktif secara bawaan di channel stable, jadi tanpa NDK terpasang, `flutter build apk` gagal. Ini mudah terlewat karena tidak ada satu pun baris C di repo ini.

Terverifikasi jalan di emulator **Android 16 (API 36), x86_64**: sesi berjalan penuh sampai selesai, hasilnya tersimpan ke `app_flutter/pauliku.sqlite`, dan tombol bagikan menghasilkan PNG 1080 × 1350 yang diterima lembar berbagi Android.

Seluruh berkas uji jalan tanpa emulator, termasuk yang menjalankan sesi 60 menit dan yang merender kartu PNG:

```bash
flutter test                       # 66 tes, beberapa detik
flutter test test/scoring_test.dart
```

| Berkas uji | Yang dijaga |
|---|---|
| `pauli_engine_test.dart` | rantai deret, rentang digit, jawaban, keterulangan seed |
| `scoring_test.dart` | pembagian segmen dan seluruh rumus di bagian Skoring |
| `test_controller_test.dart` | stopwatch, batas menit, aba-aba, jeda, undo — di dalam waktu palsu |
| `session_repository_test.dart` | simpan-baca sesi, cascade delete, pengaturan (SQLite di memori) |
| `widget_smoke_test.dart` | tiap layar terpasang tanpa luber; kartu benar-benar 1080 × 1350 |

## Kartu hasil

Yang dibagikan bukan tangkapan layar, tapi gambar yang memang dirancang untuk dibagikan.

- **Ukuran 1080 × 1350** (rasio 4:5) — pas untuk WhatsApp dan Instagram tanpa terpotong.
- **Dirender di luar layar** lewat `RepaintBoundary`, bukan tangkapan layar HP, supaya hasilnya seragam di HP kecil maupun tablet.
- **Isinya:** kurva, empat metrik utama (jumlah kerja, ketelitian, rentang, tren), durasi dan tanggal, nama aplikasi kecil di bawah.
- **Yang tidak masuk:** tabel per segmen — terlalu padat untuk dilihat di layar orang lain. Simpan di layar detail.

```dart
final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
final image = await boundary.toImage(pixelRatio: 1080 / 360);
final bytes = await image.toByteData(format: ImageByteFormat.png);

final file = File('${(await getTemporaryDirectory()).path}/pauliku.png');
await file.writeAsBytes(bytes!.buffer.asUint8List());

await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
```

## Roadmap

Urutannya dipilih supaya aplikasinya berguna untuk dipakai sendiri sedini mungkin.

- [x] **v0.1 — Bisa dipakai sendiri**
      Pembangkit deret, layar tes, stopwatch dan segmen, hasil dalam angka mentah.
- [x] **v0.2 — Kurva dan berbagi**
      `fl_chart`, semua metrik, kartu hasil PNG, tombol bagikan. Di titik ini nilai jual sebenarnya sudah ada.
- [x] **v0.3 — Riwayat dan tren**
      Penyimpanan drift, daftar sesi, grafik perkembangan antar sesi. Sesi `interrupted` dikecualikan dari tren.
- [ ] **v1.0 — Siap rilis**
      Pengaturan sudah lengkap dan halaman penjelasan metrik sudah ada. Sisanya: onboarding singkat saat pertama membuka, set ikon iOS, tangkapan layar Play Store, dan halaman kebijakan privasi.
- [ ] **Nanti**
      Mode Kraepelin (kolom, dijumlah dari bawah ke atas), mode kolom mirip kertas untuk layar besar, pengingat latihan harian, ekspor PDF.

## Identitas visual

Ikon terpilih: **Rantai** (`docs/icon.svg`). Dua busur berbagi satu titik di tengah — titik kuning itu adalah angka yang dipakai dua kali. Ikonnya menggambarkan mekanik yang membedakan Pauli dari kuis penjumlahan biasa.

| Peran | Hex | Catatan |
|---|---|---|
| Latar gelap | `#101A18` | latar ikon, tema gelap aplikasi |
| Hijau utama | `#0F6B57` | aksen tema terang, tombol utama |
| Hijau terang | `#4ECFA8` | busur ikon, garis kurva di tema gelap |
| Kuning sorot | `#E9A13B` | titik puncak, angka yang dipakai dua kali |
| Krem | `#F0EDE3` | latar terang, teks di atas hijau |

Angka di seluruh aplikasi memakai typeface monospace supaya lebarnya tetap dan tidak "bergoyang" saat berganti soal.

Mockup kedelapan layar ada di `docs/screens/` (empat di antaranya dipasang di bagian [Tampilan](#tampilan)).

**Ikon Android sudah diturunkan** dari `docs/icon.svg` sebagai *vector drawable*, bukan PNG: `ic_launcher_foreground.xml` (busur dan titik, diperkecil 0,776 supaya berhenti di batas area aman 66 dp dari 108 dp), warna latar terpisah, plus versi `monochrome` untuk ikon bertema Android 13+ — versi itu membuang cincin pemisah di tengah, yang kalau ikut digambar malah menutup celah antar busur dan membuat marknya jadi gumpalan.

**Berikutnya untuk ikon:** set app icon iOS (butuh PNG beberapa ukuran) dan PNG cadangan `mipmap-*` untuk Android di bawah API 26, yang sampai sekarang masih memakai bawaan Flutter.

## Rilis

- **Application id:** `id.pauliku.app`
- **Judul Play Store:** "PauliKu — Latihan Tes Koran". Nama merek di depan, kata kunci di belakang, supaya tetap ketemu saat orang mencari "tes koran".
- **Ceruk namanya lapang.** Penelusuran Play Store tidak menemukan aplikasi bernama PauliKu; yang ada semuanya varian deskriptif (*Tes Koran*, *Tes Kraepelin: Psikotes Pauli*, *Tes Koran — Pauli & Kraepelin*, *Psikotes Kerja Kraepelin*) yang saling bertabrakan di hasil pencarian.
- **Hindari di deskripsi:** klaim hasil psikotes resmi, klaim kelulusan, penyebutan nama lembaga rekrutmen mana pun.
- **Data Safety:** tanpa akun dan tanpa jaringan, isiannya paling sederhana — tidak mengumpulkan data apa pun.
- **Perlu disiapkan:** halaman kebijakan privasi (Play Store mewajibkan tautannya). Cek ketersediaan `pauliku.id` atau `pauliku.app`.

## Yang gampang salah

| Masalah | Akibatnya | Penangkalnya |
|---|---|---|
| Pasangan lepas, bukan deret berantai | Yang dibuat bukan tes Pauli | Angka bawah selalu naik jadi angka atas |
| Waktu ditumpuk dari tick timer | Sesi 60 menit meleset puluhan detik | Baca waktu dari `Stopwatch` |
| Layar mati di tengah tes | Sesi 60 menit hilang | `wakelock_plus` aktif selama tes |
| Tombol numpad terlalu kecil | Salah tekan terbaca sebagai tidak teliti | Minimal 56 dp, hapus dipisah dari angka |
| Menyimpan semua jawaban secara bawaan | Basis data membengkak tanpa dibaca | Jadikan saklar opsional |
| Menampilkan tafsir kepribadian | Klaim yang tidak bisa dipertanggungjawabkan | Skor mentah dan kurva saja |

## Lisensi

Belum ditentukan. Kalau repo ini dibuka ke publik, tentukan lisensinya sebelum commit pertama yang berisi kode.

---

<div align="center">
<sub>PauliKu bukan alat asesmen psikologi dan tidak berafiliasi dengan penerbit tes mana pun.<br>
Aplikasi ini menampilkan skor mentah dan kurva kerja untuk keperluan latihan pribadi.</sub>
</div>
