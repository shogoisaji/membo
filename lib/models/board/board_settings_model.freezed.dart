// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BoardSettingsModel _$BoardSettingsModelFromJson(Map<String, dynamic> json) {
  return _BoardSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$BoardSettingsModel {
  double get height => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  String get bgColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoardSettingsModelCopyWith<BoardSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardSettingsModelCopyWith<$Res> {
  factory $BoardSettingsModelCopyWith(
          BoardSettingsModel value, $Res Function(BoardSettingsModel) then) =
      _$BoardSettingsModelCopyWithImpl<$Res, BoardSettingsModel>;
  @useResult
  $Res call({double height, double width, String bgColor});
}

/// @nodoc
class _$BoardSettingsModelCopyWithImpl<$Res, $Val extends BoardSettingsModel>
    implements $BoardSettingsModelCopyWith<$Res> {
  _$BoardSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? width = null,
    Object? bgColor = null,
  }) {
    return _then(_value.copyWith(
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      bgColor: null == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardSettingsModelImplCopyWith<$Res>
    implements $BoardSettingsModelCopyWith<$Res> {
  factory _$$BoardSettingsModelImplCopyWith(_$BoardSettingsModelImpl value,
          $Res Function(_$BoardSettingsModelImpl) then) =
      __$$BoardSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double height, double width, String bgColor});
}

/// @nodoc
class __$$BoardSettingsModelImplCopyWithImpl<$Res>
    extends _$BoardSettingsModelCopyWithImpl<$Res, _$BoardSettingsModelImpl>
    implements _$$BoardSettingsModelImplCopyWith<$Res> {
  __$$BoardSettingsModelImplCopyWithImpl(_$BoardSettingsModelImpl _value,
      $Res Function(_$BoardSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? width = null,
    Object? bgColor = null,
  }) {
    return _then(_$BoardSettingsModelImpl(
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      bgColor: null == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardSettingsModelImpl implements _BoardSettingsModel {
  const _$BoardSettingsModelImpl(
      {this.height = defaultHeight,
      this.width = defaultWidth,
      this.bgColor = '0xffffffff'});

  factory _$BoardSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardSettingsModelImplFromJson(json);

  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final String bgColor;

  @override
  String toString() {
    return 'BoardSettingsModel(height: $height, width: $width, bgColor: $bgColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardSettingsModelImpl &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.bgColor, bgColor) || other.bgColor == bgColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, height, width, bgColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardSettingsModelImplCopyWith<_$BoardSettingsModelImpl> get copyWith =>
      __$$BoardSettingsModelImplCopyWithImpl<_$BoardSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _BoardSettingsModel implements BoardSettingsModel {
  const factory _BoardSettingsModel(
      {final double height,
      final double width,
      final String bgColor}) = _$BoardSettingsModelImpl;

  factory _BoardSettingsModel.fromJson(Map<String, dynamic> json) =
      _$BoardSettingsModelImpl.fromJson;

  @override
  double get height;
  @override
  double get width;
  @override
  String get bgColor;
  @override
  @JsonKey(ignore: true)
  _$$BoardSettingsModelImplCopyWith<_$BoardSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
