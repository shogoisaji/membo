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
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final ownerData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(user.id)
        .catchError((e) {
      print('error: $e');
      return null;
    });
    state = state.copyWith(
        currentBoard: board,
        ownerName: ownerData?.userName ?? '-',
        tempBoardName: board.boardName,
        tempBoardSettings: board.settings,
        isOwner: user.id == board.ownerId);
  }

  bool isChangeCheck() {
    if (state.currentBoard == null) {
      return false;
    }
    return state.currentBoard!.boardName != state.tempBoardName ||
        state.currentBoard!.settings != state.tempBoardSettings;
  }

  /// テスト用
  void changeOwner() {
    state = state.copyWith(isOwner: state.isOwner ? false : true);
  }

  void updateBoardName(String boardName) {
    state = state.copyWith(tempBoardName: boardName);
  }

  void updateWidth(double width) {
    if (state.tempBoardSettings == null) {
      throw Exception('tempBoardSettings is not set');
    }
    final newBoardSettings = state.tempBoardSettings!.copyWith(width: width);
    state = state.copyWith(tempBoardSettings: newBoardSettings);
  }

  void updateHeight(double height) {
    if (state.tempBoardSettings == null) {
      throw Exception('tempBoardSettings is not set');
    }
    final newBoardSettings = state.tempBoardSettings!.copyWith(height: height);
    state = state.copyWith(tempBoardSettings: newBoardSettings);
  }

  void updateColor(String color) {
    if (state.currentBoard == null) {
      throw Exception('current board is not set');
    }
    final newBoardSettings =
        state.currentBoard!.settings.copyWith(bgColor: color);
    state = state.copyWith(tempBoardSettings: newBoardSettings);
  }

  Future<void> updatePublicState(bool isPublic) async {
    if (state.currentBoard == null) {
      throw Exception('current board is not set');
    }
    final newBoard = state.currentBoard!.copyWith(isPublic: isPublic);
    try {
      await ref.read(supabaseRepositoryProvider).updateBoard(newBoard);
    } catch (e) {
      throw Exception('error saving temp board settings: $e');
    }
  }

  Future<void> saveTempBoardSettings() async {
    if (state.currentBoard == null) {
      throw Exception('current board is not set');
    }
    if (state.tempBoardSettings == null && state.tempBoardName == null) {
      throw Exception('Temp board settings is not set');
    }

    final newBoard = state.currentBoard!.copyWith(
        password: state.tempPassword ?? state.currentBoard!.password,
        settings: state.tempBoardSettings ?? state.currentBoard!.settings,
        boardName: state.tempBoardName ?? state.currentBoard!.boardName);
    try {
      await ref.read(supabaseRepositoryProvider).updateBoard(newBoard);
    } catch (e) {
      throw Exception('error saving temp board settings: $e');
    }
    clear();
  }

  void clear() {
    state = BoardSettingsState();
  }

  bool isUpdatable() {
    return (state.tempBoardSettings != null || state.tempBoardName != null);
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
    if (state.currentBoard == null) {
      throw Exception('current board is not set');
    }
    final board = state.currentBoard!;
    try {
      await ref.read(supabaseRepositoryProvider).deleteBoard(board.boardId);
      await ref.read(supabaseRepositoryProvider).removeBoardIdFromUser(
          user.id, userData.ownedBoardIds, board.boardId);
    } catch (e) {
      throw Exception('error deleting board: $e');
    }
  }
}
