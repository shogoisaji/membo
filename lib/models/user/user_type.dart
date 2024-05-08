enum UserTypes { admin, free, premium }

class UserType {
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

  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'maxImageCount': _maxImageCount,
        'maxBoardCount': _maxBoardCount,
      };

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      type: UserTypes.values.firstWhere(
        (e) => e.toString().split('.')[1] == json['type'],
        orElse: () => UserTypes.free,
      ),
    );
  }
}
