
class DigitEasyPayException implements Exception {
  String? message;

  DigitEasyPayException(this.message);

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
  int amount = 0;

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