
import 'package:dio/dio.dart';

class DigitEasyPayException implements Exception {
  String? message;

  DigitEasyPayException(this.message);


  static interpretError(DioException exception){
    var response = exception.response;

    print(response?.statusCode);
    if(response?.statusCode==401 || response?.statusCode==403){
      throw AuthenticationException("Authentication Error: The provided API keys are invalid."
          "Please double-check that you have correctly configured the API keys in your request. Ensure that both the public key and private key are accurate and correspond to your account. If you have recently generated new keys, make sure to update them in your code."
          "If the issue persists, feel free to reach out to our support team at [support email address] or [support phone number] for further assistance.");
    }
  }

  @override
  String toString() {
    if (message == null) return "Unknown Error";
    return message!;
  }
}

class AuthenticationException extends DigitEasyPayException {
  AuthenticationException(String message) : super(message);
}

class CardException extends DigitEasyPayException {
  CardException(String message) : super(message);
}

class ChargeException extends DigitEasyPayException {
  ChargeException(String? message) : super(message);
}

class InvalidAmountException extends DigitEasyPayException {
  num amount = 0;

  InvalidAmountException(this.amount)
      : super('$amount is not a valid '
      'amount. only positive non-zero values are allowed.');
}

class InvalidEmailException extends DigitEasyPayException {
  String? email;
  InvalidEmailException(this.email) : super('$email  is not a valid email');
}

class ProcessingException extends ChargeException {
  ProcessingException()
      : super(
      'A transaction is currently processing, please wait till it concludes before attempting a new charge.');
}

class DigitEasyPayNotInitializedException extends DigitEasyPayException {
  DigitEasyPayNotInitializedException(String message) : super(message);
}