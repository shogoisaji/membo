import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:membo/models/board/board_model.dart';

part 'connect_page_state.freezed.dart';

@freezed
class ConnectPageState with _$ConnectPageState {
  const factory ConnectPageState({
    BoardModel? board,
  }) = _ConnectPageState;
}
