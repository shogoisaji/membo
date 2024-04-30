// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      ownedBoardsId: (json['ownedBoardsId'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      avatarUrl: json['avatarUrl'] as String?,
      userType: UserType.fromJson(json['userType'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'ownedBoardsId': instance.ownedBoardsId,
      'avatarUrl': instance.avatarUrl,
      'userType': instance.userType,
      'createdAt': instance.createdAt.toIso8601String(),
    };
