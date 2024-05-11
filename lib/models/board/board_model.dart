import 'package:membo/models/board/board_settings_model.dart';
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
    // ignore: invalid_annotation_target
    @JsonKey(name: 'password') required String password,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'objects') required List<ObjectModel> objects,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'owner_id') required String ownerId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'settings')
    @Default(BoardSettingsModel())
    BoardSettingsModel settings,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
}
