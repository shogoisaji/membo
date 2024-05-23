// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_notices_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicNoticesModelImpl _$$PublicNoticesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PublicNoticesModelImpl(
      id: json['id'] as int,
      noticeCode: json['notice_code'] as int,
      appVersion: json['app_version'] as String,
      notice1: json['notice1'] as String?,
      notice2: json['notice2'] as String?,
      appUrl: json['app_url'] as String,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PublicNoticesModelImplToJson(
        _$PublicNoticesModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notice_code': instance.noticeCode,
      'app_version': instance.appVersion,
      'notice1': instance.notice1,
      'notice2': instance.notice2,
      'app_url': instance.appUrl,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
