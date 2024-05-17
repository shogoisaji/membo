import 'package:json_annotation/json_annotation.dart';

part 'user_type.g.dart'; // JSON シリアライズのコードを生成するためのパートファイル

// UserTypeのenum定義
enum UserTypes { admin, free, premium }

@JsonSerializable()
class UserType {
  @JsonKey(name: 'user_type')
  final UserTypes type;
  final int _maxImageCount;
  final int _maxBoardCount;

  const UserType({
    required this.type,
  })  : _maxImageCount = type == UserTypes.admin
            ? 100
            : type == UserTypes.premium
                ? 30
                : 30,
        _maxBoardCount = type == UserTypes.admin
            ? 100
            : type == UserTypes.premium
                ? 10
                : 1;

  get maxImageCount => _maxImageCount;
  get maxBoardCount => _maxBoardCount;
  get string => type.toString();

  Map<String, dynamic> toJson() => _$UserTypeToJson(this);

  factory UserType.fromJson(Map<String, dynamic> json) =>
      _$UserTypeFromJson(json);
}

// JSON キーのカスタムデシリアライズロジック
UserTypes _userTypeFromJson(String type) {
  return UserTypes.values.firstWhere(
    (e) => e.toString().split('.')[1] == type,
    orElse: () => UserTypes.free,
  );
}
