import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/common/exceptions.dart';

abstract class PaymentValidator{
  static bool isEmail(String value){
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
  }

  static bool isPhoneNumber(String value){
    return RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(value);
  }

  static bool validateCharge({required DigitEasyPayPaymentMethod method}){
    switch(method){
      case DigitEasyPayPaymentMethod.visa:
        return _validateCardCharge();
      case DigitEasyPayPaymentMethod.flooz:
      case DigitEasyPayPaymentMethod.momo:
        return _validateMobileCharge();
      default:
        throw DigitEasyPayException("Unknown payment method $method");
    }
  }

  static bool _validateCardCharge(){
    return true;
  }

  static bool _validateMobileCharge(){
    return true;
  }
}