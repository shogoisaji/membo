// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BoardModel _$BoardModelFromJson(Map<String, dynamic> json) {
  return _BoardModel.fromJson(json);
}

/// @nodoc
mixin _$BoardModel {
  String get boardId => throw _privateConstructorUsedError;
  String get boardName => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  List<ObjectModel> get objects => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  BoardSettingsModel get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoardModelCopyWith<BoardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardModelCopyWith<$Res> {
  factory $BoardModelCopyWith(
          BoardModel value, $Res Function(BoardModel) then) =
      _$BoardModelCopyWithImpl<$Res, BoardModel>;
  @useResult
  $Res call(
      {String boardId,
      String boardName,
      String password,
      List<ObjectModel> objects,
      String ownerId,
      BoardSettingsModel settings,
      DateTime createdAt});

  $BoardSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class _$BoardModelCopyWithImpl<$Res, $Val extends BoardModel>
    implements $BoardModelCopyWith<$Res> {
  _$BoardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? boardName = null,
    Object? password = null,
    Object? objects = null,
    Object? ownerId = null,
    Object? settings = null,
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
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      objects: null == objects
          ? _value.objects
          : objects // ignore: cast_nullable_to_non_nullable
              as List<ObjectModel>,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BoardSettingsModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardSettingsModelCopyWith<$Res> get settings {
    return $BoardSettingsModelCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoardModelImplCopyWith<$Res>
    implements $BoardModelCopyWith<$Res> {
  factory _$$BoardModelImplCopyWith(
          _$BoardModelImpl value, $Res Function(_$BoardModelImpl) then) =
      __$$BoardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String boardId,
      String boardName,
      String password,
      List<ObjectModel> objects,
      String ownerId,
      BoardSettingsModel settings,
      DateTime createdAt});

  @override
  $BoardSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class __$$BoardModelImplCopyWithImpl<$Res>
    extends _$BoardModelCopyWithImpl<$Res, _$BoardModelImpl>
    implements _$$BoardModelImplCopyWith<$Res> {
  __$$BoardModelImplCopyWithImpl(
      _$BoardModelImpl _value, $Res Function(_$BoardModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? boardName = null,
    Object? password = null,
    Object? objects = null,
    Object? ownerId = null,
    Object? settings = null,
    Object? createdAt = null,
  }) {
    return _then(_$BoardModelImpl(
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      boardName: null == boardName
          ? _value.boardName
          : boardName // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      objects: null == objects
          ? _value._objects
          : objects // ignore: cast_nullable_to_non_nullable
              as List<ObjectModel>,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BoardSettingsModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardModelImpl implements _BoardModel {
  const _$BoardModelImpl(
      {required this.boardId,
      this.boardName = '-',
      required this.password,
      required final List<ObjectModel> objects,
      required this.ownerId,
      this.settings = const BoardSettingsModel(),
      required this.createdAt})
      : _objects = objects;

  factory _$BoardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardModelImplFromJson(json);

  @override
  final String boardId;
  @override
  @JsonKey()
  final String boardName;
  @override
  final String password;
  final List<ObjectModel> _objects;
  @override
  List<ObjectModel> get objects {
    if (_objects is EqualUnmodifiableListView) return _objects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_objects);
  }

  @override
  final String ownerId;
  @override
  @JsonKey()
  final BoardSettingsModel settings;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BoardModel(boardId: $boardId, boardName: $boardName, password: $password, objects: $objects, ownerId: $ownerId, settings: $settings, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardModelImpl &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.boardName, boardName) ||
                other.boardName == boardName) &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality().equals(other._objects, _objects) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      boardId,
      boardName,
      password,
      const DeepCollectionEquality().hash(_objects),
      ownerId,
      settings,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardModelImplCopyWith<_$BoardModelImpl> get copyWith =>
      __$$BoardModelImplCopyWithImpl<_$BoardModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardModelImplToJson(
      this,
    );
  }
}

abstract class _BoardModel implements BoardModel {
  const factory _BoardModel(
      {required final String boardId,
      final String boardName,
      required final String password,
      required final List<ObjectModel> objects,
      required final String ownerId,
      final BoardSettingsModel settings,
      required final DateTime createdAt}) = _$BoardModelImpl;

  factory _BoardModel.fromJson(Map<String, dynamic> json) =
      _$BoardModelImpl.fromJson;

  @override
  String get boardId;
  @override
  String get boardName;
  @override
  String get password;
  @override
  List<ObjectModel> get objects;
  @override
  String get ownerId;
  @override
  BoardSettingsModel get settings;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BoardModelImplCopyWith<_$BoardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
