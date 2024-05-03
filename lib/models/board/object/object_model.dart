import 'package:freezed_annotation/freezed_annotation.dart';

part 'object_model.freezed.dart';
part 'object_model.g.dart';

enum ObjectType {
  networkImage,
  localImage,
  text,
  stamp,
}

@freezed
class ObjectModel with _$ObjectModel {
  const factory ObjectModel({
    required String objectId,
    required ObjectType type,
    required double positionX,
    required double positionY,
    required double angle,
    required double scale,
    required String bgColor,
    String? imageUrl,
    String? text,
    int? stampId,
    required String creatorId,
    required DateTime createdAt,
  }) = _ObjectModel;

  factory ObjectModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectModelFromJson(json);
}
