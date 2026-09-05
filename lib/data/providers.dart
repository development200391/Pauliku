import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models.dart';
import 'db/database.dart';
import 'session_repository.dart';

final databaseProvider = Provider<PauliDatabase>((ref) {
  final db = PauliDatabase.defaults();
  ref.onDispose(db.close);
  return db;
});

final repositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(ref.watch(databaseProvider)),
);

/// Riwayat sesi, terbaru lebih dulu. Di-`invalidate` setelah sesi baru
/// tersimpan atau setelah sesi dihapus.
final historyProvider = FutureProvider<List<PauliSession>>(
  (ref) => ref.watch(repositoryProvider).recent(),
);

final configProvider = AsyncNotifierProvider<ConfigNotifier, SessionConfig>(
  ConfigNotifier.new,
);

/// Pengaturan sesi, dibaca sekali saat aplikasi dibuka lalu ditulis balik tiap
/// kali diubah — supaya pilihan durasi tidak perlu diatur ulang tiap latihan.
class ConfigNotifier extends AsyncNotifier<SessionConfig> {
  @override
  Future<SessionConfig> build() => ref.watch(repositoryProvider).loadConfig();

  Future<void> save(SessionConfig config) async {
    state = AsyncData(config);
    await ref.read(repositoryProvider).saveConfig(config);
  }
}
