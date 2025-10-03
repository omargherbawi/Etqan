abstract interface class Failure {
  final String message;

  Failure([this.message = "Sorry, an unexpected error occurred!"]);

  @override
  String toString() => 'Failure(message: $message)';
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = "Network error occurred!"]);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = "Server error occurred!"]);
}

class ValidationFailure extends Failure {
  ValidationFailure([super.message = "Validation error occurred!"]);
}

class ParsingFailure extends Failure {
  ParsingFailure([super.message = "Parsing error"]);
}

class AuthFailure extends Failure {
  AuthFailure([super.message = "Auth Failure"]);
}

class UnknownFailure extends Failure {
  UnknownFailure([super.message = "An unknown error occurred!"]);
}

class UpgradeRequiredFailure extends Failure {
  UpgradeRequiredFailure(super.message);
}
