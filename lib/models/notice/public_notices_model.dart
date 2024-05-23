import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_notices_model.freezed.dart';
part 'public_notices_model.g.dart';

/// notice_code
/// 100 -> none
/// 200 -> maintenance

@freezed
class PublicNoticesModel with _$PublicNoticesModel {
  const factory PublicNoticesModel({
    required int id,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'notice_code') required int noticeCode,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'app_version') required String appVersion,
    String? notice1,
    String? notice2,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'app_url') required String appUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PublicNoticesModel;

  factory PublicNoticesModel.fromJson(Map<String, dynamic> json) =>
      _$PublicNoticesModelFromJson(json);
}
