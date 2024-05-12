// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LinkedBoardImpl _$$LinkedBoardImplFromJson(Map<String, dynamic> json) =>
    _$LinkedBoardImpl(
      boardId: json['board_id'] as String,
      type: $enumDecode(_$LinkedBoardTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$LinkedBoardImplToJson(_$LinkedBoardImpl instance) =>
    <String, dynamic>{
      'board_id': instance.boardId,
      'type': _$LinkedBoardTypeEnumMap[instance.type]!,
    };

const _$LinkedBoardTypeEnumMap = {
  LinkedBoardType.view: 'view',
  LinkedBoardType.create: 'create',
  LinkedBoardType.own: 'own',
};
