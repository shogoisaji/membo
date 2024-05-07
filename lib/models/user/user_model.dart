import 'package:membo/models/user/user_type.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String userId,
    required String userName,
    required List<String> ownedBoardsId,
    String? avatarUrl,
    required UserType userType,
    required DateTime createdAt,
  }) = _UserModel;

  // factory UserModel.fromJson(Map<String, dynamic> json) =>
  //     _$UserModelFromJson(json);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      ownedBoardsId: List<String>.from(json['owned_boards_id']),
      avatarUrl: json['avatar_url'] as String?,
      userType: UserType.fromJson({'type': json['user_type']}),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
