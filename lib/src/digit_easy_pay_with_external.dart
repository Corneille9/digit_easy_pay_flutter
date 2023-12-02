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
import 'package:digit_easy_pay_flutter/src/providers/payment_service.dart';
import 'package:digit_easy_pay_flutter/ui/views/digit_easy_pay_external_checkout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DigitEasyPayEasyPayWithExternal {
  bool _initialized = false;
  final PaymentConfig config;
  List<DigitEasyPayPaymentSource> _paymentSources = [];
  DigitEasyPayExternalCheckout? _externalCheckout;

  /// Constructor for the DigitEasyPay class.
  ///
  /// Initializes the class with a `DigitEasyPayConfig` object.
  ///
  /// @param config The configuration for the DigitEasyPay integration.
  DigitEasyPayEasyPayWithExternal(this.config);

  /// Initialize the DigitEasyPay SDK.
  ///
  /// This method should be called before using other methods of the SDK.
  ///
  /// @param paymentMethods A list of payment methods to support (default is all methods).
  Future<void> initialize({List<DigitEasyPayPaymentSource> paymentSources = DigitEasyPayPaymentSource.values}) async {
    assert(() {
      if (paymentSources.isEmpty) {
        throw DigitEasyPayException('paymentSources cannot be null or empty');
      }
      return true;
    }());
    _paymentSources = paymentSources;
    _initialized = true;
  }

  /// Initiate the payment checkout process.
  ///
  /// @param context The build context for the payment checkout.
  /// @param amount The payment amount.
  /// @param currency The currency to use for the payment (default is XOF).
  /// @param theme The payment theme (optional).
  /// @param l10n The localization settings for the payment (optional).
  Future<void> checkout(BuildContext context, {required num amount, DigitEasyPayCurrency currency = DigitEasyPayCurrency.XOF, PaymentTheme? theme, L10n l10n = const L10nFr() , VoidCallback? onCancel, DigitEasyPayCallback? onSuccess}) async {
    if (amount <= 0) {
      throw InvalidAmountException(amount);
    }
    _validateInitialized();

    await _checkout(context, amount: amount, currency: currency, theme: theme, l10n: l10n, onCancel: onCancel, onSuccess: onSuccess);
  }

  Future<void> _checkout(BuildContext context, {required num amount, DigitEasyPayCurrency currency = DigitEasyPayCurrency.XOF, PaymentTheme? theme, required L10n l10n, VoidCallback? onCancel, DigitEasyPayCallback? onSuccess}) async {
    _externalCheckout ??=  DigitEasyPayExternalCheckout(context: context, paymentSources: _paymentSources,config: config, amount: amount, currency: currency, theme: theme, l10n: l10n, onCancel:onCancel , onSuccess: onSuccess);
    _externalCheckout?.init();
  }

  Future<dynamic> addExternalTransaction(Map<String, dynamic> data) async {
    assert(config.digitEasyPayConfig!=null);
    try{
      var provider = PaymentService(config.digitEasyPayConfig!);
      return await provider.addExternalTransaction(data);
    }catch(e, _){
      debugPrint(e.toString());
      if(e is DioException)debugPrint(e.response?.data.toString());
      debugPrintStack(stackTrace: _);
      return null;
    }
  }

  /// Dispose of the DigitEasyPay instance.
  void dispose() {
    _initialized = false;
  }

  // Helper method to validate if the SDK is initialized.
  _validateInitialized() {
    if (!_initialized) {
      throw DigitEasyPayNotInitializedException('DigitEasyPay has not been initialized. The SDK has to be initialized before use');
    }

    if(_paymentSources.contains(DigitEasyPayPaymentSource.FEDAPAY) && config.fedapayConfig==null){
      throw DigitEasyPayNotInitializedException('${DigitEasyPayPaymentSource.FEDAPAY} config not found');
    }

    if(_paymentSources.contains(DigitEasyPayPaymentSource.PAYPAL) && config.payPalConfig==null){
      throw DigitEasyPayNotInitializedException('${DigitEasyPayPaymentSource.PAYPAL} config not found');
    }

    if(_paymentSources.contains(DigitEasyPayPaymentSource.QOSIC) && config.digitEasyPayConfig==null){
      throw DigitEasyPayNotInitializedException('DigitEasyPay config not found');
    }

    if(_paymentSources.contains(DigitEasyPayPaymentSource.STRIPE) && config.stripeConfig==null){
      throw DigitEasyPayNotInitializedException('${DigitEasyPayPaymentSource.STRIPE} config not found');
    }
  }
}
