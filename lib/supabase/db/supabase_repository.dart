import 'dart:async';

import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
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
      print('object: $object');
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

  Future<String?> updateBoard(String boardId, BoardModel updatedBoard) async {
    try {
      final object = updatedBoard.toJson();
      print('Updating object: $object');
      final response = await _client
          .from('boards')
          .update(object)
          .eq('boardId', boardId)
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
            print('fetch stream board---: $board');
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
      print('fetch success board: $board');
      return board;
    } catch (err) {
      // final errorString = ErrorHandler.handleError(err);
      print('error get board by id: $err');
      return null;
    }
  }
}
