import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/view_model_state/home_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_page_view_model.g.dart';

@Riverpod(keepAlive: true)
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
    final linkedBoards = <BoardModel>[];
    final ownedBoards = <BoardModel>[];

    for (String id in userData.linkBoardIds) {
      try {
        final board =
            await ref.read(supabaseRepositoryProvider).getBoardById(id);
        if (board == null) {
          continue;
        }
        linkedBoards.add(board);
      } catch (e) {
        print('error: $e');
      }
    }

    for (String id in userData.ownedBoardIds) {
      try {
        final board =
            await ref.read(supabaseRepositoryProvider).getBoardById(id);
        if (board == null) {
          continue;
        }
        ownedBoards.add(board);
      } catch (e) {
        print('error: $e');
      }
    }
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
        isLoading: false,
        userModel: userData,
        linkedBoardModel: linkedBoards,
        ownedBoardModel: ownedBoards);
  }
}
