// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  int get viewBoardCount => throw _privateConstructorUsedError;
  int get createBoardCount => throw _privateConstructorUsedError;
  int get ownBoardCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountPageStateCopyWith<AccountPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountPageStateCopyWith<$Res> {
  factory $AccountPageStateCopyWith(
          AccountPageState value, $Res Function(AccountPageState) then) =
      _$AccountPageStateCopyWithImpl<$Res, AccountPageState>;
  @useResult
  $Res call(
      {bool isLoading,
      UserModel? user,
      int viewBoardCount,
      int createBoardCount,
      int ownBoardCount});

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$AccountPageStateCopyWithImpl<$Res, $Val extends AccountPageState>
    implements $AccountPageStateCopyWith<$Res> {
  _$AccountPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? user = freezed,
    Object? viewBoardCount = null,
    Object? createBoardCount = null,
    Object? ownBoardCount = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      viewBoardCount: null == viewBoardCount
          ? _value.viewBoardCount
          : viewBoardCount // ignore: cast_nullable_to_non_nullable
              as int,
      createBoardCount: null == createBoardCount
          ? _value.createBoardCount
          : createBoardCount // ignore: cast_nullable_to_non_nullable
              as int,
      ownBoardCount: null == ownBoardCount
          ? _value.ownBoardCount
          : ownBoardCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountPageStateImplCopyWith<$Res>
    implements $AccountPageStateCopyWith<$Res> {
  factory _$$AccountPageStateImplCopyWith(_$AccountPageStateImpl value,
          $Res Function(_$AccountPageStateImpl) then) =
      __$$AccountPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      UserModel? user,
      int viewBoardCount,
      int createBoardCount,
      int ownBoardCount});

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AccountPageStateImplCopyWithImpl<$Res>
    extends _$AccountPageStateCopyWithImpl<$Res, _$AccountPageStateImpl>
    implements _$$AccountPageStateImplCopyWith<$Res> {
  __$$AccountPageStateImplCopyWithImpl(_$AccountPageStateImpl _value,
      $Res Function(_$AccountPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? user = freezed,
    Object? viewBoardCount = null,
    Object? createBoardCount = null,
    Object? ownBoardCount = null,
  }) {
    return _then(_$AccountPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      viewBoardCount: null == viewBoardCount
          ? _value.viewBoardCount
          : viewBoardCount // ignore: cast_nullable_to_non_nullable
              as int,
      createBoardCount: null == createBoardCount
          ? _value.createBoardCount
          : createBoardCount // ignore: cast_nullable_to_non_nullable
              as int,
      ownBoardCount: null == ownBoardCount
          ? _value.ownBoardCount
          : ownBoardCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AccountPageStateImpl implements _AccountPageState {
  const _$AccountPageStateImpl(
      {this.isLoading = true,
      this.user,
      this.viewBoardCount = 0,
      this.createBoardCount = 0,
      this.ownBoardCount = 0});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final UserModel? user;
  @override
  @JsonKey()
  final int viewBoardCount;
  @override
  @JsonKey()
  final int createBoardCount;
  @override
  @JsonKey()
  final int ownBoardCount;

  @override
  String toString() {
    return 'AccountPageState(isLoading: $isLoading, user: $user, viewBoardCount: $viewBoardCount, createBoardCount: $createBoardCount, ownBoardCount: $ownBoardCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.viewBoardCount, viewBoardCount) ||
                other.viewBoardCount == viewBoardCount) &&
            (identical(other.createBoardCount, createBoardCount) ||
                other.createBoardCount == createBoardCount) &&
            (identical(other.ownBoardCount, ownBoardCount) ||
                other.ownBoardCount == ownBoardCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, user, viewBoardCount,
      createBoardCount, ownBoardCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountPageStateImplCopyWith<_$AccountPageStateImpl> get copyWith =>
      __$$AccountPageStateImplCopyWithImpl<_$AccountPageStateImpl>(
          this, _$identity);
}

abstract class _AccountPageState implements AccountPageState {
  const factory _AccountPageState(
      {final bool isLoading,
      final UserModel? user,
      final int viewBoardCount,
      final int createBoardCount,
      final int ownBoardCount}) = _$AccountPageStateImpl;

  @override
  bool get isLoading;
  @override
  UserModel? get user;
  @override
  int get viewBoardCount;
  @override
  int get createBoardCount;
  @override
  int get ownBoardCount;
  @override
  @JsonKey(ignore: true)
  _$$AccountPageStateImplCopyWith<_$AccountPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
