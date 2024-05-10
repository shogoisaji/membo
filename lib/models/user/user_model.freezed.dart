// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'owned_board_ids')
  List<String> get ownedBoardIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'link_board_ids')
  List<String> get linkBoardIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_type')
  UserType get userType => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'owned_board_ids') List<String> ownedBoardIds,
      @JsonKey(name: 'link_board_ids') List<String> linkBoardIds,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'user_type') UserType userType,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? ownedBoardIds = null,
    Object? linkBoardIds = null,
    Object? avatarUrl = freezed,
    Object? userType = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      ownedBoardIds: null == ownedBoardIds
          ? _value.ownedBoardIds
          : ownedBoardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      linkBoardIds: null == linkBoardIds
          ? _value.linkBoardIds
          : linkBoardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'owned_board_ids') List<String> ownedBoardIds,
      @JsonKey(name: 'link_board_ids') List<String> linkBoardIds,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'user_type') UserType userType,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? ownedBoardIds = null,
    Object? linkBoardIds = null,
    Object? avatarUrl = freezed,
    Object? userType = null,
    Object? createdAt = null,
  }) {
    return _then(_$UserModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      ownedBoardIds: null == ownedBoardIds
          ? _value._ownedBoardIds
          : ownedBoardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      linkBoardIds: null == linkBoardIds
          ? _value._linkBoardIds
          : linkBoardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  _$UserModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'user_name') required this.userName,
      @JsonKey(name: 'owned_board_ids')
      required final List<String> ownedBoardIds,
      @JsonKey(name: 'link_board_ids') required final List<String> linkBoardIds,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'user_type') required this.userType,
      @JsonKey(name: 'created_at') required this.createdAt})
      : _ownedBoardIds = ownedBoardIds,
        _linkBoardIds = linkBoardIds;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  final List<String> _ownedBoardIds;
  @override
  @JsonKey(name: 'owned_board_ids')
  List<String> get ownedBoardIds {
    if (_ownedBoardIds is EqualUnmodifiableListView) return _ownedBoardIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ownedBoardIds);
  }

  final List<String> _linkBoardIds;
  @override
  @JsonKey(name: 'link_board_ids')
  List<String> get linkBoardIds {
    if (_linkBoardIds is EqualUnmodifiableListView) return _linkBoardIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_linkBoardIds);
  }

  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'user_type')
  final UserType userType;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserModel(userId: $userId, userName: $userName, ownedBoardIds: $ownedBoardIds, linkBoardIds: $linkBoardIds, avatarUrl: $avatarUrl, userType: $userType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            const DeepCollectionEquality()
                .equals(other._ownedBoardIds, _ownedBoardIds) &&
            const DeepCollectionEquality()
                .equals(other._linkBoardIds, _linkBoardIds) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      userName,
      const DeepCollectionEquality().hash(_ownedBoardIds),
      const DeepCollectionEquality().hash(_linkBoardIds),
      avatarUrl,
      userType,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  factory _UserModel(
      {@JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'user_name') required final String userName,
      @JsonKey(name: 'owned_board_ids')
      required final List<String> ownedBoardIds,
      @JsonKey(name: 'link_board_ids') required final List<String> linkBoardIds,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'user_type') required final UserType userType,
      @JsonKey(name: 'created_at')
      required final DateTime createdAt}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'owned_board_ids')
  List<String> get ownedBoardIds;
  @override
  @JsonKey(name: 'link_board_ids')
  List<String> get linkBoardIds;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'user_type')
  UserType get userType;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
