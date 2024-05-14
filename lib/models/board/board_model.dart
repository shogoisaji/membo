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
    @Default('') String password,
    @Default([]) List<ObjectModel> objects,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'owner_id') required String ownerId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'editable_user_ids')
    @Default([])
    List<String> editableUserIds,
    @Default(1000) int width,
    @Default(1000) int height,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'bg_color') @Default('0xffffffff') String bgColor,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
}
