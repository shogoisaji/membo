import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/models/user/linked_board_model.dart';
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
    } catch (err) {
      throw Exception('Error inserting board: $err');
    }
  }

  Future<void> addImageObject(
      BoardModel board, ObjectModel object, XFile file) async {
    SupabaseStorage storage = SupabaseStorage(_client);

    /// 拡張子の確認
    final fileModifier = switch (file.path.split('.').last) {
      'jpg' || 'jpeg' => 'jpeg',
      'png' => 'png',
      _ =>
        throw Exception('Unsupported file type: ${file.path.split('.').last}'),
    };

    try {
      /// storageに画像をアップロード
      final storagePath = await storage.uploadXFileImage(
          file, '${board.boardId}/${object.objectId}.$fileModifier');
      final insertObject = object.copyWith(
        type: ObjectType.networkImage,
        imageUrl: storagePath,
      );
      final newBoard =
          board.copyWith(objects: [...board.objects, insertObject]);
      updateBoard(newBoard);
    } catch (err) {
      throw Exception('Error uploading image: $err');
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
    } catch (err) {
      /// error -> type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'
      print('Error updating board: $err');
    }
  }

  Future<void> deleteBoard(String boardId) async {
    try {
      /// storage imageを削除する
      final board = await getBoardById(boardId);
      final storage = SupabaseStorage(_client);
      for (final object in board!.objects) {
        if (object.type == ObjectType.networkImage) {
          await storage.deleteImage(object.imageUrl!);
        }
      }

      /// db boardを削除する
      await _client.from('boards').delete().eq('board_id', boardId).single();
    } catch (err) {
      throw Exception('Error deleting board: $err');
    }
  }

  /// maybe no use
  // Future<void> updateBoardSettings(
  //     String boardId, BoardSettingsModel updatedBoardSettings) async {
  //   final newSettings = updatedBoardSettings.toJson();
  //   try {
  //     await _client
  //         .from('boards')
  //         .update({'settings': newSettings})
  //         .eq('board_id', boardId)
  //         .single();
  //   } catch (err) {
  //     /// error -> type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'
  //     print('Error updating board: $err');
  //   }
  // }

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
      final response =
          await _client.from('boards').select().eq('board_id', id).single();
      final board = BoardModel.fromJson(response);
      return board;
    } catch (err) {
      throw Exception('Error getting board: $err');
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
    } catch (err) {
      throw Exception('Error getting user data: $err');
    }
  }

  Future<void> updateUserName(
    String userId,
    String newUserName,
  ) async {
    try {
      await _client
          .from('profiles')
          .update({'user_name': newUserName})
          .eq('user_id', userId)
          .single();
    } on TypeError catch (_) {
      // ???
    } catch (err) {
      throw Exception('Error updating user name: $err');
    }
  }

  Future<void> deleteAccount(String userId) async {
    await _client.from('profiles').delete().eq('user_id', userId).single();
  }

  Future<void> addOwnedBoardId(String userId, List<String> currentOwnedBoardIds,
      String addBoardId) async {
    final newOwnedBoardIds = [...currentOwnedBoardIds, addBoardId];
    try {
      await _client
          .from('profiles')
          .update({'owned_board_ids': newOwnedBoardIds})
          .eq('user_id', userId)
          .single();
    } catch (err) {
      rethrow;
    }
  }

  // Future<void> addLinkBoardId(String userId, List<String> currentLinkBoardIds,
  //     String addBoardId) async {
  //   final newLinkBoardIds = [...currentLinkBoardIds, addBoardId];
  //   try {
  //     await _client
  //         .from('profiles')
  //         .update({'link_board_ids': newLinkBoardIds})
  //         .eq('user_id', userId)
  //         .single();
  //   } catch (err) {
  //     rethrow;
  //   }
  // }

  Future<void> updateLinkedBoards(
      String userId, List<LinkedBoard> newLinkedBoards) async {
    try {
      await _client
          .from('profiles')
          .update({'linked_boards': newLinkedBoards})
          .eq('user_id', userId)
          .single();
    } catch (err) {
      rethrow;
    }
  }
}
