import 'package:membo/models/board/board_settings_model.dart';
import 'package:membo/models/board/object/object_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_model.freezed.dart';
part 'board_model.g.dart';

@freezed
class BoardModel with _$BoardModel {
  const factory BoardModel({
    @JsonKey(name: 'board_id') required String boardId,
    @JsonKey(name: 'board_name') @Default('-') String boardName,
    @JsonKey(name: 'password') required String password,
    @JsonKey(name: 'objects') required List<ObjectModel> objects,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'settings')
    @Default(BoardSettingsModel())
    BoardSettingsModel settings,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
}
