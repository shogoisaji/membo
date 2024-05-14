import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/models/user/user_model.dart';
import 'package:membo/repositories/supabase/storage/supabase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_repository.g.dart';

@Riverpod(keepAlive: true)
SupabaseRepository supabaseRepository(SupabaseRepositoryRef ref) {
  return SupabaseRepository(Supabase.instance.client);
}

class SupabaseRepository {
  SupabaseRepository(this._client);

  final SupabaseClient _client;

  ///----------------------------------------
  /// Board
  ///----------------------------------------
  Future<String?> insertBoard(BoardModel board) async {
    try {
      final insertBoardJson = board.toJson();
      await _client.from('boards').insert(insertBoardJson);
      return board.boardId;
    } catch (e) {
      throw AppException.error('Board insert error', detail: '$e');
    }
  }

  Future<void> addImageObject(
      BoardModel board, ObjectModel object, XFile file) async {
    SupabaseStorage storage = SupabaseStorage(_client);

    try {
      /// storageに画像をアップロード
      final storagePath = await storage.uploadXFileImage(
          file, 'public_image', '${board.boardId}/${object.objectId}');
      if (storagePath == null) {
        throw AppException.warning('storage path is null');
      }

      String newThumbnailPath;

      /// thumbnail url が null の場合は、thumbnail url を設定する
      if (board.thumbnailUrl == null) {
        newThumbnailPath = storagePath;
      } else {
        newThumbnailPath = board.thumbnailUrl!;
      }

      final insertObject = object.copyWith(
        type: ObjectType.networkImage,
        imageUrl: storagePath,
      );
      final newBoard = board.copyWith(
          thumbnailUrl: newThumbnailPath,
          objects: [...board.objects, insertObject]);
      updateBoard(newBoard);
    } catch (e) {
      throw AppException.error('object add to board failed',
          detail: 'addImageObject() :$e');
    }
  }

  Future<void> addTextObject(
    BoardModel board,
    ObjectModel object,
  ) async {
    // final newBoard = board.copyWith(objects: [...board.objects, object]);
    updateBoard(board);
  }

  Future<void> updateBoard(BoardModel updatedBoard) async {
    final object = updatedBoard.toJson();
    try {
      await _client
          .from('boards')
          .update(object)
          .eq('board_id', updatedBoard.boardId)
          .single();
    } catch (e) {
      throw AppException.error('Board update error',
          detail: 'updateBoard() :$e');
    }
  }

  Future<void> deleteBoard(String boardId) async {
    try {
      /// db boardを削除する
      await _client.from('boards').delete().eq('board_id', boardId);
    } catch (e) {
      throw AppException.error('Board delete error',
          detail: 'deleteBoard() :$e');
    }
  }

  Stream<BoardModel?> boardStream(String boardId) {
    final StreamController<BoardModel?> controller =
        StreamController<BoardModel?>();

    _client
        .from('boards')
        .stream(primaryKey: ['board_id'])
        .eq('board_id', boardId)
        .listen((data) {
          if (data.isNotEmpty) {
            final board = BoardModel.fromJson(data[0]);
            controller.add(board);
          }
        })
        .onError((error) {
          controller.addError(error);
        });

    return controller.stream;
  }

  Future<BoardModel?> getBoardById(String id) async {
    try {
      final response = await _client.from('boards').select().eq('board_id', id);
      if (response.isEmpty) {
        throw AppException.notFound();
      }
      final board = BoardModel.fromJson(response[0]);
      return board;
    } catch (e) {
      throw AppException.warning('Boardを取得できませんでした',
          detail: 'getBoardById() : board id -> $id');
    }
  }

  ///----------------------------------------
  /// User
  ///----------------------------------------
  Future<UserModel?> fetchUserData(String id) async {
    try {
      final response =
          await _client.from('profiles').select().eq('user_id', id).single();
      final userData = UserModel.fromJson(response);
      return userData;
    } catch (e) {
      throw AppException.warning('fetch user data failed',
          detail: 'fetchUserData() : user id -> $id');
    }
  }

  Future<void> updateUserName(
    String userId,
    String newUserName,
  ) async {
    try {
      await _client
          .from('profiles')
          .update({'user_name': newUserName}).eq('user_id', userId);
    } catch (e) {
      throw AppException.error('User name update error',
          detail: 'updateUserName() :$e');
    }
  }

  Future<void> updateOwnedBoardIds(
      String userId, List<String> newOwnedBoardIds) async {
    try {
      await _client
          .from('profiles')
          .update({'owned_board_ids': newOwnedBoardIds}).eq('user_id', userId);
    } catch (e) {
      throw AppException.error('Owned board ids update error',
          detail: 'updateOwnedBoardIds() :$e');
    }
  }

  Future<void> updateLinkedBoardIds(
      String userId, List<String> newLinkedBoardIds) async {
    try {
      await _client.from('profiles').update(
          {'linked_board_ids': newLinkedBoardIds}).eq('user_id', userId);
    } catch (e) {
      throw AppException.error('Linked board ids update error',
          detail: 'updateLinkedBoardIds() :$e');
    }
  }

  Future<String?> updateAvatarImage(UserModel userData, XFile file) async {
    SupabaseStorage storage = SupabaseStorage(_client);

    final filePath =
        "${userData.userId}/${DateTime.now().millisecondsSinceEpoch}";

    try {
      /// storageに画像をアップロード
      final storagePath =
          await storage.uploadXFileImage(file, 'avatar_image', filePath);
      await _client
          .from('profiles')
          .update({'avatar_url': storagePath}).eq('user_id', userData.userId);
      return storagePath;
    } catch (e) {
      throw AppException.error('Avatar image update error',
          detail: 'updateAvatarImage() :$e');
    }
  }

  Future<String> fetchAvatarImageUrl(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('avatar_url')
          .eq('user_id', userId)
          .single();
      return response['avatar_url'];
    } catch (e) {
      throw AppException.warning('Avatar image url fetch error',
          detail: 'fetchAvatarImageUrl() :$e');
    }
  }
}
