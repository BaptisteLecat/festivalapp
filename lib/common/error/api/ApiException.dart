import 'package:festivalapp/common/error/AppException.dart';

class FetchDataException extends AppException {
  FetchDataException({required String message})
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException({required String message}) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException({required String message}) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException({required String message}) : super(message, "Invalid Input: ");
}
