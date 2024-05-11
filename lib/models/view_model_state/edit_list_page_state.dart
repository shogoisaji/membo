import 'package:membo/models/board/board_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_list_page_state.freezed.dart';

@freezed
class EditListPageState with _$EditListPageState {
  factory EditListPageState({
    @Default(true) bool isLoading,
    @Default([]) List<BoardModel> boardModels,
  }) = _EditListPageState;
}
