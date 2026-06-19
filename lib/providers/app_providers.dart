import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/species.dart';
import '../models/achievement.dart';
import '../core/constants.dart';
import '../services/species_service.dart';
import '../services/achievement_service.dart';
import '../services/storage_service.dart';

// ─────────────────────────────────────────
// Supabase client
// ─────────────────────────────────────────

final supabaseProvider = Provider<SupabaseClient>(
  (_) => Supabase.instance.client,
);

// ─────────────────────────────────────────
// Auth
// ─────────────────────────────────────────

final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange
      .map((e) => e.session?.user);
});

// ─────────────────────────────────────────
// Services
// ─────────────────────────────────────────

final speciesServiceProvider = Provider<SpeciesService>(
  (ref) => SpeciesService(ref.watch(supabaseProvider)),
);

final achievementServiceProvider = Provider<AchievementService>(
  (ref) => AchievementService(ref.watch(supabaseProvider)),
);

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(ref.watch(supabaseProvider)),
);

// ─────────────────────────────────────────
// Species list (ordered by family + sort_order)
// ─────────────────────────────────────────

final speciesListProvider =
    AsyncNotifierProvider<SpeciesNotifier, List<Species>>(
        SpeciesNotifier.new);

class SpeciesNotifier extends AsyncNotifier<List<Species>> {
  @override
  Future<List<Species>> build() async {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return [];
    return ref.read(speciesServiceProvider).fetchAll(user.id);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> importStarter() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    await ref.read(speciesServiceProvider).importStarterList(user.id);
    await reload();
  }

  Future<void> addCustom({
    required String commonName,
    String? chineseName,
    String? scientificName,
    String? familyGroup,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    await ref.read(speciesServiceProvider).add(
          user.id,
          commonName: commonName,
          chineseName: chineseName,
          scientificName: scientificName,
          familyGroup: familyGroup,
        );
    await reload();
  }

  Future<void> remove(String speciesId) async {
    await ref.read(speciesServiceProvider).delete(speciesId);
    await reload();
  }
}

// ─────────────────────────────────────────
// Achievements map (speciesId -> Achievement)
// ─────────────────────────────────────────

final achievementsProvider = AsyncNotifierProvider<AchievementsNotifier,
    Map<String, Achievement>>(AchievementsNotifier.new);

class AchievementsNotifier
    extends AsyncNotifier<Map<String, Achievement>> {
  @override
  Future<Map<String, Achievement>> build() async {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return {};
    return ref.read(achievementServiceProvider).fetchAll(user.id);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> unlock(
    String speciesId,
    AchievementLevel level, {
    String? photoUrl,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    final current = state.value ?? {};
    final updated = await ref.read(achievementServiceProvider).unlockLevel(
          user.id,
          speciesId,
          level,
          photoUrl: photoUrl,
          existingMap: current,
        );
    state = AsyncData({...current, speciesId: updated});
  }

  Future<void> revoke(String speciesId, AchievementLevel level) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    final current = state.value ?? {};
    final updated = await ref.read(achievementServiceProvider).revokeLevel(
          user.id,
          speciesId,
          level,
          existingMap: current,
        );
    state = AsyncData({...current, speciesId: updated});
  }
}

// ─────────────────────────────────────────
// Stats
// ─────────────────────────────────────────

class AchievementStats {
  final int green;
  final int blue;
  final int yellow;
  final int red;
  final int total;

  const AchievementStats({
    required this.green,
    required this.blue,
    required this.yellow,
    required this.red,
    required this.total,
  });
}

final statsProvider = Provider<AchievementStats>((ref) {
  final achievements = ref.watch(achievementsProvider).value ?? {};
  int green = 0, blue = 0, yellow = 0, red = 0;
  for (final a in achievements.values) {
    if (a.levels[AchievementLevel.green]?.unlocked == true) green++;
    if (a.levels[AchievementLevel.blue]?.unlocked == true) blue++;
    if (a.levels[AchievementLevel.yellow]?.unlocked == true) yellow++;
    if (a.levels[AchievementLevel.red]?.unlocked == true) red++;
  }
  return AchievementStats(
    green: green, blue: blue, yellow: yellow, red: red,
    total: ref.watch(speciesListProvider).value?.length ?? 0,
  );
});
