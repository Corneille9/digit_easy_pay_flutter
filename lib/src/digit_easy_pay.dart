/// DigitEasyPay Class
///
/// This class provides a set of methods and functionality for integrating with the DigitEasyPay payment system. It allows you to make card and mobile payments and handle the checkout process.
///
/// To use this class, you need to initialize it with a `DigitEasyPayConfig` object, which contains the necessary configuration details for your payment setup.
///
/// Example usage:
/// ```dart
/// final config = DigitEasyPayConfig(apiKey: 'your_api_key');
/// final digitEasyPay = DigitEasyPay(config);
/// digitEasyPay.initialize(paymentMethods: [DigitEasyPayPaymentMethod.visa, DigitEasyPayPaymentMethod.masterCard]);
/// ```
import 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
import 'package:digit_easy_pay_flutter/src/common/exceptions.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_service.dart';
import 'package:digit_easy_pay_flutter/ui/views/digit_easy_pay_checkout.dart';
import 'package:flutter/material.dart';

class DigitEasyPay {
  bool _initialized = false;
  final DigitEasyPayConfig config;
  late PaymentService _provider;
  DigitEasyPayCheckout? _digitEasyPayCheckout;

  /// Constructor for the DigitEasyPay class.
  ///
  /// Initializes the class with a `DigitEasyPayConfig` object.
  ///
  /// @param config The configuration for the DigitEasyPay integration.
  DigitEasyPay(this.config);

  /// Initialize the DigitEasyPay SDK.
  ///
  /// This method should be called before using other methods of the SDK.
  ///
  /// @param paymentMethods A list of payment methods to support (default is all methods).
  Future<void> initialize() async {
    assert(() {
      if (config.paymentMethods.isEmpty) {
        throw DigitEasyPayException('paymentMethods cannot be null or empty');
      }
      return true;
    }());
    _provider = PaymentService(config)..initialize();
    _initialized = true;
  }

  /// Make a card payment using the DigitEasyPay SDK.
  ///
  /// @param charge The card payment request details.
  /// @return A `CardPayResponse` object with the payment result.
  Future<CardPayResponse?> makeCardPayment({required CardPayRequest charge}) async {
    _validateInitialized();
    PaymentUtils.validateCharge(method: DigitEasyPayPaymentMethod.visa);

    return await _provider.makeCardPayment(charge);
  }

  /// Make a mobile payment using the DigitEasyPay SDK.
  ///
  /// @param method The mobile payment method to use.
  /// @param charge The mobile payment request details.
  /// @return A `MobilePayResponse` object with the payment result.
  Future<MobilePayResponse?> makeMobilePayment({required DigitEasyPayPaymentMethod method, required MobilePayRequest charge}) async {
    _validateInitialized();
    PaymentUtils.validateCharge(method: method);
    return await _provider.makeMobilePayment(method, charge);
  }

  /// Initiate the payment checkout process.
  ///
  /// @param context The build context for the payment checkout.
  /// @param amount The payment amount.
  /// @param currency The currency to use for the payment (default is XOF).
  /// @param theme The payment theme (optional).
  /// @param l10n The localization settings for the payment (optional).
  Future<void> checkout(BuildContext context, {required num amount, DigitEasyPayCurrency currency = DigitEasyPayCurrency.XOF, PaymentTheme? theme, L10n? l10n, VoidCallback? onCancel, final DigitEasyPayCallback? onSuccess}) async {
    if (amount <= 0) {
      throw InvalidAmountException(amount);
    }
    _validateInitialized();

    await _checkout(context, amount: amount, currency: currency, theme: theme, l10n: l10n, onCancel: onCancel, onSuccess: onSuccess);
  }

  Future<void> _checkout(BuildContext context, {required num amount, DigitEasyPayCurrency currency = DigitEasyPayCurrency.XOF, PaymentTheme? theme, L10n? l10n, VoidCallback? onCancel, final DigitEasyPayCallback? onSuccess}) async {
    _digitEasyPayCheckout ??= DigitEasyPayCheckout(context: context, amount: amount, provider: _provider, currency: currency, theme: theme, l10n: l10n, onCancel:onCancel , onSuccess: onSuccess);
    _digitEasyPayCheckout?.init();
  }

  /// Dispose of the DigitEasyPay instance.
  void dispose() {
    _provider.dispose();
    _initialized = false;
    _digitEasyPayCheckout = null;
  }

  // Helper method to validate if the SDK is initialized.
  _validateInitialized() {
    if (!_initialized) {
      throw DigitEasyPayNotInitializedException('DigitEasyPay has not been initialized. The SDK has to be initialized before use');
    }
  }
}
