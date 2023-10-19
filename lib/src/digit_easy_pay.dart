import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
import 'package:digit_easy_pay_flutter/src/common/exceptions.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_provider.dart';
import 'package:digit_easy_pay_flutter/ui/views/checkout.dart';
import 'package:flutter/material.dart';

class DigitEasyPay {
  bool _initialized = false;
  final DigitEasyPayConfig config;
  List<DigitEasyPayPaymentMethod> _paymentMethods = [];
  late PaymentProvider _provider;
  DigitEasyPayCheckout? _digitEasyPayCheckout;

  DigitEasyPay(this.config);

  // final String userKeySandBox = "digitp@yQos23";
  // final String userKeyProd = "prdigitp@yQos23";
  //
  // final String adminUsernameSandbox = "us_digitpay@dmin";
  // final String adminPassSandbox = "dC2O23gvfcfj";
  //
  // final String adminUsernameProd = "us_prdigitpay@dmin";
  // final String adminPassProd = "prdC2O23gvfcfj";

  Future<void> initialize({List<DigitEasyPayPaymentMethod> paymentMethods = DigitEasyPayPaymentMethod.values}) async {
    assert(() {
      if (paymentMethods.isEmpty) {
        throw DigitEasyPayException('paymentMethods cannot be null or empty');
      }
      return true;
    }());
    _paymentMethods = paymentMethods;
    _provider = PaymentProvider(config)..initialize();

    _initialized = true;
  }

  Future<CardPayResponse?> makeCardPayment({required CardPayRequest charge})async {
    _validateInitialized();
    PaymentValidator.validateCharge(method: DigitEasyPayPaymentMethod.visa);

    return await _provider.makeCardPayment(charge);
  }

  Future<MobilePayResponse?> makeMobilePayment({required DigitEasyPayPaymentMethod method, required MobilePayRequest charge})async {
    _validateInitialized();
    PaymentValidator.validateCharge(method: method);
    return await _provider.makeMobilePayment(method, charge);
  }

  Future<void> checkout(BuildContext context, {required num amount}) async {
    await initialize().then((value) => _checkout(context, amount: amount));
  }

  Future<void> _checkout(BuildContext context, {required num amount}) async {
    _digitEasyPayCheckout ??= DigitEasyPayCheckout(context: context, amount: amount, provider: _provider);
    _digitEasyPayCheckout?.init();
  }



  void dispose() {
    _paymentMethods = [];
    _provider.dispose();
    _initialized = false;
    _digitEasyPayCheckout = null;
  }

  _validateInitialized() {
    if (!_initialized) {
      throw DigitEasyPayNotInitializedException('DigitEasyPay has not been initialized. The SDK has to be initialized before use');
    }
  }

  List<DigitEasyPayPaymentMethod> get paymentMethods => _paymentMethods;
}
