// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_notices_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PublicNoticesModel _$PublicNoticesModelFromJson(Map<String, dynamic> json) {
  return _PublicNoticesModel.fromJson(json);
}

/// @nodoc
mixin _$PublicNoticesModel {
  int get id =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'notice_code')
  int get noticeCode =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'app_version')
  String get appVersion => throw _privateConstructorUsedError;
  String? get notice1 => throw _privateConstructorUsedError;
  String? get notice2 =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'app_url')
  String get appUrl =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PublicNoticesModelCopyWith<PublicNoticesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicNoticesModelCopyWith<$Res> {
  factory $PublicNoticesModelCopyWith(
          PublicNoticesModel value, $Res Function(PublicNoticesModel) then) =
      _$PublicNoticesModelCopyWithImpl<$Res, PublicNoticesModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'notice_code') int noticeCode,
      @JsonKey(name: 'app_version') String appVersion,
      String? notice1,
      String? notice2,
      @JsonKey(name: 'app_url') String appUrl,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$PublicNoticesModelCopyWithImpl<$Res, $Val extends PublicNoticesModel>
    implements $PublicNoticesModelCopyWith<$Res> {
  _$PublicNoticesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? noticeCode = null,
    Object? appVersion = null,
    Object? notice1 = freezed,
    Object? notice2 = freezed,
    Object? appUrl = null,
    Object? updatedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      noticeCode: null == noticeCode
          ? _value.noticeCode
          : noticeCode // ignore: cast_nullable_to_non_nullable
              as int,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      notice1: freezed == notice1
          ? _value.notice1
          : notice1 // ignore: cast_nullable_to_non_nullable
              as String?,
      notice2: freezed == notice2
          ? _value.notice2
          : notice2 // ignore: cast_nullable_to_non_nullable
              as String?,
      appUrl: null == appUrl
          ? _value.appUrl
          : appUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PublicNoticesModelImplCopyWith<$Res>
    implements $PublicNoticesModelCopyWith<$Res> {
  factory _$$PublicNoticesModelImplCopyWith(_$PublicNoticesModelImpl value,
          $Res Function(_$PublicNoticesModelImpl) then) =
      __$$PublicNoticesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'notice_code') int noticeCode,
      @JsonKey(name: 'app_version') String appVersion,
      String? notice1,
      String? notice2,
      @JsonKey(name: 'app_url') String appUrl,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$PublicNoticesModelImplCopyWithImpl<$Res>
    extends _$PublicNoticesModelCopyWithImpl<$Res, _$PublicNoticesModelImpl>
    implements _$$PublicNoticesModelImplCopyWith<$Res> {
  __$$PublicNoticesModelImplCopyWithImpl(_$PublicNoticesModelImpl _value,
      $Res Function(_$PublicNoticesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? noticeCode = null,
    Object? appVersion = null,
    Object? notice1 = freezed,
    Object? notice2 = freezed,
    Object? appUrl = null,
    Object? updatedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$PublicNoticesModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      noticeCode: null == noticeCode
          ? _value.noticeCode
          : noticeCode // ignore: cast_nullable_to_non_nullable
              as int,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      notice1: freezed == notice1
          ? _value.notice1
          : notice1 // ignore: cast_nullable_to_non_nullable
              as String?,
      notice2: freezed == notice2
          ? _value.notice2
          : notice2 // ignore: cast_nullable_to_non_nullable
              as String?,
      appUrl: null == appUrl
          ? _value.appUrl
          : appUrl // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicNoticesModelImpl implements _PublicNoticesModel {
  const _$PublicNoticesModelImpl(
      {required this.id,
      @JsonKey(name: 'notice_code') required this.noticeCode,
      @JsonKey(name: 'app_version') required this.appVersion,
      this.notice1,
      this.notice2,
      @JsonKey(name: 'app_url') required this.appUrl,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$PublicNoticesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicNoticesModelImplFromJson(json);

  @override
  final int id;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'notice_code')
  final int noticeCode;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'app_version')
  final String appVersion;
  @override
  final String? notice1;
  @override
  final String? notice2;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'app_url')
  final String appUrl;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'PublicNoticesModel(id: $id, noticeCode: $noticeCode, appVersion: $appVersion, notice1: $notice1, notice2: $notice2, appUrl: $appUrl, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicNoticesModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.noticeCode, noticeCode) ||
                other.noticeCode == noticeCode) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.notice1, notice1) || other.notice1 == notice1) &&
            (identical(other.notice2, notice2) || other.notice2 == notice2) &&
            (identical(other.appUrl, appUrl) || other.appUrl == appUrl) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, noticeCode, appVersion,
      notice1, notice2, appUrl, updatedAt, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicNoticesModelImplCopyWith<_$PublicNoticesModelImpl> get copyWith =>
      __$$PublicNoticesModelImplCopyWithImpl<_$PublicNoticesModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicNoticesModelImplToJson(
      this,
    );
  }
}

abstract class _PublicNoticesModel implements PublicNoticesModel {
  const factory _PublicNoticesModel(
          {required final int id,
          @JsonKey(name: 'notice_code') required final int noticeCode,
          @JsonKey(name: 'app_version') required final String appVersion,
          final String? notice1,
          final String? notice2,
          @JsonKey(name: 'app_url') required final String appUrl,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$PublicNoticesModelImpl;

  factory _PublicNoticesModel.fromJson(Map<String, dynamic> json) =
      _$PublicNoticesModelImpl.fromJson;

  @override
  int get id;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'notice_code')
  int get noticeCode;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'app_version')
  String get appVersion;
  @override
  String? get notice1;
  @override
  String? get notice2;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'app_url')
  String get appUrl;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PublicNoticesModelImplCopyWith<_$PublicNoticesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
