enum ErrorCodes {
  api,
  generic,
  socket,
  payment,
  mapConvert,
  unauthorized,
  validation;

  @override
  String toString() {
    return name;
  }
}

class ApiCodeError extends GlobalException {
  ApiCodeError(super.message, super.code);
}

class ErrorCep extends GlobalException {
  ErrorCep(super.message, super.code);
}

class ApiError extends GlobalException {
  ApiError(super.message, super.code);
}

class GenericError extends GlobalException {
  GenericError(super.message, super.code);
}

class SocketError extends GlobalException {
  SocketError(super.message, super.code);
}

class MapValidationError extends GlobalException {
  MapValidationError(super.message, super.code);
}

class UnauthorizedError extends GlobalException {
  UnauthorizedError(super.message, super.code);
}

abstract class GlobalException implements Exception {
  GlobalException(this.message, this.code) {}

  final ErrorCodes code;
  final String? message;

  @override
  String toString() {
    return '''
      code: $code
      message: $message
    ''';
  }
}
