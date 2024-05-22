import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_permission.dart';
import 'package:membo/models/user/user_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    @Default(true) bool isLoading,
    UserModel? userModel,
    @Default([]) List<CardBoardModel> allCardBoardList,
    @Default([]) List<CardBoardModel> ownedCardBoardList,
    @Default([]) List<CardBoardModel> linkedCardBoardList,
    @Default([]) List<String> carouselImageUrls,
  }) = _HomePageState;
}

class CardBoardModel {
  final BoardModel board;
  final BoardPermission permission;

  const CardBoardModel({required this.board, required this.permission});
}
