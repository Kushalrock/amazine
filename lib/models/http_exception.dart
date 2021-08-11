class HTTPException implements Exception {
  final String message;

  @override
  String toString() {
    return message;
  }

  HTTPException(this.message);
}
