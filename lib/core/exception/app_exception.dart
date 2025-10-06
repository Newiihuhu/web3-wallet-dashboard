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

class LocalStorageException extends AppException {
  const LocalStorageException(super.message, {super.code});
}

class RemoteException extends AppException {
  const RemoteException(super.message, {super.code});
}
