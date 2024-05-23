// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipType _$MembershipTypeFromJson(Map<String, dynamic> json) =>
    MembershipType(
      type: $enumDecode(_$MembershipTypesEnumMap, json['membership_type']),
    );

Map<String, dynamic> _$MembershipTypeToJson(MembershipType instance) =>
    <String, dynamic>{
      'membership_type': _$MembershipTypesEnumMap[instance.type]!,
    };

const _$MembershipTypesEnumMap = {
  MembershipTypes.admin: 'admin',
  MembershipTypes.free: 'free',
  MembershipTypes.premium: 'premium',
};
