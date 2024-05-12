import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/view_model_state/edit_list_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'edit_list_page_view_model.g.dart';

@riverpod
class EditListPageViewModel extends _$EditListPageViewModel {
  @override
  EditListPageState build() => EditListPageState();

  void initialize() async {
    final user = ref.read(userStateProvider);

    if (user == null) return;

    final userData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(user.id)
        .catchError((e) {
      print('error: $e');
      return null;
    });

    if (userData == null) return;

    final tempBoards = <BoardModel>[];

    for (String id in userData.ownedBoardIds) {
      try {
        final board =
            await ref.read(supabaseRepositoryProvider).getBoardById(id);
        if (board == null) continue;

        tempBoards.add(board);
      } catch (e) {
        print('error: $e');
      }
    }
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isLoading: false, boardModels: tempBoards);
  }

  Future<String?> createNewBoard() async {
    /// Get the current user
    final User? user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not signed in');
    }
    final newBoard = BoardModel(
      boardId: const Uuid().v4(),
      password: '',
      objects: [],
      ownerId: user.id,
      width: 1000,
      height: 1000,
      bgColor: '0xffffffff',
      createdAt: DateTime.now(),
    );
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('UserData is not signed in');
    }
    try {
      final insertedBoardId =
          await ref.read(supabaseRepositoryProvider).insertBoard(newBoard);

      /// user ownedBoardIdsに新しいボードを追加
      try {
        await ref
            .read(supabaseRepositoryProvider)
            .addOwnedBoardId(user.id, userData.ownedBoardIds, insertedBoardId!);
      } catch (e) {
        print('error: $e');
      }
      return insertedBoardId;
    } catch (e) {
      throw Exception('Error inserting board: $e');
    }
  }
}
