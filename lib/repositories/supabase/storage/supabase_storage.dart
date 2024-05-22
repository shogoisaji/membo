import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter/foundation.dart';
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
const String bucketNameForAvatar = 'avatar_image';

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
  Future<String?> uploadXFileImage(
      XFile file, String bucketName, String filePath) async {
    final Uint8List bytes = await file.readAsBytes();

    final convertedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: 1080,
      minWidth: 1080,
      quality: 50,
      autoCorrectionAngle: false,
      format: CompressFormat.webp,
    );

    final insertFilePath = '$filePath.webp';

    try {
      await _client.storage.from(bucketName).uploadBinary(
            insertFilePath,
            convertedBytes,
          );
      final fileUrl = _client.storage.from(bucketName).getPublicUrl(
            insertFilePath,
          );
      return fileUrl;
    } on StorageException catch (e) {
      throw Exception('Error StorageException: ${e.message}');
    } catch (e) {
      if (e.toString() ==
          "Exception: Error deleting board: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'") {
        return null;
      }
      throw Exception('Error uploading XFile image');
    }
  }

  Future<void> deleteAvatarImage(String path) async {
    final imagePath = path.split('$bucketNameForAvatar/').last;
    final paths = [imagePath];
    try {
      final res = await _client.storage.from(bucketNameForAvatar).remove(paths);
      if (res.isEmpty) {
        throw Exception('image delete failed: $path');
      }
    } on PostgrestException catch (error) {
      throw Exception('Error deleting image : PostgrestException');
    } catch (e) {
      throw Exception('Error deleting image');
    }
  }

  Future<void> deleteObjectImage(String path) async {
    final imagePath = path.split('$bucketNameForBoard/').last;
    final paths = [imagePath];
    try {
      final res = await _client.storage.from(bucketNameForBoard).remove(paths);
      if (res.isEmpty) {
        throw Exception('image delete failed: $path');
      }
    } on PostgrestException catch (_) {
      throw Exception('Error deleting image : PostgrestException');
    } catch (e) {
      throw Exception('Error deleting image');
    }
  }

  Future<void> deleteImageFolder(BoardModel board) async {
    try {
      for (final object in board.objects) {
        if (object.type == ObjectType.networkImage) {
          if (object.imageUrl == null) {
            continue;
          }
          await deleteObjectImage(object.imageUrl!);
        }
      }
    } catch (e) {
      throw Exception('Error deleting image folder');
    }
  }
}
