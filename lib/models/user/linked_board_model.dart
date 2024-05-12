import 'package:freezed_annotation/freezed_annotation.dart';

part 'linked_board_model.freezed.dart';
part 'linked_board_model.g.dart';

enum LinkedBoardType { view, create, own }

@freezed
class LinkedBoard with _$LinkedBoard {
  factory LinkedBoard({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'board_id') required String boardId,
    required LinkedBoardType type,
  }) = _LinkedBoard;

  factory LinkedBoard.fromJson(Map<String, dynamic> json) =>
      _$LinkedBoardFromJson(json);
}
