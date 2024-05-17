// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'linked_board_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LinkedBoardModel _$LinkedBoardModelFromJson(Map<String, dynamic> json) {
  return _LinkedBoardModel.fromJson(json);
}

/// @nodoc
mixin _$LinkedBoardModel {
// ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'board_name')
  String get boardName =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LinkedBoardModelCopyWith<LinkedBoardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkedBoardModelCopyWith<$Res> {
  factory $LinkedBoardModelCopyWith(
          LinkedBoardModel value, $Res Function(LinkedBoardModel) then) =
      _$LinkedBoardModelCopyWithImpl<$Res, LinkedBoardModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'board_id') String boardId,
      @JsonKey(name: 'board_name') String boardName,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$LinkedBoardModelCopyWithImpl<$Res, $Val extends LinkedBoardModel>
    implements $LinkedBoardModelCopyWith<$Res> {
  _$LinkedBoardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? boardName = null,
    Object? thumbnailUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      boardName: null == boardName
          ? _value.boardName
          : boardName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LinkedBoardModelImplCopyWith<$Res>
    implements $LinkedBoardModelCopyWith<$Res> {
  factory _$$LinkedBoardModelImplCopyWith(_$LinkedBoardModelImpl value,
          $Res Function(_$LinkedBoardModelImpl) then) =
      __$$LinkedBoardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'board_id') String boardId,
      @JsonKey(name: 'board_name') String boardName,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$LinkedBoardModelImplCopyWithImpl<$Res>
    extends _$LinkedBoardModelCopyWithImpl<$Res, _$LinkedBoardModelImpl>
    implements _$$LinkedBoardModelImplCopyWith<$Res> {
  __$$LinkedBoardModelImplCopyWithImpl(_$LinkedBoardModelImpl _value,
      $Res Function(_$LinkedBoardModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? boardName = null,
    Object? thumbnailUrl = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$LinkedBoardModelImpl(
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      boardName: null == boardName
          ? _value.boardName
          : boardName // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LinkedBoardModelImpl implements _LinkedBoardModel {
  const _$LinkedBoardModelImpl(
      {@JsonKey(name: 'board_id') required this.boardId,
      @JsonKey(name: 'board_name') required this.boardName,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$LinkedBoardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LinkedBoardModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'board_id')
  final String boardId;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'board_name')
  final String boardName;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'LinkedBoardModel(boardId: $boardId, boardName: $boardName, thumbnailUrl: $thumbnailUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkedBoardModelImpl &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.boardName, boardName) ||
                other.boardName == boardName) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, boardId, boardName, thumbnailUrl, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkedBoardModelImplCopyWith<_$LinkedBoardModelImpl> get copyWith =>
      __$$LinkedBoardModelImplCopyWithImpl<_$LinkedBoardModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LinkedBoardModelImplToJson(
      this,
    );
  }
}

abstract class _LinkedBoardModel implements LinkedBoardModel {
  const factory _LinkedBoardModel(
          {@JsonKey(name: 'board_id') required final String boardId,
          @JsonKey(name: 'board_name') required final String boardName,
          @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$LinkedBoardModelImpl;

  factory _LinkedBoardModel.fromJson(Map<String, dynamic> json) =
      _$LinkedBoardModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'board_name')
  String get boardName;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$LinkedBoardModelImplCopyWith<_$LinkedBoardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
