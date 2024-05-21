// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      ownedBoardIds: (json['owned_board_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      linkedBoards: (json['linked_boards'] as List<dynamic>?)
              ?.map((e) => LinkedBoardModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      avatarUrl: json['avatar_url'] as String?,
      membershipType: MembershipType.fromJson(
          json['membership_type'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'owned_board_ids': instance.ownedBoardIds,
      'linked_boards': instance.linkedBoards,
      'avatar_url': instance.avatarUrl,
      'membership_type': instance.membershipType,
      'created_at': instance.createdAt.toIso8601String(),
    };
