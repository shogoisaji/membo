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
  Matrix4? get transformationMatrix => throw _privateConstructorUsedError;
  bool get isLinked => throw _privateConstructorUsedError;

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
  $Res call({Matrix4? transformationMatrix, bool isLinked});
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
    Object? transformationMatrix = freezed,
    Object? isLinked = null,
  }) {
    return _then(_value.copyWith(
      transformationMatrix: freezed == transformationMatrix
          ? _value.transformationMatrix
          : transformationMatrix // ignore: cast_nullable_to_non_nullable
              as Matrix4?,
      isLinked: null == isLinked
          ? _value.isLinked
          : isLinked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
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
  $Res call({Matrix4? transformationMatrix, bool isLinked});
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
    Object? transformationMatrix = freezed,
    Object? isLinked = null,
  }) {
    return _then(_$EditPageStateImpl(
      transformationMatrix: freezed == transformationMatrix
          ? _value.transformationMatrix
          : transformationMatrix // ignore: cast_nullable_to_non_nullable
              as Matrix4?,
      isLinked: null == isLinked
          ? _value.isLinked
          : isLinked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$EditPageStateImpl implements _EditPageState {
  _$EditPageStateImpl({this.transformationMatrix, this.isLinked = true});

  @override
  final Matrix4? transformationMatrix;
  @override
  @JsonKey()
  final bool isLinked;

  @override
  String toString() {
    return 'BoardViewPageState(transformationMatrix: $transformationMatrix, isLinked: $isLinked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditPageStateImpl &&
            (identical(other.transformationMatrix, transformationMatrix) ||
                other.transformationMatrix == transformationMatrix) &&
            (identical(other.isLinked, isLinked) ||
                other.isLinked == isLinked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, transformationMatrix, isLinked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditPageStateImplCopyWith<_$EditPageStateImpl> get copyWith =>
      __$$EditPageStateImplCopyWithImpl<_$EditPageStateImpl>(this, _$identity);
}

abstract class _EditPageState implements BoardViewPageState {
  factory _EditPageState(
      {final Matrix4? transformationMatrix,
      final bool isLinked}) = _$EditPageStateImpl;

  @override
  Matrix4? get transformationMatrix;
  @override
  bool get isLinked;
  @override
  @JsonKey(ignore: true)
  _$$EditPageStateImplCopyWith<_$EditPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
