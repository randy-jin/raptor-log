import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/achievement.dart';
import '../core/constants.dart';

class AchievementService {
  final SupabaseClient _client;
  AchievementService(this._client);

  Future<Map<String, Achievement>> fetchAll(String userId) async {
    final data = await _client
        .from('achievements')
        .select()
        .eq('user_id', userId);
    final map = <String, Achievement>{};
    for (final row in data as List) {
      final a = Achievement.fromJson(row);
      map[a.speciesId] = a;
    }
    return map;
  }

  Future<Achievement> upsert(Achievement achievement) async {
    final payload = achievement.toUpsertJson(
      achievement.userId,
      achievement.speciesId,
    );
    final data = await _client
        .from('achievements')
        .upsert(payload, onConflict: 'user_id,species_id')
        .select()
        .single();
    return Achievement.fromJson(data);
  }

  Future<Achievement> unlockLevel(
    String userId,
    String speciesId,
    AchievementLevel level, {
    String? photoUrl,
    Map<String, Achievement>? existingMap,
  }) async {
    final existing = existingMap?[speciesId] ??
        Achievement.empty(speciesId, userId);
    final updated = existing.withLevelUnlocked(level, photoUrl: photoUrl);
    return upsert(updated);
  }

  Future<Achievement> revokeLevel(
    String userId,
    String speciesId,
    AchievementLevel level, {
    Map<String, Achievement>? existingMap,
  }) async {
    final existing = existingMap?[speciesId] ??
        Achievement.empty(speciesId, userId);
    final updated = existing.withLevelRevoked(level);
    return upsert(updated);
  }
}
