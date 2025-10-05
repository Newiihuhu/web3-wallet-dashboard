abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class AddressNotFoundException extends AppException {
  const AddressNotFoundException(super.message, {super.code});
}

class AuthenticationException extends AppException {
  const AuthenticationException(super.message, {super.code});
}

class JsonRpcException extends AppException {
  const JsonRpcException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}
