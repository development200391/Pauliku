import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Penjelasan singkat tesnya, mekanik deret berantai, dan arti tiap metrik.
///
/// Istilah asli — panker, janker, hanker, tianker — sengaja tidak dipakai
/// sebagai label utama: definisinya berbeda-beda antar sumber dan normanya
/// tidak dipublikasikan resmi. Disebut sekali di sini, sebagai keterangan.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang tes Pauli')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          PauliSizes.gutter,
          8,
          PauliSizes.gutter,
          40,
        ),
        children: [
          const _Para(
            'Tes Pauli — di Indonesia lebih dikenal sebagai tes koran, karena '
            'lembar kertasnya selebar koran — adalah tes penjumlahan '
            'berdurasi panjang yang dipakai di banyak proses rekrutmen. '
            'Aturannya satu kalimat: jumlahkan dua angka, tulis digit '
            'terakhirnya.',
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '7 + 4 = 11  ->  tulis 1\n4 + 9 = 13  ->  tulis 3',
                style: mono(size: 15, height: 1.8, color: PauliColors.ink),
              ),
            ),
          ),
          const SizedBox(height: 26),
          const _Head('Deret berantai'),
          const _Para(
            'Yang dijumlahkan adalah angka yang bertetangga di dalam satu '
            'deret, bukan pasangan yang lepas satu sama lain. Karena itu '
            'setiap angka dipakai dua kali: sekali sebagai angka bawah, '
            'sekali sebagai angka atas.',
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '  7   4   9   2   6\n'
                '  └─┬─┘   │   │   │\n'
                '    1 └─┬─┘   │   │\n'
                '        3 └─┬─┘   │\n'
                '            1 └─┬─┘\n'
                '                8',
                style: mono(size: 13, height: 1.5, color: PauliColors.ink),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const _Para(
            'Di layar tes, begitu jawaban ditekan, angka bawah naik menjadi '
            'angka atas dan satu angka baru muncul di bawahnya.',
          ),
          const SizedBox(height: 26),
          const _Head('Kenapa hasilnya berupa kurva'),
          const _Para(
            'Yang diukur bukan kemampuan berhitung, melainkan pola kerja: '
            'kecepatan, ketelitian, kestabilan, dan daya tahan saat mulai '
            'lelah. Karena itu hasilnya dibaca sebagai kurva, bukan sebagai '
            'satu angka nilai. Aplikasi ini menancapkan satu penanda tiap '
            'menit, dan penanda itulah yang jadi titik-titik kurvanya.',
          ),
          const SizedBox(height: 26),
          const _Head('Arti tiap angka'),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: const [
                _Metric(
                  'Jumlah kerja',
                  'Total jawaban benar sepanjang sesi — kapasitas dan '
                      'kecepatan keseluruhan.',
                ),
                Divider(),
                _Metric(
                  'Ketelitian',
                  'Benar dibagi dijawab. Biasanya turun tajam saat kecepatan '
                      'dipaksakan.',
                ),
                Divider(),
                _Metric(
                  'Puncak dan lembah',
                  'Menit dengan jawaban benar terbanyak dan tersedikit — '
                      'kondisi terbaik dan titik paling jenuh.',
                ),
                Divider(),
                _Metric(
                  'Rentang',
                  'Jarak puncak ke lembah. Makin kecil, makin rata pola '
                      'kerjanya.',
                ),
                Divider(),
                _Metric(
                  'Simpangan',
                  'Sebaran jawaban benar antar menit. Lebih tahan pencilan '
                      'dibanding rentang.',
                ),
                Divider(),
                _Metric(
                  'Tren',
                  'Kemiringan garis lurus yang paling pas dengan kurvanya. '
                      'Positif berarti masih kuat sampai akhir.',
                ),
                Divider(),
                _Metric(
                  'Pembetulan',
                  'Berapa kali jawaban ditarik kembali dengan tombol hapus — '
                      'penanda keragu-raguan.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const _Head('Yang tidak dilakukan aplikasi ini'),
          const _Para(
            'PauliKu adalah alat latihan, bukan asesmen. Norma dan '
            'interpretasi resmi tes Pauli dipegang penerbit tes psikologi dan '
            'tidak dipublikasikan bebas, jadi yang ditampilkan di sini hanya '
            'skor mentah beserta kurvanya — bukan kesimpulan kepribadian, '
            'bukan prediksi kelulusan.',
          ),
          const SizedBox(height: 12),
          const _Para(
            'Istilah panker, janker, hanker, dan tianker yang beredar di '
            'sumber lain sengaja tidak dipakai sebagai label di sini: '
            'definisinya berbeda-beda antar sumber dan tidak ada norma resmi '
            'yang bisa dirujuk.',
          ),
          const SizedBox(height: 26),
          const _Head('Privasi'),
          const _Para(
            'Semua soal dibangkitkan di dalam HP dan semua hasil disimpan di '
            'dalam HP. Tidak ada akun, tidak ada server, tidak ada data yang '
            'dikirim ke mana pun — aplikasi ini tetap jalan penuh tanpa '
            'sinyal.',
          ),
          const SizedBox(height: 30),
          const Text(
            'PauliKu bukan alat asesmen psikologi dan tidak berafiliasi '
            'dengan penerbit tes mana pun.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: PauliColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: PauliColors.ink,
        ),
      ),
    );
  }
}

class _Para extends StatelessWidget {
  const _Para(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, height: 1.55, color: PauliColors.ink),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.name, this.description);

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: PauliColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
