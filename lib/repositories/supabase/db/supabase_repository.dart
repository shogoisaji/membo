import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/models/notice/public_notices_model.dart';
import 'package:membo/models/request/edit_request_model.dart';
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
  Future<String> insertBoard(BoardModel board) async {
    try {
      final insertBoardJson = board.toJson();
      await _client.from('boards').insert(insertBoardJson);
      return board.boardId;
    } on PostgrestException catch (e) {
      switch (e.code) {
        case '42501':
          throw AppException.error("Permission denied");
        default:
          throw AppException.error('PostgrestException : ${e.code}',
              detail: '$e');
      }
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
      final e = await _client
          .from('boards')
          .update(object)
          .eq('board_id', updatedBoard.boardId);
      print(e);
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

  Future<BoardModel> getBoardById(String id) async {
    try {
      final response = await _client.from('boards').select().eq('board_id', id);
      if (response.isEmpty) {
        throw AppException.notFound();
      }
      final board = BoardModel.fromJson(response[0]);
      return board;
    } catch (e) {
      throw AppException.error('Boardを取得できませんでした',
          detail: 'getBoardById() : board id -> $id');
    }
  }

  Future<Map<String, dynamic>> getBoardNameAndThumbnail(String id) async {
    try {
      final response = await _client
          .from('boards')
          .select('board_name, thumbnail_url')
          .eq('board_id', id);
      if (response.isEmpty) {
        throw AppException.notFound();
      }
      return response[0];
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException.warning('Boardを取得できませんでした',
          detail: 'getBoardNameAndThumbnail() : board id -> $id');
    }
  }

  Future<List<String>> getEditableUserIds(String boardId) async {
    try {
      final response = await _client
          .from('boards')
          .select('editable_user_ids')
          .eq('board_id', boardId)
          .single();
      List<dynamic> dynamicList = response['editable_user_ids'];
      List<String> stringList =
          dynamicList.map((item) => item.toString()).toList();
      return stringList;
    } catch (e) {
      throw AppException.warning('Editable user ids fetch error',
          detail: 'getEditableUserIds() :$e');
    }
  }

  Future<void> updateEditableUserIds(
      String boardId, List<String> newEditableUserIds) async {
    try {
      await _client.from('boards').update(
          {'editable_user_ids': newEditableUserIds}).eq('board_id', boardId);
    } catch (e) {
      throw AppException.error('editable user ids update error',
          detail: 'updateEditableUserIds() :$e');
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
      throw AppException.error('ユーザーデータの取得に失敗しました',
          detail: 'fetchUserData() : user id -> $id');
    }
  }

  /// return -> {"user_name": name, "avatar_url": url}
  Future<Map<String, dynamic>> fetchUserNameAndAvatar(String id) async {
    try {
      final response = await _client
          .from('profiles')
          .select('user_name, avatar_url')
          .eq('user_id', id)
          .single();
      return response;
    } catch (e) {
      throw AppException.warning('ユーザーデータの取得に失敗しました',
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

  // Future<void> updateLinkedBoardIds(
  //     String userId, List<String> newLinkedBoardIds) async {
  //   try {
  //     await _client.from('profiles').update(
  //         {'linked_board_ids': newLinkedBoardIds}).eq('user_id', userId);
  //   } catch (e) {
  //     throw AppException.error('Linked board ids update error',
  //         detail: 'updateLinkedBoardIds() :$e');
  //   }
  // }

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

  ///----------------------------------------
  /// edit request
  ///----------------------------------------

  Future<void> insertEditRequest(EditRequestModel requestModel) async {
    try {
      await _client.from('edit_requests').insert(requestModel.toJson());
    } catch (e) {
      throw AppException.error('Edit request insert error',
          detail: 'insertEditRequest() :$e');
    }
  }

  Future<List<EditRequestModel>> fetchEditRequestsByBoardId(
      String boardId) async {
    try {
      final response =
          await _client.from('edit_requests').select().eq('board_id', boardId);
      return response
          .map<EditRequestModel>((json) => EditRequestModel.fromJson(json))
          .toList();
    } catch (e) {
      throw AppException.warning('Edit request fetch error',
          detail: 'fetchEditRequestByBoardId() :$e');
    }
  }

  Future<List<EditRequestModel>> fetchEditRequestsByOwnerId(
      String ownerId) async {
    try {
      final response =
          await _client.from('edit_requests').select().eq('owner_id', ownerId);
      return response
          .map<EditRequestModel>((json) => EditRequestModel.fromJson(json))
          .toList();
    } catch (e) {
      throw AppException.warning('Edit request fetch error',
          detail: 'fetchEditRequestByOwnerId() :$e');
    }
  }

  Future<EditRequestModel?> fetchEditRequest(
      String requestorId, String boardId) async {
    try {
      final response = await _client
          .from('edit_requests')
          .select()
          .eq('requestor_id', requestorId)
          .eq('board_id', boardId)
          .limit(1)
          .maybeSingle();
      if (response == null) {
        return null;
      }
      return EditRequestModel.fromJson(response);
    } catch (e) {
      throw AppException.warning('Edit request fetch error',
          detail: 'fetchEditRequestForRequestor() :$e');
    }
  }

  Future<void> deleteEditRequest(String editRequestId) async {
    try {
      await _client
          .from('edit_requests')
          .delete()
          .eq('edit_request_id', editRequestId);
    } catch (e) {
      throw AppException.error('Edit request delete error',
          detail: 'deleteEditRequest() :$e');
    }
  }

  ///----------------------------------------
  /// Public Notice
  ///----------------------------------------
  Future<PublicNoticesModel> fetchPublicNotices() async {
    try {
      final response =
          await _client.from('public_notices').select().eq('id', 1).single();
      return PublicNoticesModel.fromJson(response);
    } catch (e) {
      throw AppException.warning('Public notices fetch error',
          detail: 'fetchPublicNotices() :$e');
    }
  }
}
