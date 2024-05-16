// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EditRequestModelImpl _$$EditRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EditRequestModelImpl(
      editRequestId: json['edit_request_id'] as String,
      boardId: json['board_id'] as String,
      ownerId: json['owner_id'] as String,
      requestorId: json['requestor_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$EditRequestModelImplToJson(
        _$EditRequestModelImpl instance) =>
    <String, dynamic>{
      'edit_request_id': instance.editRequestId,
      'board_id': instance.boardId,
      'owner_id': instance.ownerId,
      'requestor_id': instance.requestorId,
      'created_at': instance.createdAt.toIso8601String(),
    };
