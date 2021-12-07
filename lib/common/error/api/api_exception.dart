import 'package:festivalapp/common/error/app_exception.dart';

class FetchDataException extends AppException {
  FetchDataException({required String? message})
      : super(message: message, prefix: "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException({required String? message})
      : super(message: message, prefix: "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException({required String? message})
      : super(message: message, prefix: "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException({required String? message})
      : super(message: message, prefix: "Invalid Input: ");
}
