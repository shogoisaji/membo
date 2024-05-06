import 'package:membo/models/board/board_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_view_page_state.freezed.dart';

@freezed
class BoardViewPageState with _$BoardViewPageState {
  factory BoardViewPageState({
    BoardModel? boardModel,
    @Default(1.0) double viewScale,
    @Default(0.0) double viewTranslateX,
    @Default(0.0) double viewTranslateY,
  }) = _EditPageState;
}
