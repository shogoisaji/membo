import 'package:membo/models/user/user_type.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'user_id') required String userId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'user_name') required String userName,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'owned_board_ids') required List<String> ownedBoardIds,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'link_board_ids') required List<String> linkBoardIds,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'user_type') required UserType userType,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
