// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ObjectModelImpl _$$ObjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ObjectModelImpl(
      objectId: json['objectId'] as String,
      type: $enumDecode(_$ObjectTypeEnumMap, json['type']),
      positionX: (json['positionX'] as num).toDouble(),
      positionY: (json['positionY'] as num).toDouble(),
      angle: (json['angle'] as num).toDouble(),
      scale: (json['scale'] as num).toDouble(),
      bgColor: json['bgColor'] as String,
      imageUrl: json['imageUrl'] as String?,
      text: json['text'] as String?,
      stampId: json['stampId'] as int?,
      creatorId: json['creatorId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ObjectModelImplToJson(_$ObjectModelImpl instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'type': _$ObjectTypeEnumMap[instance.type]!,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'angle': instance.angle,
      'scale': instance.scale,
      'bgColor': instance.bgColor,
      'imageUrl': instance.imageUrl,
      'text': instance.text,
      'stampId': instance.stampId,
      'creatorId': instance.creatorId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ObjectTypeEnumMap = {
  ObjectType.networkImage: 'networkImage',
  ObjectType.localImage: 'localImage',
  ObjectType.text: 'text',
  ObjectType.stamp: 'stamp',
};
