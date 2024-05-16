import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_request_model.freezed.dart';
part 'edit_request_model.g.dart';

@freezed
class EditRequestModel with _$EditRequestModel {
  const factory EditRequestModel({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'edit_request_id') required String editRequestId,

    // ignore: invalid_annotation_target
    @JsonKey(name: 'board_id') required String boardId,

    // ignore: invalid_annotation_target
    @JsonKey(name: 'owner_id') required String ownerId,

    // ignore: invalid_annotation_target
    @JsonKey(name: 'requestor_id') required String requestorId,

    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _EditRequestModel;

  factory EditRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EditRequestModelFromJson(json);
}
