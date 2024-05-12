import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_storage.g.dart';

@Riverpod(keepAlive: true)
SupabaseStorage supabaseStorage(SupabaseStorageRef ref) {
  return SupabaseStorage(Supabase.instance.client);
}

const String bucketNameForBoard = 'public_image';

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

  /// imageをstorage にアップロード path -> public_image/(boardId)/(objectId).拡張子
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

  Future<void> deleteImage(String path) async {
    final imagePath = path.split('$bucketNameForBoard/').last;
    final paths = [imagePath];
    try {
      final res = await _client.storage.from(bucketNameForBoard).remove(paths);
      if (res.isEmpty) {
        throw Exception('image delete failed: $path');
      }
    } on PostgrestException catch (error) {
      print('Error deleting image: ${error.message}');
    } catch (e) {
      print('error -: $e');
    }
  }

  Future<void> deleteImageFolder(BoardModel board) async {
    try {
      for (final object in board.objects) {
        if (object.type == ObjectType.networkImage) {
          if (object.imageUrl == null) {
            continue;
          }
          await deleteImage(object.imageUrl!);
        }
      }
    } catch (e) {
      print('image folder delete failed');
    }
  }
}
