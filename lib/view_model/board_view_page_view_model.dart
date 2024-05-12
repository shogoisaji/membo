import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/user/linked_board_model.dart';
import 'package:membo/models/view_model_state/board_view_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_view_page_view_model.g.dart';

@riverpod
class BoardViewPageViewModel extends _$BoardViewPageViewModel {
  @override
  BoardViewPageState build() => BoardViewPageState();

  Matrix4 calcInitialTransform(BoardModel board, double w, double h) {
    final scaleW = w / board.width;
    final scaleH = h / board.height;
    final scale = scaleW < scaleH ? scaleW : scaleH;

    /// 横長の画面の場合
    if (scaleW > scaleH) {
      final addX = (w - board.width * scale) / 2 / scale;
      final translateX = (board.width - w) / 2 * 1 + addX;
      final translateY = (board.height - h) / 2 * 1;
      final matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, translateY, 0);
      return matrix;

      /// 縦長の画面の場合
    } else {
      final addY = (h - board.height * scale) / 2 / scale;
      final translateX = (board.width - w) / 2 * 1;
      final translateY = (board.height - h) / 2 * 1 + addY;
      final matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, translateY, 0);
      return matrix;
    }
  }

  Future<void> initialize(String boardId, double w, double h) async {
    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

    if (board == null) return;

    /// streamをセット
    ref.read(streamBoardIdProvider.notifier).setStreamBoardId(boardId);

    final matrix = calcInitialTransform(board, w, h);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = state.copyWith(
        transformationMatrix: matrix,
      );
    });
  }

  Future<void> addLinkedBoard(LinkedBoard linkedBoard) async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(user.id)
        .catchError((e) {
      print('error: $e');
      return null;
    });

    /// すでにlinkedBoardが存在するか確認
    if (userData!.linkedBoards.contains(linkedBoard)) {
      throw Exception('Exist linked board');
    }
    final newLinkedBoards = [...userData.linkedBoards, linkedBoard];
    ref
        .read(supabaseRepositoryProvider)
        .updateLinkedBoards(userData.userId, newLinkedBoards);
  }
}
