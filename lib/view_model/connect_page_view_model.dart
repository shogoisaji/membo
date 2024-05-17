import 'package:membo/models/view_model_state/connect_page_state.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connect_page_view_model.g.dart';

@riverpod
class ConnectPageViewModel extends _$ConnectPageViewModel {
  @override
  ConnectPageState build() => const ConnectPageState();

  Future<void> checkBoardExist(String uuid) async {
    final board = await ref.read(supabaseRepositoryProvider).getBoardById(uuid);
    state = state.copyWith(board: board);
  }

  void clearBoard() {
    state = state.copyWith(board: null);
  }
}
