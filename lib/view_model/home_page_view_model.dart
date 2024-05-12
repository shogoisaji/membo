import 'package:membo/models/user/linked_board_model.dart';
import 'package:membo/models/view_model_state/home_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_page_view_model.g.dart';

@riverpod
class HomePageViewModel extends _$HomePageViewModel {
  @override
  HomePageState build() => const HomePageState();

  void initialize() async {
    final user = ref.read(userStateProvider);

    final userData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(user?.id ?? '')
        .catchError((e) {
      print('error: $e');
      return null;
    });

    if (userData == null) {
      print('userData is null');
      return;
    }

    final tempShowBoardModels = <ShowBoardModel>[];

    for (LinkedBoard linkedBoard in userData.linkedBoards) {
      try {
        final board = await ref
            .read(supabaseRepositoryProvider)
            .getBoardById(linkedBoard.boardId);
        if (board == null) {
          continue;
        }
        final showBoardModel = ShowBoardModel(
          boardType: linkedBoard.type,
          boardModel: board,
        );
        tempShowBoardModels.add(showBoardModel);
      } catch (e) {
        print('error: $e');
      }
    }
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
        isLoading: false,
        userModel: userData,
        showBoardModels: tempShowBoardModels);
  }
}
