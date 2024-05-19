// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_notices_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicNoticesModelImpl _$$PublicNoticesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PublicNoticesModelImpl(
      id: json['id'] as int,
      isActive: json['is_active'] as bool,
      noticeCode: json['notice_code'] as int,
      notice1: json['notice1'] as String?,
      notice2: json['notice2'] as String?,
      notice3: json['notice3'] as String?,
      appUrl: json['app_url'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PublicNoticesModelImplToJson(
        _$PublicNoticesModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_active': instance.isActive,
      'notice_code': instance.noticeCode,
      'notice1': instance.notice1,
      'notice2': instance.notice2,
      'notice3': instance.notice3,
      'app_url': instance.appUrl,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
