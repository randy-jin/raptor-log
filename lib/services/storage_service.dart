import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';

class StorageService {
  final SupabaseClient _client;
  StorageService(this._client);

  Future<String> uploadPhoto({
    required String userId,
    required String speciesId,
    required String levelKey,
    required File file,
  }) async {
    final ext = file.path.split('.').last;
    final path = '$userId/$speciesId/$levelKey.$ext';
    await _client.storage
        .from(storageBucket)
        .upload(path, file, fileOptions: const FileOptions(upsert: true));
    return _client.storage.from(storageBucket).getPublicUrl(path);
  }

  Future<void> deletePhoto({
    required String userId,
    required String speciesId,
    required String levelKey,
  }) async {
    // Try both jpg and png
    for (final ext in ['jpg', 'jpeg', 'png', 'heic']) {
      try {
        await _client.storage
            .from(storageBucket)
            .remove(['$userId/$speciesId/$levelKey.$ext']);
      } catch (_) {}
    }
  }
}
