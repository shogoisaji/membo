import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/view_model_state/edit_list_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_list_page_view_model.g.dart';

@Riverpod(keepAlive: true)
class EditListPageViewModel extends _$EditListPageViewModel {
  @override
  EditListPageState build() => EditListPageState();

  void initialize() async {
    final user = ref.read(userStateProvider);

    if (user == null) return;

    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);

    if (userData == null) return;

    final newBoards = <BoardModel>[];

    for (String id in userData.ownedBoardsId) {
      try {
        final board =
            await ref.read(supabaseRepositoryProvider).getBoardById(id);
        if (board == null) continue;

        newBoards.add(board);
      } catch (e) {
        print('error: $e');
      }
    }
    state = state.copyWith(boardModels: newBoards);
  }
}
