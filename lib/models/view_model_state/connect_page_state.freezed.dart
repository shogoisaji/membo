// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connect_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConnectPageState {
  BoardModel? get board => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConnectPageStateCopyWith<ConnectPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectPageStateCopyWith<$Res> {
  factory $ConnectPageStateCopyWith(
          ConnectPageState value, $Res Function(ConnectPageState) then) =
      _$ConnectPageStateCopyWithImpl<$Res, ConnectPageState>;
  @useResult
  $Res call({BoardModel? board});

  $BoardModelCopyWith<$Res>? get board;
}

/// @nodoc
class _$ConnectPageStateCopyWithImpl<$Res, $Val extends ConnectPageState>
    implements $ConnectPageStateCopyWith<$Res> {
  _$ConnectPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
  }) {
    return _then(_value.copyWith(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as BoardModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardModelCopyWith<$Res>? get board {
    if (_value.board == null) {
      return null;
    }

    return $BoardModelCopyWith<$Res>(_value.board!, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConnectPageStateImplCopyWith<$Res>
    implements $ConnectPageStateCopyWith<$Res> {
  factory _$$ConnectPageStateImplCopyWith(_$ConnectPageStateImpl value,
          $Res Function(_$ConnectPageStateImpl) then) =
      __$$ConnectPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BoardModel? board});

  @override
  $BoardModelCopyWith<$Res>? get board;
}

/// @nodoc
class __$$ConnectPageStateImplCopyWithImpl<$Res>
    extends _$ConnectPageStateCopyWithImpl<$Res, _$ConnectPageStateImpl>
    implements _$$ConnectPageStateImplCopyWith<$Res> {
  __$$ConnectPageStateImplCopyWithImpl(_$ConnectPageStateImpl _value,
      $Res Function(_$ConnectPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
  }) {
    return _then(_$ConnectPageStateImpl(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as BoardModel?,
    ));
  }
}

/// @nodoc

class _$ConnectPageStateImpl implements _ConnectPageState {
  const _$ConnectPageStateImpl({this.board});

  @override
  final BoardModel? board;

  @override
  String toString() {
    return 'ConnectPageState(board: $board)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectPageStateImpl &&
            (identical(other.board, board) || other.board == board));
  }

  @override
  int get hashCode => Object.hash(runtimeType, board);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectPageStateImplCopyWith<_$ConnectPageStateImpl> get copyWith =>
      __$$ConnectPageStateImplCopyWithImpl<_$ConnectPageStateImpl>(
          this, _$identity);
}

abstract class _ConnectPageState implements ConnectPageState {
  const factory _ConnectPageState({final BoardModel? board}) =
      _$ConnectPageStateImpl;

  @override
  BoardModel? get board;
  @override
  @JsonKey(ignore: true)
  _$$ConnectPageStateImplCopyWith<_$ConnectPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
