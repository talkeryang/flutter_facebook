class FacebookLoginException implements Exception {
  const FacebookLoginException({
    required this.code,
    this.message,
  });

  static const String CANCELLED = 'CANCELLED';
  static const String FAILED = 'FAILED';

  final String code;
  final String? message;
}
