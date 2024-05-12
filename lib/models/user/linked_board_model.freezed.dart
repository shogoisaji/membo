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

LinkedBoard _$LinkedBoardFromJson(Map<String, dynamic> json) {
  return _LinkedBoard.fromJson(json);
}

/// @nodoc
mixin _$LinkedBoard {
// ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId => throw _privateConstructorUsedError;
  LinkedBoardType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LinkedBoardCopyWith<LinkedBoard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkedBoardCopyWith<$Res> {
  factory $LinkedBoardCopyWith(
          LinkedBoard value, $Res Function(LinkedBoard) then) =
      _$LinkedBoardCopyWithImpl<$Res, LinkedBoard>;
  @useResult
  $Res call({@JsonKey(name: 'board_id') String boardId, LinkedBoardType type});
}

/// @nodoc
class _$LinkedBoardCopyWithImpl<$Res, $Val extends LinkedBoard>
    implements $LinkedBoardCopyWith<$Res> {
  _$LinkedBoardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LinkedBoardType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LinkedBoardImplCopyWith<$Res>
    implements $LinkedBoardCopyWith<$Res> {
  factory _$$LinkedBoardImplCopyWith(
          _$LinkedBoardImpl value, $Res Function(_$LinkedBoardImpl) then) =
      __$$LinkedBoardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'board_id') String boardId, LinkedBoardType type});
}

/// @nodoc
class __$$LinkedBoardImplCopyWithImpl<$Res>
    extends _$LinkedBoardCopyWithImpl<$Res, _$LinkedBoardImpl>
    implements _$$LinkedBoardImplCopyWith<$Res> {
  __$$LinkedBoardImplCopyWithImpl(
      _$LinkedBoardImpl _value, $Res Function(_$LinkedBoardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? type = null,
  }) {
    return _then(_$LinkedBoardImpl(
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LinkedBoardType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LinkedBoardImpl implements _LinkedBoard {
  _$LinkedBoardImpl(
      {@JsonKey(name: 'board_id') required this.boardId, required this.type});

  factory _$LinkedBoardImpl.fromJson(Map<String, dynamic> json) =>
      _$$LinkedBoardImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'board_id')
  final String boardId;
  @override
  final LinkedBoardType type;

  @override
  String toString() {
    return 'LinkedBoard(boardId: $boardId, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkedBoardImpl &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, boardId, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkedBoardImplCopyWith<_$LinkedBoardImpl> get copyWith =>
      __$$LinkedBoardImplCopyWithImpl<_$LinkedBoardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LinkedBoardImplToJson(
      this,
    );
  }
}

abstract class _LinkedBoard implements LinkedBoard {
  factory _LinkedBoard(
      {@JsonKey(name: 'board_id') required final String boardId,
      required final LinkedBoardType type}) = _$LinkedBoardImpl;

  factory _LinkedBoard.fromJson(Map<String, dynamic> json) =
      _$LinkedBoardImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId;
  @override
  LinkedBoardType get type;
  @override
  @JsonKey(ignore: true)
  _$$LinkedBoardImplCopyWith<_$LinkedBoardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
