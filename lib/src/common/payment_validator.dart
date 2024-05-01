import 'package:digit_easy_pay_flutter/src/common/exceptions.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class PaymentUtils{
  static bool isEmail(String value){
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
  }

  static bool isPhoneNumber(String value){
    return RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(value);
  }

  static String reformatPhone(String value){
    if(value.startsWith("+"))value = value.substring(1);
    if(!value.startsWith("229")) value = "229$value";
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

  static Future<bool> tryLaunchUrl(String url, {LaunchMode mode = LaunchMode.externalNonBrowserApplication, WebViewConfiguration webViewConfiguration = const WebViewConfiguration(), String webOnlyWindowName = ""}) async {
    try{
      await launchUrl(Uri.parse(url), mode: mode, webOnlyWindowName: webOnlyWindowName, webViewConfiguration: webViewConfiguration);
      return true;
    }catch(e,_){
      DigitEasyPayException(e.toString());
      return false;
    }
  }

  static Future<num?> convertAmount(num amount, {String from = "XOF", String to = "USD"}) async {
    if (to == from) return amount;
    final Dio httpClient = Dio();
    try {
      var headers = {"apikey": "MBbe7yvGcCUN5auslcmeLeWao1R4l6Wa",};
      var queryParameters = {"from": from, "to": to, "amount": amount,};
      var response = await httpClient.get("https://api.apilayer.com/currency_data/convert", queryParameters: queryParameters, options: Options(headers: headers, sendTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)),);
      debugPrint("AppUtils - convertAmount - amount: $amount, from: $from, to: $to, response: ${response.data}");
      if(response.data["success"]==true) {
        return response.data["result"];
      }
      if(to == "EUR" && from == "XOF") {
        return amount / 656;
      }
      return null;
    } catch (e, _) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: _);
      if (e is DioException) {
        debugPrint(e.response?.data.toString());
        debugPrint("AppUtils - convertAmount - error 429, retrying with ninja api");
        return await convertAmountWithNinjaApi(amount);
      }
      if(to == "EUR" && from == "XOF") {
        return amount / 656;
      }
      return null;
    }
  }

  static Future<num?> convertAmountWithNinjaApi(num amount, {String from = "XOF", String to = "USD"}) async {
    if (to == from) return amount;
    final Dio httpClient = Dio();
    try {
      var headers = {"X-Api-Key": "GXwfO3iwWn6vsSB6gebzaA==fdrdSy2yJiQKvZWg",};
      var queryParameters = {"have": from, "want": to, "amount": amount,};
      var response = await httpClient.get("https://api.api-ninjas.com/v1/convertcurrency", queryParameters: queryParameters, options: Options(headers: headers, sendTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)),);
      debugPrint("AppUtils - convertAmount - amount: $amount, from: $from, to: $to, response: ${response.data}");
      if(response.statusCode==200) {
        return response.data["new_amount"];
      }
      if(to == "EUR" && from == "XOF") {
        return amount / 656;
      }
      return null;
    } catch (e, _) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: _);
      if (e is DioException) {
        debugPrint(e.response?.data.toString());
      }
      if(to == "EUR" && from == "XOF") {
        return amount / 656;
      }
      return null;
    }
  }
}