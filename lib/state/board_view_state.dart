import 'package:membo/models/board/board_model.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_view_state.g.dart';

@Riverpod(keepAlive: true)
class SelectedBoardId extends _$SelectedBoardId {
  @override
  String build() => '';

  void setSelectedBoardId(String boardId) {
    state = boardId;
  }

  void clearSelectedBoardId() {
    state = '';
  }
}

@Riverpod(keepAlive: true)
Stream<BoardModel?> boardStream(BoardStreamRef ref) {
  // final boardId = '0996ec38-d300-4dd4-9e8b-1a887954c275';
  final boardId = ref.read(selectedBoardIdProvider);
  if (boardId == '') {
    return Stream.value(null);
  }
  return ref.watch(supabaseRepositoryProvider).boardStream(boardId);
}

@Riverpod(keepAlive: true)
BoardModel? boardModelState(BoardModelStateRef ref) {
  final boardStream = ref.watch(boardStreamProvider);
  return boardStream.when(
    loading: () {
      return null;
    },
    error: (e, __) {
      return null;
    },
    data: (d) {
      return d;
    },
  );
}
