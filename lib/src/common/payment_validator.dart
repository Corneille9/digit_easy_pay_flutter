import 'package:digit_easy_pay_flutter/src/common/exceptions.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class PaymentValidator{
  static bool isEmail(String value){
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
  }

  static bool isPhoneNumber(String value){
    return RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(value);
  }

  static String reformatPhone(String value){
    if(value.startsWith("+"))return value.substring(1);
    return value;
  }

  static String formatAmount(num amount, DigitEasyPayCurrency currency){
    return "$amount ${currency.name}";
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

  static Future<bool> tryLaunchUrl(String url) async {
    try{
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication, webOnlyWindowName: 'Event Chat');
      return true;
    }catch(e,_){
      DigitEasyPayException(e.toString());
      return false;
    }
  }
}