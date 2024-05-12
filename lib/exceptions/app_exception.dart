class AppException implements Exception {
  AppException({
    this.title,
    this.detail,
  });

  factory AppException.error(String title, {String? detail}) =>
      AppException(title: title, detail: detail);
  factory AppException.warning(String title, {String? detail}) =>
      AppException(title: title, detail: detail);
  factory AppException.unknown() => AppException(title: '', detail: '');

  final String? title;
  final String? detail;

  @override
  String toString() => '${title ?? ''}${detail != null ? ', $detail' : ''}';
}
