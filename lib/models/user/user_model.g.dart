// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      linkedBoards: (json['linked_boards'] as List<dynamic>)
          .map((e) => LinkedBoard.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatarUrl: json['avatar_url'] as String?,
      userType: UserType.fromJson(json['user_type'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'linked_boards': instance.linkedBoards,
      'avatar_url': instance.avatarUrl,
      'user_type': instance.userType,
      'created_at': instance.createdAt.toIso8601String(),
    };
