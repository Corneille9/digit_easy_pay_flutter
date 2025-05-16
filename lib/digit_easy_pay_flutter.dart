/// DigitEasyPayFlutter - A comprehensive payment processing library for Flutter applications.
///
/// This library provides a unified interface for integrating multiple payment gateways
/// into Flutter applications. It supports various payment methods and gateways with
/// a consistent API, making it easy to offer multiple payment options to users.
///
/// Basic usage:
/// ```dart
/// // Initialize the library with configuration
/// DigitEasyPayFlutter.setConfig(PaymentConfig(...));
///
/// // Process a payment
/// final response = await DigitEasyPayFlutter.checkout(
///   context: context,
///   paymentRequest: PaymentRequest(...),
/// );
///
/// // Handle the payment response
/// if (response != null) {
///   // Payment was successful
///   print('Payment reference: ${response.reference}');
/// }
/// ```
library;

import 'package:digit_easy_pay_flutter/src/http/payment_service.dart';
import 'package:digit_easy_pay_flutter/src/models/payment_config.dart';
import 'package:digit_easy_pay_flutter/src/models/payment_request.dart';
import 'package:digit_easy_pay_flutter/src/models/payment_response.dart';
import 'package:digit_easy_pay_flutter/src/ui/views/checkout_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// Currency converter library (excluding Currency to avoid conflicts)
export 'package:digit_currency_converter/digit_currency_converter.dart' hide Currency;
/// Configuration classes and utilities
export 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
/// Exception classes for error handling
export 'package:digit_easy_pay_flutter/src/common/exceptions.dart';
/// Payment constants including enums for currencies and payment gateways
export 'package:digit_easy_pay_flutter/src/common/payment_constants.dart' show QosicPaymentGateway, Currency;
/// Localization support for payment UI
export 'package:digit_easy_pay_flutter/src/common/payment_l10n.dart';
/// Theming support for payment UI
export 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
/// Payment gateway configurations
export 'package:digit_easy_pay_flutter/src/models/gateways/gateways.dart';
/// Payment configuration model
export 'package:digit_easy_pay_flutter/src/models/payment_config.dart';
/// Payment request model
export 'package:digit_easy_pay_flutter/src/models/payment_request.dart';

/// Main entry point for the DigitEasyPayFlutter library.
///
/// This abstract class provides static methods to configure the library
/// and process payments. It serves as the primary interface for interacting
/// with the payment processing functionality.
abstract class DigitEasyPayFlutter {
  /// Internal storage for the library configuration.
  ///
  /// This is set using [setConfig] and accessed via the [config] getter.
  static PaymentConfig? _config;

  /// Gets the current payment configuration.
  ///
  /// This configuration includes API keys, available payment gateways,
  /// theming options, and other settings required for payment processing.
  ///
  /// Throws an assertion error if accessed before calling [setConfig].
  static PaymentConfig get config => _config!;

  /// Configures the DigitEasyPayFlutter library with the provided settings.
  ///
  /// This method must be called before using any other functionality in the library,
  /// typically during app initialization.
  ///
  /// [config] The configuration to use for payment processing.
  static void setConfig(PaymentConfig config) {
    _config = config;
  }

  /// Initiates the payment checkout process.
  ///
  /// This method displays a checkout UI that allows the user to select a payment method
  /// and complete the payment. If only one payment gateway is configured, it will
  /// automatically use that gateway without showing the selection UI.
  ///
  /// The method returns a [PaymentResponse] if the payment was successful, or null
  /// if the payment was cancelled or failed.
  ///
  ///
  /// [context] The BuildContext required to show the checkout UI.
  /// [paymentRequest] The details of the payment to be processed.
  ///
  /// Returns a Future that resolves to a [PaymentResponse] if the payment was successful,
  /// or null if the payment was cancelled or failed.
  static Future<PaymentResponse?> checkout({
    required BuildContext context,
    required PaymentRequest paymentRequest,
  }) async {
    assert(
      _config != null,
      "Please call DigitEasyPayFlutter.setConfig() before using DigitEasyPayFlutter.checkout()",
    );
    return await CheckoutView.open(context: context, paymentRequest: paymentRequest);
  }

  /// Used to save external transactions(stripe, paypal, fedapay) in digit easy pay backend
  Future<dynamic> notifyExternalTransaction(Map<String, dynamic> data) async {
    try {
      assert(
      _config != null,
      "Please call DigitEasyPayFlutter.setConfig() before using DigitEasyPayFlutter.checkout()",
      );
      return await PaymentService(config.qosicConfig!).addExternalTransaction(data);
    } catch (e, s) {
      debugPrint(e.toString());
      if (e is DioException) debugPrint(e.response?.data.toString());
      debugPrintStack(stackTrace: s);
      return null;
    }
  }
}
