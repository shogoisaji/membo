import 'package:json_annotation/json_annotation.dart';

part 'membership_type.g.dart';

enum MembershipTypes { admin, free, silver, gold }

@JsonSerializable()
class MembershipType {
  @JsonKey(name: 'membership_type')
  final MembershipTypes type;
  final int _maxImageCount;
  final int _maxBoardCount;

  MembershipType({
    required this.type,
  })  : _maxImageCount = _getMaxImageCount(type),
        _maxBoardCount = _getMaxBoardCount(type);

  /// TODO:DBで管理した方が良いかも
  static int _getMaxImageCount(MembershipTypes type) {
    switch (type) {
      case MembershipTypes.admin:
        return 100;
      case MembershipTypes.gold:
        return 10;
      case MembershipTypes.silver:
        return 5;
      case MembershipTypes.free:
      default:
        return 3;
    }
  }

  static int _getMaxBoardCount(MembershipTypes type) {
    switch (type) {
      case MembershipTypes.admin:
        return 100;
      case MembershipTypes.gold:
        return 30;
      case MembershipTypes.silver:
        return 10;
      case MembershipTypes.free:
      default:
        return 3;
    }
  }

  get maxImageCount => _maxImageCount;
  get maxBoardCount => _maxBoardCount;
  get string => type.toString();

  Map<String, dynamic> toJson() => _$MembershipTypeToJson(this);

  factory MembershipType.fromJson(Map<String, dynamic> json) =>
      _$MembershipTypeFromJson(json);
}

// JSON キーのカスタムデシリアライズロジック
MembershipTypes _membershipTypeFromJson(String type) {
  return MembershipTypes.values.firstWhere(
    (e) => e.toString().split('.')[1] == type,
    orElse: () => MembershipTypes.free,
  );
}
