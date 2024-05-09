// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BoardSettingsState {
  bool get isOwner => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  BoardModel? get currentBoard => throw _privateConstructorUsedError;
  String? get tempPassword => throw _privateConstructorUsedError;
  BoardSettingsModel? get tempBoardSettings =>
      throw _privateConstructorUsedError;
  String? get tempBoardName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardSettingsStateCopyWith<BoardSettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardSettingsStateCopyWith<$Res> {
  factory $BoardSettingsStateCopyWith(
          BoardSettingsState value, $Res Function(BoardSettingsState) then) =
      _$BoardSettingsStateCopyWithImpl<$Res, BoardSettingsState>;
  @useResult
  $Res call(
      {bool isOwner,
      String ownerName,
      BoardModel? currentBoard,
      String? tempPassword,
      BoardSettingsModel? tempBoardSettings,
      String? tempBoardName});

  $BoardModelCopyWith<$Res>? get currentBoard;
  $BoardSettingsModelCopyWith<$Res>? get tempBoardSettings;
}

/// @nodoc
class _$BoardSettingsStateCopyWithImpl<$Res, $Val extends BoardSettingsState>
    implements $BoardSettingsStateCopyWith<$Res> {
  _$BoardSettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOwner = null,
    Object? ownerName = null,
    Object? currentBoard = freezed,
    Object? tempPassword = freezed,
    Object? tempBoardSettings = freezed,
    Object? tempBoardName = freezed,
  }) {
    return _then(_value.copyWith(
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      currentBoard: freezed == currentBoard
          ? _value.currentBoard
          : currentBoard // ignore: cast_nullable_to_non_nullable
              as BoardModel?,
      tempPassword: freezed == tempPassword
          ? _value.tempPassword
          : tempPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      tempBoardSettings: freezed == tempBoardSettings
          ? _value.tempBoardSettings
          : tempBoardSettings // ignore: cast_nullable_to_non_nullable
              as BoardSettingsModel?,
      tempBoardName: freezed == tempBoardName
          ? _value.tempBoardName
          : tempBoardName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardModelCopyWith<$Res>? get currentBoard {
    if (_value.currentBoard == null) {
      return null;
    }

    return $BoardModelCopyWith<$Res>(_value.currentBoard!, (value) {
      return _then(_value.copyWith(currentBoard: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardSettingsModelCopyWith<$Res>? get tempBoardSettings {
    if (_value.tempBoardSettings == null) {
      return null;
    }

    return $BoardSettingsModelCopyWith<$Res>(_value.tempBoardSettings!,
        (value) {
      return _then(_value.copyWith(tempBoardSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoardSettingsStateImplCopyWith<$Res>
    implements $BoardSettingsStateCopyWith<$Res> {
  factory _$$BoardSettingsStateImplCopyWith(_$BoardSettingsStateImpl value,
          $Res Function(_$BoardSettingsStateImpl) then) =
      __$$BoardSettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOwner,
      String ownerName,
      BoardModel? currentBoard,
      String? tempPassword,
      BoardSettingsModel? tempBoardSettings,
      String? tempBoardName});

  @override
  $BoardModelCopyWith<$Res>? get currentBoard;
  @override
  $BoardSettingsModelCopyWith<$Res>? get tempBoardSettings;
}

/// @nodoc
class __$$BoardSettingsStateImplCopyWithImpl<$Res>
    extends _$BoardSettingsStateCopyWithImpl<$Res, _$BoardSettingsStateImpl>
    implements _$$BoardSettingsStateImplCopyWith<$Res> {
  __$$BoardSettingsStateImplCopyWithImpl(_$BoardSettingsStateImpl _value,
      $Res Function(_$BoardSettingsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOwner = null,
    Object? ownerName = null,
    Object? currentBoard = freezed,
    Object? tempPassword = freezed,
    Object? tempBoardSettings = freezed,
    Object? tempBoardName = freezed,
  }) {
    return _then(_$BoardSettingsStateImpl(
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      currentBoard: freezed == currentBoard
          ? _value.currentBoard
          : currentBoard // ignore: cast_nullable_to_non_nullable
              as BoardModel?,
      tempPassword: freezed == tempPassword
          ? _value.tempPassword
          : tempPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      tempBoardSettings: freezed == tempBoardSettings
          ? _value.tempBoardSettings
          : tempBoardSettings // ignore: cast_nullable_to_non_nullable
              as BoardSettingsModel?,
      tempBoardName: freezed == tempBoardName
          ? _value.tempBoardName
          : tempBoardName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BoardSettingsStateImpl implements _BoardSettingsState {
  _$BoardSettingsStateImpl(
      {this.isOwner = false,
      this.ownerName = '-',
      this.currentBoard,
      this.tempPassword,
      this.tempBoardSettings,
      this.tempBoardName});

  @override
  @JsonKey()
  final bool isOwner;
  @override
  @JsonKey()
  final String ownerName;
  @override
  final BoardModel? currentBoard;
  @override
  final String? tempPassword;
  @override
  final BoardSettingsModel? tempBoardSettings;
  @override
  final String? tempBoardName;

  @override
  String toString() {
    return 'BoardSettingsState(isOwner: $isOwner, ownerName: $ownerName, currentBoard: $currentBoard, tempPassword: $tempPassword, tempBoardSettings: $tempBoardSettings, tempBoardName: $tempBoardName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardSettingsStateImpl &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.currentBoard, currentBoard) ||
                other.currentBoard == currentBoard) &&
            (identical(other.tempPassword, tempPassword) ||
                other.tempPassword == tempPassword) &&
            (identical(other.tempBoardSettings, tempBoardSettings) ||
                other.tempBoardSettings == tempBoardSettings) &&
            (identical(other.tempBoardName, tempBoardName) ||
                other.tempBoardName == tempBoardName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isOwner, ownerName, currentBoard,
      tempPassword, tempBoardSettings, tempBoardName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardSettingsStateImplCopyWith<_$BoardSettingsStateImpl> get copyWith =>
      __$$BoardSettingsStateImplCopyWithImpl<_$BoardSettingsStateImpl>(
          this, _$identity);
}

abstract class _BoardSettingsState implements BoardSettingsState {
  factory _BoardSettingsState(
      {final bool isOwner,
      final String ownerName,
      final BoardModel? currentBoard,
      final String? tempPassword,
      final BoardSettingsModel? tempBoardSettings,
      final String? tempBoardName}) = _$BoardSettingsStateImpl;

  @override
  bool get isOwner;
  @override
  String get ownerName;
  @override
  BoardModel? get currentBoard;
  @override
  String? get tempPassword;
  @override
  BoardSettingsModel? get tempBoardSettings;
  @override
  String? get tempBoardName;
  @override
  @JsonKey(ignore: true)
  _$$BoardSettingsStateImplCopyWith<_$BoardSettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
