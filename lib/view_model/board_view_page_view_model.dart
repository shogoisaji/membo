import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/view_model_state/board_view_page_state.dart';
import 'package:membo/state/board_view_state.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_view_page_view_model.g.dart';

@Riverpod(keepAlive: true)
class BoardViewPageViewModel extends _$BoardViewPageViewModel {
  @override
  BoardViewPageState build() => BoardViewPageState();

  void setBoardModel(BoardModel board) {
    state = state.copyWith(boardModel: board);
  }

  Map<String, double> calcInitialTransform(
      BoardModel board, double w, double h) {
    final scaleW = w / board.settings.width;
    final scaleH = h / board.settings.height;
    final scale = scaleW < scaleH ? scaleW : scaleH;

    /// 横長の画面の場合
    if (scaleW > scaleH) {
      final addX = (w - board.settings.width * scale) / 2;
      final translateX = (board.settings.width - w) / 2 * scale + addX;
      final translateY = (board.settings.height - h) / 2 * scale;
      return {
        'scale': scale,
        'translateX': translateX,
        'translateY': translateY,
      };

      /// 縦長の画面の場合
    } else {
      final addY = (h - board.settings.height * scale) / 2;
      final translateX = (board.settings.width - w) / 2 * scale;
      final translateY = (board.settings.height - h) / 2 * scale + addY;
      return {
        'scale': scale,
        'translateX': translateX,
        'translateY': translateY,
      };
    }
  }

  Future<void> initializeLoad(double w, double h) async {
    final id = ref.read(selectedBoardIdProvider);
    final board = await ref.read(supabaseRepositoryProvider).getBoardById(id);
    if (board == null) {
      throw Exception('Board not found');
    }
    final transformMap = calcInitialTransform(board, w, h);
    state = state.copyWith(
      boardModel: board,
      viewScale: transformMap['scale'] as double,
      viewTranslateX: transformMap['translateX'] as double,
      viewTranslateY: transformMap['translateY'] as double,
    );
  }

  void updateViewScale(double scale) {
    state = state.copyWith(viewScale: scale);
  }
}
