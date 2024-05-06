import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_settings_model.dart';
import 'package:membo/models/view_model_state/board_settings_state.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:membo/view_model/edit_page_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_settings_view_model.g.dart';

@Riverpod(keepAlive: true)
class BoardSettingsViewModel extends _$BoardSettingsViewModel {
  @override
  BoardSettingsState build() => BoardSettingsState();

  // void setTempBoardSettings(BoardSettingsModel boardSettings) {
  //   state = state.copyWith(tempBoardSettings: boardSettings);
  // }

  void changeOwner() {
    state = state.copyWith(isOwner: state.isOwner ? false : true);
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
    if (state.tempBoardSettings == null) {
      throw Exception('Temp board settings is not set');
    }
    final newBoard = board.copyWith(settings: state.tempBoardSettings!);
    ref.read(supabaseRepositoryProvider).updateBoard(newBoard);
    clear();
  }

  void clear() {
    state = BoardSettingsState();
  }
}
