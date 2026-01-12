class AppError implements Exception {
  final String message;
  final dynamic dataResponse;

  AppError({required this.message, this.dataResponse});

  @override
  String toString() {
    return message;
  }
}
