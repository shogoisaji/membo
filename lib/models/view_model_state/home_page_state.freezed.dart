// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomePageState {
  bool get isLoading => throw _privateConstructorUsedError;
  UserModel? get userModel => throw _privateConstructorUsedError;
  List<CardBoardModel> get cardBoardList => throw _privateConstructorUsedError;
  List<String> get carouselImageUrls => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomePageStateCopyWith<HomePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageStateCopyWith<$Res> {
  factory $HomePageStateCopyWith(
          HomePageState value, $Res Function(HomePageState) then) =
      _$HomePageStateCopyWithImpl<$Res, HomePageState>;
  @useResult
  $Res call(
      {bool isLoading,
      UserModel? userModel,
      List<CardBoardModel> cardBoardList,
      List<String> carouselImageUrls});

  $UserModelCopyWith<$Res>? get userModel;
}

/// @nodoc
class _$HomePageStateCopyWithImpl<$Res, $Val extends HomePageState>
    implements $HomePageStateCopyWith<$Res> {
  _$HomePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? userModel = freezed,
    Object? cardBoardList = null,
    Object? carouselImageUrls = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userModel: freezed == userModel
          ? _value.userModel
          : userModel // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      cardBoardList: null == cardBoardList
          ? _value.cardBoardList
          : cardBoardList // ignore: cast_nullable_to_non_nullable
              as List<CardBoardModel>,
      carouselImageUrls: null == carouselImageUrls
          ? _value.carouselImageUrls
          : carouselImageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get userModel {
    if (_value.userModel == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.userModel!, (value) {
      return _then(_value.copyWith(userModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomePageStateImplCopyWith<$Res>
    implements $HomePageStateCopyWith<$Res> {
  factory _$$HomePageStateImplCopyWith(
          _$HomePageStateImpl value, $Res Function(_$HomePageStateImpl) then) =
      __$$HomePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      UserModel? userModel,
      List<CardBoardModel> cardBoardList,
      List<String> carouselImageUrls});

  @override
  $UserModelCopyWith<$Res>? get userModel;
}

/// @nodoc
class __$$HomePageStateImplCopyWithImpl<$Res>
    extends _$HomePageStateCopyWithImpl<$Res, _$HomePageStateImpl>
    implements _$$HomePageStateImplCopyWith<$Res> {
  __$$HomePageStateImplCopyWithImpl(
      _$HomePageStateImpl _value, $Res Function(_$HomePageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? userModel = freezed,
    Object? cardBoardList = null,
    Object? carouselImageUrls = null,
  }) {
    return _then(_$HomePageStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userModel: freezed == userModel
          ? _value.userModel
          : userModel // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      cardBoardList: null == cardBoardList
          ? _value._cardBoardList
          : cardBoardList // ignore: cast_nullable_to_non_nullable
              as List<CardBoardModel>,
      carouselImageUrls: null == carouselImageUrls
          ? _value._carouselImageUrls
          : carouselImageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$HomePageStateImpl implements _HomePageState {
  const _$HomePageStateImpl(
      {this.isLoading = true,
      this.userModel,
      final List<CardBoardModel> cardBoardList = const [],
      final List<String> carouselImageUrls = const []})
      : _cardBoardList = cardBoardList,
        _carouselImageUrls = carouselImageUrls;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final UserModel? userModel;
  final List<CardBoardModel> _cardBoardList;
  @override
  @JsonKey()
  List<CardBoardModel> get cardBoardList {
    if (_cardBoardList is EqualUnmodifiableListView) return _cardBoardList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cardBoardList);
  }

  final List<String> _carouselImageUrls;
  @override
  @JsonKey()
  List<String> get carouselImageUrls {
    if (_carouselImageUrls is EqualUnmodifiableListView)
      return _carouselImageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_carouselImageUrls);
  }

  @override
  String toString() {
    return 'HomePageState(isLoading: $isLoading, userModel: $userModel, cardBoardList: $cardBoardList, carouselImageUrls: $carouselImageUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.userModel, userModel) ||
                other.userModel == userModel) &&
            const DeepCollectionEquality()
                .equals(other._cardBoardList, _cardBoardList) &&
            const DeepCollectionEquality()
                .equals(other._carouselImageUrls, _carouselImageUrls));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      userModel,
      const DeepCollectionEquality().hash(_cardBoardList),
      const DeepCollectionEquality().hash(_carouselImageUrls));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      __$$HomePageStateImplCopyWithImpl<_$HomePageStateImpl>(this, _$identity);
}

abstract class _HomePageState implements HomePageState {
  const factory _HomePageState(
      {final bool isLoading,
      final UserModel? userModel,
      final List<CardBoardModel> cardBoardList,
      final List<String> carouselImageUrls}) = _$HomePageStateImpl;

  @override
  bool get isLoading;
  @override
  UserModel? get userModel;
  @override
  List<CardBoardModel> get cardBoardList;
  @override
  List<String> get carouselImageUrls;
  @override
  @JsonKey(ignore: true)
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
