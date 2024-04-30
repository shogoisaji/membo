import 'package:membo/models/board/board_settings_model.dart';
import 'package:membo/models/board/object/object_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_model.freezed.dart';
part 'board_model.g.dart';

@freezed
class BoardModel with _$BoardModel {
  const factory BoardModel({
    required String boardId,
    required String password,
    required List<ObjectModel> objects,
    required String ownerId,
    @Default(BoardSettingsModel()) BoardSettingsModel settings,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BoardModel;

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);
}
