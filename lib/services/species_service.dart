import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/species.dart';
import '../core/constants.dart';

class SpeciesService {
  final SupabaseClient _client;
  SpeciesService(this._client);

  Future<List<Species>> fetchAll(String userId) async {
    final data = await _client
        .from('species')
        .select()
        .eq('user_id', userId)
        .order('sort_order')
        .order('common_name');
    return (data as List).map((e) => Species.fromJson(e)).toList();
  }

  Future<Species> add(String userId, {
    required String commonName,
    String? chineseName,
    String? scientificName,
    String? familyGroup,
    String? descriptionEn,
    String? descriptionZh,
    int sortOrder = 999,
  }) async {
    final data = await _client.from('species').insert({
      'user_id': userId,
      'common_name': commonName,
      'chinese_name': chineseName,
      'scientific_name': scientificName,
      'family_group': familyGroup,
      'description_en': descriptionEn,
      'description_zh': descriptionZh,
      'sort_order': sortOrder,
    }).select().single();
    return Species.fromJson(data);
  }

  Future<void> delete(String speciesId) async {
    await _client.from('species').delete().eq('id', speciesId);
  }

  /// Import the full starter list for a new user.
  Future<void> importStarterList(String userId) async {
    final rows = kStarterSpecies
        .map((s) => {
              'user_id': userId,
              'common_name': s.commonName,
              'chinese_name': s.chineseName,
              'scientific_name': s.scientificName,
              'family_group': s.familyGroup,
              'description_en': s.descriptionEn,
              'description_zh': s.descriptionZh,
              'sort_order': s.sortOrder,
            })
        .toList();
    // upsert to avoid duplicates if called twice
    await _client.from('species').upsert(rows, onConflict: 'user_id,common_name');
  }
}
