// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardModelImpl _$$BoardModelImplFromJson(Map<String, dynamic> json) =>
    _$BoardModelImpl(
      boardId: json['boardId'] as String,
      boardName: json['boardName'] as String? ?? '-',
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
    );

Map<String, dynamic> _$$BoardModelImplToJson(_$BoardModelImpl instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'boardName': instance.boardName,
      'password': instance.password,
      'objects': instance.objects,
      'ownerId': instance.ownerId,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
    };
