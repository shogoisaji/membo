// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserType _$UserTypeFromJson(Map<String, dynamic> json) => UserType(
      type: $enumDecode(_$UserTypesEnumMap, json['user_type']),
    );

Map<String, dynamic> _$UserTypeToJson(UserType instance) => <String, dynamic>{
      'user_type': _$UserTypesEnumMap[instance.type]!,
    };

const _$UserTypesEnumMap = {
  UserTypes.admin: 'admin',
  UserTypes.free: 'free',
  UserTypes.premium: 'premium',
};
