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
      isPublished: json['is_published'] as bool? ?? false,
      settings: json['settings'] == null
          ? const BoardSettingsModel()
          : BoardSettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$BoardModelImplToJson(_$BoardModelImpl instance) =>
    <String, dynamic>{
      'board_id': instance.boardId,
      'board_name': instance.boardName,
      'password': instance.password,
      'objects': instance.objects,
      'owner_id': instance.ownerId,
      'is_published': instance.isPublished,
      'settings': instance.settings,
      'created_at': instance.createdAt.toIso8601String(),
    };
