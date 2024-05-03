import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_settings_model.freezed.dart';
part 'board_settings_model.g.dart';

const double defaultHeight = 2000;
const double defaultWidth = 2000;

@freezed
class BoardSettingsModel with _$BoardSettingsModel {
  const factory BoardSettingsModel({
    @Default(defaultHeight) double height,
    @Default(defaultWidth) double width,
    @Default('0xffffffff') String bgColor,
    @Default(false) bool isPublished,
  }) = _BoardSettingsModel;

  factory BoardSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$BoardSettingsModelFromJson(json);
}
