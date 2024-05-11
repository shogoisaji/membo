// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardModelImpl _$$BoardModelImplFromJson(Map<String, dynamic> json) =>
    _$BoardModelImpl(
      boardId: json['board_id'] as String,
      boardName: json['board_name'] as String? ?? '-',
      password: json['password'] as String,
      objects: (json['objects'] as List<dynamic>)
          .map((e) => ObjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ownerId: json['owner_id'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      bgColor: json['bg_color'] as String,
      isPublic: json['is_public'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$BoardModelImplToJson(_$BoardModelImpl instance) =>
    <String, dynamic>{
      'board_id': instance.boardId,
      'board_name': instance.boardName,
      'password': instance.password,
      'objects': instance.objects,
      'owner_id': instance.ownerId,
      'width': instance.width,
      'height': instance.height,
      'bg_color': instance.bgColor,
      'is_public': instance.isPublic,
      'created_at': instance.createdAt.toIso8601String(),
    };
