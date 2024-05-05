import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_storage.g.dart';

@Riverpod(keepAlive: true)
SupabaseStorage supabaseStorage(SupabaseStorageRef ref) {
  return SupabaseStorage(Supabase.instance.client);
}

class SupabaseStorage {
  SupabaseStorage(this._client);

  final SupabaseClient _client;

  Future<String> createBucket(String bucketName) async {
    try {
      return await _client.storage.createBucket(bucketName);
    } on PostgrestException catch (error) {
      throw Exception('Error creating bucket: ${error.message}');
    }
  }

  Future<String?> uploadXFileImage(XFile file, String insertPath) async {
    final Uint8List bytes = await file.readAsBytes();
    try {
      await _client.storage.from('public_image').uploadBinary(
            insertPath,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final fileUrl = _client.storage.from('public_image').getPublicUrl(
            insertPath,
          );
      return fileUrl;
    } on StorageException catch (error) {
      throw Exception('Error uploading image: ${error.message}');
    }
  }

  Future<String?> deleteImage(String path) async {
    final paths = [path];
    try {
      await _client.storage.from('image').remove(paths);
    } on PostgrestException catch (error) {
      print(error);
    }
    return null;
  }
}
