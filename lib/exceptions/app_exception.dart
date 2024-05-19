enum AppExceptionType {
  exist,
  notFound,
  critical,
  error,
  warning,
  unknown,
}

class AppException implements Exception {
  AppException({
    this.title,
    this.detail,
    required this.type,
  });

  final String? title;
  final String? detail;
  final AppExceptionType type;

  factory AppException.exist() => AppException(type: AppExceptionType.exist);

  factory AppException.notFound() =>
      AppException(type: AppExceptionType.notFound);

  factory AppException.critical(String title, {String? detail}) => AppException(
      title: title, detail: detail, type: AppExceptionType.critical);

  factory AppException.error(String title, {String? detail}) =>
      AppException(title: title, detail: detail, type: AppExceptionType.error);

  factory AppException.warning(String title, {String? detail}) => AppException(
      title: title, detail: detail, type: AppExceptionType.warning);

  factory AppException.unknown() =>
      AppException(type: AppExceptionType.unknown);

  @override
  String toString() => '${title ?? ''}${detail != null ? ', $detail' : ''}';
}
