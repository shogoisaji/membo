// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardModelImpl _$$BoardModelImplFromJson(Map<String, dynamic> json) =>
    _$BoardModelImpl(
      boardId: json['board_id'] as String,
      boardName: json['board_name'] as String? ?? '-',
      password: json['password'] as String? ?? '',
      objects: (json['objects'] as List<dynamic>?)
              ?.map((e) => ObjectModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ownerId: json['owner_id'] as String,
      editableUserIds: (json['editable_user_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      editRequestUserIds: (json['edit_request_user_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      width: json['width'] as int? ?? 1000,
      height: json['height'] as int? ?? 1000,
      bgColor: json['bg_color'] as String? ?? '0xffffffff',
      isPublic: json['is_public'] as bool? ?? false,
      thumbnailUrl: json['thumbnail_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$BoardModelImplToJson(_$BoardModelImpl instance) =>
    <String, dynamic>{
      'board_id': instance.boardId,
      'board_name': instance.boardName,
      'password': instance.password,
      'objects': instance.objects,
      'owner_id': instance.ownerId,
      'editable_user_ids': instance.editableUserIds,
      'edit_request_user_ids': instance.editRequestUserIds,
      'width': instance.width,
      'height': instance.height,
      'bg_color': instance.bgColor,
      'is_public': instance.isPublic,
      'thumbnail_url': instance.thumbnailUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
