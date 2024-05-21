import 'package:membo/models/board/linked_board_model.dart';
import 'package:membo/models/user/membership_type.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'owned_board_ids') @Default([]) List<String> ownedBoardIds,
    @JsonKey(name: 'linked_boards')
    @Default([])
    List<LinkedBoardModel> linkedBoards,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'membership_type') required MembershipType membershipType,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
