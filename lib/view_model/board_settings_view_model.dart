import 'package:membo/models/view_model_state/board_settings_state.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_settings_view_model.g.dart';

@Riverpod(keepAlive: true)
class BoardSettingsViewModel extends _$BoardSettingsViewModel {
  @override
  BoardSettingsState build() => BoardSettingsState();

  void changeOwner() {
    state = state.copyWith(isOwner: state.isOwner ? false : true);
  }

  void updateBoardName(String boardName) {
    state = state.copyWith(tempBoardName: boardName);
  }

  void updateWidth(double width) {
    final board = ref.read(boardModelStateProvider);
    final currentBoardSettings = board?.settings;
    if (currentBoardSettings == null) {
      throw Exception('board settings is not set');
    }
    if (state.tempBoardSettings == null) {
      final newBoardSettings = currentBoardSettings.copyWith(width: width);
      state = state.copyWith(tempBoardSettings: newBoardSettings);
    } else {
      state = state.copyWith(
          tempBoardSettings: state.tempBoardSettings!.copyWith(width: width));
    }
  }

  void updateHeight(double height) {
    final board = ref.read(boardModelStateProvider);
    final currentBoardSettings = board?.settings;
    if (currentBoardSettings == null) {
      throw Exception('board settings is not set');
    }
    if (state.tempBoardSettings == null) {
      final newBoardSettings = currentBoardSettings.copyWith(height: height);
      state = state.copyWith(tempBoardSettings: newBoardSettings);
    } else {
      state = state.copyWith(
          tempBoardSettings: state.tempBoardSettings!.copyWith(height: height));
    }
  }

  void updateColor(String color) {
    final board = ref.read(boardModelStateProvider);
    final currentBoardSettings = board?.settings;
    if (currentBoardSettings == null) {
      throw Exception('board settings is not set');
    }
    if (state.tempBoardSettings == null) {
      final newBoardSettings = currentBoardSettings.copyWith(bgColor: color);
      state = state.copyWith(tempBoardSettings: newBoardSettings);
    } else {
      state = state.copyWith(
          tempBoardSettings: state.tempBoardSettings!.copyWith(bgColor: color));
    }
  }

  void saveTempBoardSettings() {
    final board = ref.watch(boardModelStateProvider);
    if (board == null) {
      throw Exception('Board is not loaded');
    }
    if (state.tempBoardSettings == null && state.tempBoardName == null) {
      throw Exception('Temp board settings is not set');
    }
    try {
      final newBoard = board.copyWith(
          settings: state.tempBoardSettings ?? board.settings,
          boardName: state.tempBoardName ?? board.boardName);
      ref.read(supabaseRepositoryProvider).updateBoard(newBoard);
      clear();
    } catch (e) {
      throw Exception('error saving temp board settings: $e');
    }
  }

  void clear() {
    state = BoardSettingsState();
  }

  bool isUpdatable() {
    return (state.tempBoardSettings != null || state.tempBoardName != null);
  }
}
