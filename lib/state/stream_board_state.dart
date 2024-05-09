import 'package:membo/models/board/board_model.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_board_state.g.dart';

@Riverpod(keepAlive: true)
class StreamBoardId extends _$StreamBoardId {
  @override
  String build() => '';

  void setStreamBoardId(String boardId) {
    state = boardId;
  }

  void clearStreamBoardId() {
    state = '';
  }
}

@Riverpod(keepAlive: true)
Stream<BoardModel?> streamBoard(StreamBoardRef ref) {
  final boardId = ref.watch(streamBoardIdProvider);
  if (boardId == '') {
    return Stream.value(null);
  }
  return ref.watch(supabaseRepositoryProvider).boardStream(boardId);
}

@Riverpod(keepAlive: true)
BoardModel? streamBoardModel(StreamBoardModelRef ref) {
  final boardStream = ref.watch(streamBoardProvider);
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
