import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_notices_model.freezed.dart';
part 'public_notices_model.g.dart';

@freezed
class PublicNoticesModel with _$PublicNoticesModel {
  const factory PublicNoticesModel({
    required int id,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active') required bool isActive,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'notice_code') required int noticeCode,
    String? notice1,
    String? notice2,
    String? notice3,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'app_url') String? appUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PublicNoticesModel;

  factory PublicNoticesModel.fromJson(Map<String, dynamic> json) =>
      _$PublicNoticesModelFromJson(json);
}
