// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardModelImpl _$$BoardModelImplFromJson(Map<String, dynamic> json) =>
    _$BoardModelImpl(
      boardId: json['boardId'] as String,
      password: json['password'] as String,
      objects: (json['objects'] as List<dynamic>)
          .map((e) => ObjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ownerId: json['ownerId'] as String,
      settings: json['settings'] == null
          ? const BoardSettingsModel()
          : BoardSettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BoardModelImplToJson(_$BoardModelImpl instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'password': instance.password,
      'objects': instance.objects,
      'ownerId': instance.ownerId,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
