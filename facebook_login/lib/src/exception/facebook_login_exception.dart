class FacebookLoginException implements Exception {
  FacebookLoginException({
    this.code,
    this.message,
  });

  static const String CANCELLED = 'CANCELLED';
  static const String ERROR = 'ERROR';

  final String code;
  final String message;
}
