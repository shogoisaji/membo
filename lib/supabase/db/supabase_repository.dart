import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/supabase/storage/supabase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_repository.g.dart';

@Riverpod(keepAlive: true)
SupabaseRepository supabaseRepository(SupabaseRepositoryRef ref) {
  return SupabaseRepository(Supabase.instance.client);
}

class SupabaseRepository {
  SupabaseRepository(this._client);

  final SupabaseClient _client;

  Future<String?> insertBoard(BoardModel board) async {
    try {
      final object = board.toJson();
      final response = await _client.from('boards').insert(object);
      if (response != null) {
        throw Exception('Insert error: ${response.error.message}');
      }
      print('success insert board');
      return null;
    } catch (err) {
      // return ErrorHandler.handleError(err);
      print('error insert board: $err');
    }
    return null;
  }

  Future<void> addImageObject(
      BoardModel board, ObjectModel object, XFile file) async {
    SupabaseStorage storage = SupabaseStorage(_client);
    final fileType =
        file.path.split('.').last == 'jpg' ? 'jpeg' : file.path.split('.').last;
    try {
      final publicPath = await storage.uploadXFileImage(
          file, '${board.boardId}/${object.objectId}.$fileType');
      final newObject = object.copyWith(
        type: ObjectType.networkImage,
        imageUrl: publicPath,
      );
      final newBoard = board.copyWith(objects: [...board.objects, newObject]);
      updateBoard(newBoard);
    } catch (err) {
      throw Exception('Error uploading image: $err');
    }
  }

  Future<void> addTextObject(
    BoardModel board,
    ObjectModel object,
  ) async {
    final newBoard = board.copyWith(objects: [...board.objects, object]);
    updateBoard(newBoard);
  }

  Future<String?> updateBoard(BoardModel updatedBoard) async {
    try {
      final object = updatedBoard.toJson();
      print('Updating object: $object');
      final response = await _client
          .from('boards')
          .update(object)
          .eq('boardId', updatedBoard.boardId)
          .single();

      print('Success update board : $response');
      return null;
    } catch (err) {
      print('Error updating board: $err');
      // return ErrorHandler.handleError(err);
    }
    return null;
  }

  Stream<BoardModel?> boardStream(String boardId) {
    final StreamController<BoardModel?> controller =
        StreamController<BoardModel?>();

    _client
        .from('boards')
        .stream(primaryKey: ['boardId'])
        .eq('boardId', boardId)
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
          await _client.from('boards').select().eq('boardId', id).single();
      final board = BoardModel.fromJson(response);
      return board;
    } catch (err) {
      // final errorString = ErrorHandler.handleError(err);
      print('error get board by id: $err');
      return null;
    }
  }
}
