import 'package:membo/models/view_model_state/board_settings_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_settings_view_model.g.dart';

@Riverpod(keepAlive: false)
class BoardSettingsViewModel extends _$BoardSettingsViewModel {
  @override
  BoardSettingsState build() => BoardSettingsState();

  void initializeLoad(String boardId) async {
    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);
    if (board == null) {
      throw Exception('Board is not loaded');
    }
    final currentUser = ref.read(userStateProvider);
    if (currentUser == null) {
      throw Exception('User is not loaded');
    }
    final ownerData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(board.ownerId)
        .catchError((e) {
      throw Exception('Owner data is not loaded');
    });
    state = state.copyWith(
        currentBoard: board,
        tempBoard: board,
        ownerName: ownerData?.userName ?? '-',
        isOwner: currentUser.id == board.ownerId);
  }

  ///
  /// 変更があればtrueを返す
  ///
  bool isChangeCheck() {
    if (state.currentBoard == null) {
      return false;
    }
    if (state.tempBoard == null) {
      return false;
    }
    return state.currentBoard! != state.tempBoard;
  }

  /// テスト用
  void changeOwner() {
    state = state.copyWith(isOwner: state.isOwner ? false : true);
  }

  void updateBoardSettings(
      {String? boardName,
      int? width,
      int? height,
      String? color,
      String? password,
      bool? isPublic}) {
    if (state.tempBoard == null) {
      throw Exception('temp board is not set');
    }
    final newBoard = state.tempBoard!.copyWith(
      boardName: boardName ?? state.tempBoard!.boardName,
      width: width ?? state.tempBoard!.width,
      height: height ?? state.tempBoard!.height,
      bgColor: color ?? state.tempBoard!.bgColor,
      password: password ?? state.tempBoard!.password,
      isPublic: isPublic ?? state.tempBoard!.isPublic,
    );
    state = state.copyWith(tempBoard: newBoard);
  }

  Future<void> saveTempBoardSettings() async {
    if (state.currentBoard == null) {
      throw Exception('current board is not set');
    }
    if (state.tempBoard == null) {
      throw Exception('Temp board settings is not set');
    }

    try {
      await ref.read(supabaseRepositoryProvider).updateBoard(state.tempBoard!);
    } catch (e) {
      throw Exception('error saving temp board settings: $e');
    }
  }

  Future<void> deleteBoard() async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User data is not loaded');
    }

    /// Boardの削除はOwnerのみ
    if (!state.isOwner) {
      throw Exception('You are not owner');
    }

    if (state.currentBoard == null) {
      throw Exception('current board is not set');
    }
    final board = state.currentBoard!;

    try {
      /// Board削除
      await ref.read(supabaseRepositoryProvider).deleteBoard(board.boardId);

      final removedLinkedBoards = userData.linkedBoards
          .where((element) => element.boardId != board.boardId)
          .toList();
      userData;

      /// userのlinkedBoardsからBoardを削除
      await ref
          .read(supabaseRepositoryProvider)
          .updateLinkedBoards(user.id, removedLinkedBoards);
    } catch (e) {
      throw Exception('error deleting board: $e');
    }
  }
}
