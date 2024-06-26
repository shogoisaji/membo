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
// ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'board_name')
  String get boardName => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  List<ObjectModel> get objects =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'owner_id')
  String get ownerId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'editable_user_ids')
  List<String> get editableUserIds =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  int get width => throw _privateConstructorUsedError;
  int get height =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'bg_color')
  String get bgColor =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_public')
  bool get isPublic =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'max_image_count')
  int get maxImageCount =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'that_day')
  DateTime get thatDay =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
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
      {@JsonKey(name: 'board_id') String boardId,
      @JsonKey(name: 'board_name') String boardName,
      String password,
      List<ObjectModel> objects,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'editable_user_ids') List<String> editableUserIds,
      int width,
      int height,
      @JsonKey(name: 'bg_color') String bgColor,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'max_image_count') int maxImageCount,
      @JsonKey(name: 'that_day') DateTime thatDay,
      @JsonKey(name: 'created_at') DateTime createdAt});
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
    Object? editableUserIds = null,
    Object? width = null,
    Object? height = null,
    Object? bgColor = null,
    Object? isPublic = null,
    Object? thumbnailUrl = freezed,
    Object? maxImageCount = null,
    Object? thatDay = null,
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
      editableUserIds: null == editableUserIds
          ? _value.editableUserIds
          : editableUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      bgColor: null == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maxImageCount: null == maxImageCount
          ? _value.maxImageCount
          : maxImageCount // ignore: cast_nullable_to_non_nullable
              as int,
      thatDay: null == thatDay
          ? _value.thatDay
          : thatDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
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
      {@JsonKey(name: 'board_id') String boardId,
      @JsonKey(name: 'board_name') String boardName,
      String password,
      List<ObjectModel> objects,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'editable_user_ids') List<String> editableUserIds,
      int width,
      int height,
      @JsonKey(name: 'bg_color') String bgColor,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'max_image_count') int maxImageCount,
      @JsonKey(name: 'that_day') DateTime thatDay,
      @JsonKey(name: 'created_at') DateTime createdAt});
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
    Object? editableUserIds = null,
    Object? width = null,
    Object? height = null,
    Object? bgColor = null,
    Object? isPublic = null,
    Object? thumbnailUrl = freezed,
    Object? maxImageCount = null,
    Object? thatDay = null,
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
      editableUserIds: null == editableUserIds
          ? _value._editableUserIds
          : editableUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      bgColor: null == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      maxImageCount: null == maxImageCount
          ? _value.maxImageCount
          : maxImageCount // ignore: cast_nullable_to_non_nullable
              as int,
      thatDay: null == thatDay
          ? _value.thatDay
          : thatDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      {@JsonKey(name: 'board_id') required this.boardId,
      @JsonKey(name: 'board_name') this.boardName = '-',
      this.password = '',
      final List<ObjectModel> objects = const [],
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'editable_user_ids')
      final List<String> editableUserIds = const [],
      this.width = 1000,
      this.height = 1000,
      @JsonKey(name: 'bg_color') this.bgColor = '0xffffffff',
      @JsonKey(name: 'is_public') this.isPublic = false,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      @JsonKey(name: 'max_image_count') this.maxImageCount = 0,
      @JsonKey(name: 'that_day') required this.thatDay,
      @JsonKey(name: 'created_at') required this.createdAt})
      : _objects = objects,
        _editableUserIds = editableUserIds;

  factory _$BoardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'board_id')
  final String boardId;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'board_name')
  final String boardName;
  @override
  @JsonKey()
  final String password;
  final List<ObjectModel> _objects;
  @override
  @JsonKey()
  List<ObjectModel> get objects {
    if (_objects is EqualUnmodifiableListView) return _objects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_objects);
  }

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
// ignore: invalid_annotation_target
  final List<String> _editableUserIds;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'editable_user_ids')
  List<String> get editableUserIds {
    if (_editableUserIds is EqualUnmodifiableListView) return _editableUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_editableUserIds);
  }

// ignore: invalid_annotation_target
  @override
  @JsonKey()
  final int width;
  @override
  @JsonKey()
  final int height;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'bg_color')
  final String bgColor;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'max_image_count')
  final int maxImageCount;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'that_day')
  final DateTime thatDay;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'BoardModel(boardId: $boardId, boardName: $boardName, password: $password, objects: $objects, ownerId: $ownerId, editableUserIds: $editableUserIds, width: $width, height: $height, bgColor: $bgColor, isPublic: $isPublic, thumbnailUrl: $thumbnailUrl, maxImageCount: $maxImageCount, thatDay: $thatDay, createdAt: $createdAt)';
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
            const DeepCollectionEquality()
                .equals(other._editableUserIds, _editableUserIds) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.bgColor, bgColor) || other.bgColor == bgColor) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.maxImageCount, maxImageCount) ||
                other.maxImageCount == maxImageCount) &&
            (identical(other.thatDay, thatDay) || other.thatDay == thatDay) &&
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
      const DeepCollectionEquality().hash(_editableUserIds),
      width,
      height,
      bgColor,
      isPublic,
      thumbnailUrl,
      maxImageCount,
      thatDay,
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
      {@JsonKey(name: 'board_id') required final String boardId,
      @JsonKey(name: 'board_name') final String boardName,
      final String password,
      final List<ObjectModel> objects,
      @JsonKey(name: 'owner_id') required final String ownerId,
      @JsonKey(name: 'editable_user_ids') final List<String> editableUserIds,
      final int width,
      final int height,
      @JsonKey(name: 'bg_color') final String bgColor,
      @JsonKey(name: 'is_public') final bool isPublic,
      @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
      @JsonKey(name: 'max_image_count') final int maxImageCount,
      @JsonKey(name: 'that_day') required final DateTime thatDay,
      @JsonKey(name: 'created_at')
      required final DateTime createdAt}) = _$BoardModelImpl;

  factory _BoardModel.fromJson(Map<String, dynamic> json) =
      _$BoardModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'board_id')
  String get boardId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'board_name')
  String get boardName;
  @override
  String get password;
  @override
  List<ObjectModel> get objects;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'editable_user_ids')
  List<String> get editableUserIds;
  @override // ignore: invalid_annotation_target
  int get width;
  @override
  int get height;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'bg_color')
  String get bgColor;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'max_image_count')
  int get maxImageCount;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'that_day')
  DateTime get thatDay;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BoardModelImplCopyWith<_$BoardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
