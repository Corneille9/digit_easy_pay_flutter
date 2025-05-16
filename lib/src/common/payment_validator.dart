import 'package:digit_currency_converter/digit_currency_converter.dart' hide Currency;
import 'package:digit_easy_pay_flutter/src/common/exceptions.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/phone_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class PaymentUtils {
  static bool isEmail(String value) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(value);
  }

  static bool isPhoneNumber(String value) {
    return PhoneValidator.isValid(value, allowSpaces: false);
  }

  static String reformatPhone(String value) {
    if (value.startsWith("+")) value = value.substring(1);
    if (!value.startsWith("229")) value = "229$value";
    return value;
  }

  static String formatAmount(num amount, Currency currency) {
    return "${amount.toStringAsFixed(2)} ${currency.name}";
  }

  static bool validateCharge({required QosicPaymentGateway method}) {
    switch (method) {
      case QosicPaymentGateway.visa:
        return _validateCardCharge();
      case QosicPaymentGateway.flooz:
      case QosicPaymentGateway.momo:
        return _validateMobileCharge();
      }
  }

  static bool _validateCardCharge() {
    return true;
  }

  static bool _validateMobileCharge() {
    return true;
  }

  static Future<bool> tryLaunchUrl(
    String url, {
    LaunchMode mode = LaunchMode.externalNonBrowserApplication,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String webOnlyWindowName = "",
  }) async {
    try {
      await launchUrl(
        Uri.parse(url),
        mode: mode,
        webOnlyWindowName: webOnlyWindowName,
        webViewConfiguration: webViewConfiguration,
      );
      return true;
    } catch (e, _) {
      DigitEasyPayException(e.toString());
      return false;
    }
  }

  static Future<num?> convertAmount(
    num amount,
    Credentials converterCredentials, {
    String from = "XOF",
    String to = "EUR",
  }) async {
    if (to == from) return amount;
    try {
      var converter = DigitCurrencyConverter(credentials: converterCredentials);
      return await converter.convert(
        from: from.asCurrency,
        to: to.asCurrency,
        amount: amount.toDouble(),
        withoutRounding: true,
      );
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      if (e is DioException) {
        debugPrint(e.response?.data.toString());
        debugPrint("AppUtils - convertAmount - error 429, retrying with ninja api");
      }
      return null;
    }
  }
}
