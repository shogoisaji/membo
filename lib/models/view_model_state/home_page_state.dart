import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/user/linked_board_model.dart';
import 'package:membo/models/user/user_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    @Default(true) bool isLoading,
    UserModel? userModel,
    @Default([]) List<ShowBoardModel> showBoardModels,
  }) = _HomePageState;
}

class ShowBoardModel {
  final LinkedBoardType boardType;
  final BoardModel boardModel;

  ShowBoardModel({
    required this.boardType,
    required this.boardModel,
  });
}
