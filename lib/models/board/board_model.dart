import 'package:membo/models/board/object/object_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_model.freezed.dart';
part 'board_model.g.dart';

@freezed
class BoardModel with _$BoardModel {
  const factory BoardModel({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'board_id') required String boardId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'board_name') @Default('-') String boardName,
    required String password,
    required List<ObjectModel> objects,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'owner_id') required String ownerId,
    required int width,
    required int height,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'bg_color') required String bgColor,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
}
