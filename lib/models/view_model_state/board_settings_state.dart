import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:membo/models/board/board_settings_model.dart';

part 'board_settings_state.freezed.dart';

@freezed
class BoardSettingsState with _$BoardSettingsState {
  factory BoardSettingsState({
    @Default(false) bool isOwner,
    BoardSettingsModel? tempBoardSettings,
  }) = _BoardSettingsState;
}
