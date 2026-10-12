class AppError implements Exception {
  final String message;
  final dynamic dataResponse;
  final String? code;

  AppError({required this.message, this.dataResponse, this.code});

  @override
  String toString() {
    return message;
  }
}
