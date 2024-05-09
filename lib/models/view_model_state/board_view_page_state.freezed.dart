// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_view_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BoardViewPageState {
  BoardModel? get boardModel =>
      throw _privateConstructorUsedError; // @Default(1.0) double viewScale,
// @Default(0.0) double viewTranslateX,
// @Default(0.0) double viewTranslateY,
  Matrix4? get transformationMatrix => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardViewPageStateCopyWith<BoardViewPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardViewPageStateCopyWith<$Res> {
  factory $BoardViewPageStateCopyWith(
          BoardViewPageState value, $Res Function(BoardViewPageState) then) =
      _$BoardViewPageStateCopyWithImpl<$Res, BoardViewPageState>;
  @useResult
  $Res call({BoardModel? boardModel, Matrix4? transformationMatrix});

  $BoardModelCopyWith<$Res>? get boardModel;
}

/// @nodoc
class _$BoardViewPageStateCopyWithImpl<$Res, $Val extends BoardViewPageState>
    implements $BoardViewPageStateCopyWith<$Res> {
  _$BoardViewPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardModel = freezed,
    Object? transformationMatrix = freezed,
  }) {
    return _then(_value.copyWith(
      boardModel: freezed == boardModel
          ? _value.boardModel
          : boardModel // ignore: cast_nullable_to_non_nullable
              as BoardModel?,
      transformationMatrix: freezed == transformationMatrix
          ? _value.transformationMatrix
          : transformationMatrix // ignore: cast_nullable_to_non_nullable
              as Matrix4?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardModelCopyWith<$Res>? get boardModel {
    if (_value.boardModel == null) {
      return null;
    }

    return $BoardModelCopyWith<$Res>(_value.boardModel!, (value) {
      return _then(_value.copyWith(boardModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EditPageStateImplCopyWith<$Res>
    implements $BoardViewPageStateCopyWith<$Res> {
  factory _$$EditPageStateImplCopyWith(
          _$EditPageStateImpl value, $Res Function(_$EditPageStateImpl) then) =
      __$$EditPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BoardModel? boardModel, Matrix4? transformationMatrix});

  @override
  $BoardModelCopyWith<$Res>? get boardModel;
}

/// @nodoc
class __$$EditPageStateImplCopyWithImpl<$Res>
    extends _$BoardViewPageStateCopyWithImpl<$Res, _$EditPageStateImpl>
    implements _$$EditPageStateImplCopyWith<$Res> {
  __$$EditPageStateImplCopyWithImpl(
      _$EditPageStateImpl _value, $Res Function(_$EditPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardModel = freezed,
    Object? transformationMatrix = freezed,
  }) {
    return _then(_$EditPageStateImpl(
      boardModel: freezed == boardModel
          ? _value.boardModel
          : boardModel // ignore: cast_nullable_to_non_nullable
              as BoardModel?,
      transformationMatrix: freezed == transformationMatrix
          ? _value.transformationMatrix
          : transformationMatrix // ignore: cast_nullable_to_non_nullable
              as Matrix4?,
    ));
  }
}

/// @nodoc

class _$EditPageStateImpl implements _EditPageState {
  _$EditPageStateImpl({this.boardModel, this.transformationMatrix});

  @override
  final BoardModel? boardModel;
// @Default(1.0) double viewScale,
// @Default(0.0) double viewTranslateX,
// @Default(0.0) double viewTranslateY,
  @override
  final Matrix4? transformationMatrix;

  @override
  String toString() {
    return 'BoardViewPageState(boardModel: $boardModel, transformationMatrix: $transformationMatrix)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditPageStateImpl &&
            (identical(other.boardModel, boardModel) ||
                other.boardModel == boardModel) &&
            (identical(other.transformationMatrix, transformationMatrix) ||
                other.transformationMatrix == transformationMatrix));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, boardModel, transformationMatrix);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditPageStateImplCopyWith<_$EditPageStateImpl> get copyWith =>
      __$$EditPageStateImplCopyWithImpl<_$EditPageStateImpl>(this, _$identity);
}

abstract class _EditPageState implements BoardViewPageState {
  factory _EditPageState(
      {final BoardModel? boardModel,
      final Matrix4? transformationMatrix}) = _$EditPageStateImpl;

  @override
  BoardModel? get boardModel;
  @override // @Default(1.0) double viewScale,
// @Default(0.0) double viewTranslateX,
// @Default(0.0) double viewTranslateY,
  Matrix4? get transformationMatrix;
  @override
  @JsonKey(ignore: true)
  _$$EditPageStateImplCopyWith<_$EditPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
