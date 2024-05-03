// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardSettingsModelImpl _$$BoardSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BoardSettingsModelImpl(
      height: (json['height'] as num?)?.toDouble() ?? defaultHeight,
      width: (json['width'] as num?)?.toDouble() ?? defaultWidth,
      bgColor: json['bgColor'] as String? ?? '0xffffffff',
      isPublished: json['isPublished'] as bool? ?? false,
    );

Map<String, dynamic> _$$BoardSettingsModelImplToJson(
        _$BoardSettingsModelImpl instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'bgColor': instance.bgColor,
      'isPublished': instance.isPublished,
    };
