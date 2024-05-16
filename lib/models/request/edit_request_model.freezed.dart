// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EditRequestModel _$EditRequestModelFromJson(Map<String, dynamic> json) {
  return _EditRequestModel.fromJson(json);
}

/// @nodoc
mixin _$EditRequestModel {
// ignore: invalid_annotation_target
  @JsonKey(name: 'edit_request_id')
  String get editRequestId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'owner_id')
  String get ownerId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'requestor_id')
  String get requestorId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EditRequestModelCopyWith<EditRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditRequestModelCopyWith<$Res> {
  factory $EditRequestModelCopyWith(
          EditRequestModel value, $Res Function(EditRequestModel) then) =
      _$EditRequestModelCopyWithImpl<$Res, EditRequestModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_request_id') String editRequestId,
      @JsonKey(name: 'board_id') String boardId,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'requestor_id') String requestorId,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$EditRequestModelCopyWithImpl<$Res, $Val extends EditRequestModel>
    implements $EditRequestModelCopyWith<$Res> {
  _$EditRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editRequestId = null,
    Object? boardId = null,
    Object? ownerId = null,
    Object? requestorId = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      editRequestId: null == editRequestId
          ? _value.editRequestId
          : editRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      requestorId: null == requestorId
          ? _value.requestorId
          : requestorId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditRequestModelImplCopyWith<$Res>
    implements $EditRequestModelCopyWith<$Res> {
  factory _$$EditRequestModelImplCopyWith(_$EditRequestModelImpl value,
          $Res Function(_$EditRequestModelImpl) then) =
      __$$EditRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'edit_request_id') String editRequestId,
      @JsonKey(name: 'board_id') String boardId,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'requestor_id') String requestorId,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$EditRequestModelImplCopyWithImpl<$Res>
    extends _$EditRequestModelCopyWithImpl<$Res, _$EditRequestModelImpl>
    implements _$$EditRequestModelImplCopyWith<$Res> {
  __$$EditRequestModelImplCopyWithImpl(_$EditRequestModelImpl _value,
      $Res Function(_$EditRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editRequestId = null,
    Object? boardId = null,
    Object? ownerId = null,
    Object? requestorId = null,
    Object? createdAt = null,
  }) {
    return _then(_$EditRequestModelImpl(
      editRequestId: null == editRequestId
          ? _value.editRequestId
          : editRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      requestorId: null == requestorId
          ? _value.requestorId
          : requestorId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EditRequestModelImpl implements _EditRequestModel {
  const _$EditRequestModelImpl(
      {@JsonKey(name: 'edit_request_id') required this.editRequestId,
      @JsonKey(name: 'board_id') required this.boardId,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'requestor_id') required this.requestorId,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$EditRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditRequestModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'edit_request_id')
  final String editRequestId;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'board_id')
  final String boardId;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'requestor_id')
  final String requestorId;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'EditRequestModel(editRequestId: $editRequestId, boardId: $boardId, ownerId: $ownerId, requestorId: $requestorId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditRequestModelImpl &&
            (identical(other.editRequestId, editRequestId) ||
                other.editRequestId == editRequestId) &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.requestorId, requestorId) ||
                other.requestorId == requestorId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, editRequestId, boardId, ownerId, requestorId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditRequestModelImplCopyWith<_$EditRequestModelImpl> get copyWith =>
      __$$EditRequestModelImplCopyWithImpl<_$EditRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditRequestModelImplToJson(
      this,
    );
  }
}

abstract class _EditRequestModel implements EditRequestModel {
  const factory _EditRequestModel(
      {@JsonKey(name: 'edit_request_id') required final String editRequestId,
      @JsonKey(name: 'board_id') required final String boardId,
      @JsonKey(name: 'owner_id') required final String ownerId,
      @JsonKey(name: 'requestor_id') required final String requestorId,
      @JsonKey(name: 'created_at')
      required final DateTime createdAt}) = _$EditRequestModelImpl;

  factory _EditRequestModel.fromJson(Map<String, dynamic> json) =
      _$EditRequestModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'edit_request_id')
  String get editRequestId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'requestor_id')
  String get requestorId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$EditRequestModelImplCopyWith<_$EditRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
