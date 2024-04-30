import 'package:membo/models/user/user_type.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
