// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LinkedBoardModelImpl _$$LinkedBoardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LinkedBoardModelImpl(
      boardId: json['board_id'] as String,
      boardName: json['board_name'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LinkedBoardModelImplToJson(
        _$LinkedBoardModelImpl instance) =>
    <String, dynamic>{
      'board_id': instance.boardId,
      'board_name': instance.boardName,
      'thumbnail_url': instance.thumbnailUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
