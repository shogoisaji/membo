// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      ownedBoardIds: (json['owned_board_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      linkBoardIds: (json['link_board_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      avatarUrl: json['avatar_url'] as String?,
      userType: UserType.fromJson(json['user_type'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'owned_board_ids': instance.ownedBoardIds,
      'link_board_ids': instance.linkBoardIds,
      'avatar_url': instance.avatarUrl,
      'user_type': instance.userType,
      'created_at': instance.createdAt.toIso8601String(),
    };
