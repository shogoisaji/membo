import 'package:membo/models/view_model_state/board_settings_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/repositories/supabase/storage/supabase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_settings_view_model.g.dart';

@Riverpod(keepAlive: false)
class BoardSettingsViewModel extends _$BoardSettingsViewModel {
  @override
  BoardSettingsState build() => BoardSettingsState();

  Future<void> initializeLoad(String boardId) async {
    try {
      final board =
          await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

      if (board == null) {
        throw Exception('Board is null');
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
    } catch (e) {
      throw Exception('error initializeLoad: $e');
    }
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

  void switchPublic() async {
    if (state.tempBoard == null) {
      throw Exception('temp board is not set');
    }
    if (state.currentBoard == null) {
      throw Exception('current board is not set');
    }

    /// public を反転
    final newBoard = state.tempBoard!.copyWith(
      isPublic: !state.currentBoard!.isPublic,
    );
    state = state.copyWith(tempBoard: newBoard);
    try {
      await ref.read(supabaseRepositoryProvider).updateBoard(state.tempBoard!);
    } catch (e) {
      throw Exception('error update public: $e');
    }
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
      /// 画像の削除
      await ref.read(supabaseStorageProvider).deleteImageFolder(board);

      /// Board削除
      await ref.read(supabaseRepositoryProvider).deleteBoard(board.boardId);

      /// userのlinkedBoardsからBoardを削除
      final removedOwnedBoardIds = userData.ownedBoardIds
          .where((element) => element != board.boardId)
          .toList();
      await ref
          .read(supabaseRepositoryProvider)
          .updateOwnedBoardIds(user.id, removedOwnedBoardIds);
    } catch (e) {
      if (e.toString() ==
          "Exception: Error deleting board: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'") {
        return;
      }
      throw Exception('Board delete error : $e');
    }
  }
}
