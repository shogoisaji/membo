import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/user/user_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    UserModel? userModel,
    @Default([]) List<BoardModel> boardModel,
  }) = _HomePageState;
}
