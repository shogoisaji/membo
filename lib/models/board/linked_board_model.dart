import 'package:freezed_annotation/freezed_annotation.dart';

part 'linked_board_model.freezed.dart';
part 'linked_board_model.g.dart';

@freezed
class LinkedBoardModel with _$LinkedBoardModel {
  const factory LinkedBoardModel({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'board_id') required String boardId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'board_name') required String boardName,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _LinkedBoardModel;

  factory LinkedBoardModel.fromJson(Map<String, dynamic> json) =>
      _$LinkedBoardModelFromJson(json);
}
