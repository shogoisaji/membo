import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/view_model_state/board_view_page_state.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_view_page_view_model.g.dart';

@riverpod
class BoardViewPageViewModel extends _$BoardViewPageViewModel {
  @override
  BoardViewPageState build() => BoardViewPageState();

  Matrix4 calcInitialTransform(BoardModel board, double w, double h) {
    final scaleW = w / board.settings.width;
    final scaleH = h / board.settings.height;
    final scale = scaleW < scaleH ? scaleW : scaleH;

    /// 横長の画面の場合
    if (scaleW > scaleH) {
      final addX = (w - board.settings.width * scale) / 2 / scale;
      final translateX = (board.settings.width - w) / 2 * 1 + addX;
      final translateY = (board.settings.height - h) / 2 * 1;
      final matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, translateY, 0);
      return matrix;

      /// 縦長の画面の場合
    } else {
      final addY = (h - board.settings.height * scale) / 2 / scale;
      final translateX = (board.settings.width - w) / 2 * 1;
      final translateY = (board.settings.height - h) / 2 * 1 + addY;
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
}
