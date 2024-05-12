// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_list_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditListPageState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<BoardModel> get editableBoards => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditListPageStateCopyWith<EditListPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditListPageStateCopyWith<$Res> {
  factory $EditListPageStateCopyWith(
          EditListPageState value, $Res Function(EditListPageState) then) =
      _$EditListPageStateCopyWithImpl<$Res, EditListPageState>;
  @useResult
  $Res call({bool isLoading, List<BoardModel> editableBoards});
}

/// @nodoc
class _$EditListPageStateCopyWithImpl<$Res, $Val extends EditListPageState>
    implements $EditListPageStateCopyWith<$Res> {
  _$EditListPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? editableBoards = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      editableBoards: null == editableBoards
          ? _value.editableBoards
          : editableBoards // ignore: cast_nullable_to_non_nullable
              as List<BoardModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditListPageStateImplCopyWith<$Res>
    implements $EditListPageStateCopyWith<$Res> {
  factory _$$EditListPageStateImplCopyWith(_$EditListPageStateImpl value,
          $Res Function(_$EditListPageStateImpl) then) =
      __$$EditListPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<BoardModel> editableBoards});
}

/// @nodoc
class __$$EditListPageStateImplCopyWithImpl<$Res>
    extends _$EditListPageStateCopyWithImpl<$Res, _$EditListPageStateImpl>
    implements _$$EditListPageStateImplCopyWith<$Res> {
  __$$EditListPageStateImplCopyWithImpl(_$EditListPageStateImpl _value,
      $Res Function(_$EditListPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? editableBoards = null,
  }) {
    return _then(_$EditListPageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      editableBoards: null == editableBoards
          ? _value._editableBoards
          : editableBoards // ignore: cast_nullable_to_non_nullable
              as List<BoardModel>,
    ));
  }
}

/// @nodoc

class _$EditListPageStateImpl implements _EditListPageState {
  _$EditListPageStateImpl(
      {this.isLoading = true, final List<BoardModel> editableBoards = const []})
      : _editableBoards = editableBoards;

  @override
  @JsonKey()
  final bool isLoading;
  final List<BoardModel> _editableBoards;
  @override
  @JsonKey()
  List<BoardModel> get editableBoards {
    if (_editableBoards is EqualUnmodifiableListView) return _editableBoards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_editableBoards);
  }

  @override
  String toString() {
    return 'EditListPageState(isLoading: $isLoading, editableBoards: $editableBoards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditListPageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._editableBoards, _editableBoards));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_editableBoards));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditListPageStateImplCopyWith<_$EditListPageStateImpl> get copyWith =>
      __$$EditListPageStateImplCopyWithImpl<_$EditListPageStateImpl>(
          this, _$identity);
}

abstract class _EditListPageState implements EditListPageState {
  factory _EditListPageState(
      {final bool isLoading,
      final List<BoardModel> editableBoards}) = _$EditListPageStateImpl;

  @override
  bool get isLoading;
  @override
  List<BoardModel> get editableBoards;
  @override
  @JsonKey(ignore: true)
  _$$EditListPageStateImplCopyWith<_$EditListPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
