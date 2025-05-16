import 'dart:async';

import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/models/payment_result.dart';
import 'package:digit_easy_pay_flutter/src/providers/base_payment_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../common/payment_constants.dart';
import '../common/payment_validator.dart';

/// A payment provider that handles Stripe payments
class StripePaymentProvider extends BasePaymentProvider {
  /// Configuration for the payment
  final PaymentConfig paymentConfig;

  /// The payment request details
  final PaymentRequest request;

  /// The base currency for Stripe transactions
  Currency baseCurrency = Currency.EUR;

  /// The amount after currency conversion (if needed)
  num? convertedAmount;

  /// HTTP client for API requests
  late final Dio _httpClient;

  /// Creates a new Stripe payment provider
  StripePaymentProvider({required this.paymentConfig, required this.request}) {
    _httpClient = Dio(
      BaseOptions(
        headers: {
          'Authorization': 'Bearer ${config.stripePrivateKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
  }

  /// Gets the currency converter credentials from payment config
  Credentials get converterCredentials => paymentConfig.currencyConverterCredentials;

  /// Gets the amount from the payment request
  num get amount => request.amount;

  /// Gets the currency from the payment request
  Currency get currency => request.currency;

  /// Gets the Stripe configuration from payment config
  StripeConfig get config => paymentConfig.stripeConfig!;

  /// Gets the payment theme from payment config
  PaymentTheme get theme => paymentConfig.theme;

  @override
  Future<void> init() async {
    // Only use XOF, USD, or EUR as base currencies
    if ([Currency.XOF, Currency.USD, Currency.EUR].contains(currency)) {
      baseCurrency = currency;
    }
  }

  /// Creates a failed payment result and updates status
  PaymentResult _createErrorResult() {
    setStatus(RequestStatus.error);
    return PaymentResult(gateway: PaymentGateway.STRIPE, success: false);
  }

  /// Creates a successful payment result and updates status
  PaymentResult _createSuccessResult(String reference) {
    setStatus(RequestStatus.success);
    return PaymentResult(
      gateway: PaymentGateway.STRIPE,
      reference: reference,
      gatewayMethod: 'visa_card',
      success: true,
    );
  }

  @override
  Future<PaymentResult> pay({required BuildContext context}) async {
    try {
      if (isLoading || isProcessing) {
        debugPrint("Payment already in progress");
        return _createErrorResult();
      }

      debugPrint("Stripe payment initializing...");
      setStatus(RequestStatus.loading);

      // Initialize Stripe and get payment intent ID
      final referenceId = await _initStripe();
      if (referenceId == null) {
        debugPrint("Failed to initialize Stripe payment");
        return _createErrorResult();
      }

      setStatus(RequestStatus.processing);

      // Process the payment with the payment intent
      return await _processPayment(referenceId: referenceId);
    } catch (e, s) {
      debugPrint("Stripe payment error: $e");

      if (e is StripeConfigException) {
        debugPrint("Stripe config error: ${e.message}");
      } else if (e is DioException) {
        debugPrint("API error: ${e.response?.data}");
      }

      debugPrintStack(stackTrace: s);
      return _createErrorResult();
    }
  }

  /// Initializes Stripe payment sheet and returns the payment intent ID
  Future<String?> _initStripe() async {
    // Create payment intent
    final paymentIntent = await _createPaymentIntent(amount);
    if (paymentIntent == null) {
      debugPrint("Failed to create payment intent");
      return null;
    }

    // Set Stripe publishable key
    Stripe.publishableKey = config.stripePublishableKey;

    // Initialize payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        appearance: _createPaymentSheetAppearance(),
        paymentIntentClientSecret: paymentIntent['client_secret'],
        style: theme.isLight ? ThemeMode.light : ThemeMode.dark,
        merchantDisplayName: config.merchantDisplayName,
        // Uncomment to enable Google Pay
        // googlePay: PaymentSheetGooglePay(
        //   testEnv: true,
        //   currencyCode: currency.name,
        //   merchantCountryCode: config.merchantCountryCode
        // ),
        // Uncomment to enable Apple Pay
        // applePay: PaymentSheetApplePay(
        //   merchantCountryCode: config.merchantCountryCode,
        // ),
      ),
    );

    return paymentIntent['id'];
  }

  /// Creates the appearance configuration for the payment sheet
  PaymentSheetAppearance _createPaymentSheetAppearance() {
    return PaymentSheetAppearance(
      shapes: const PaymentSheetShape(borderRadius: 20),
      primaryButton: PaymentSheetPrimaryButtonAppearance(
        colors: PaymentSheetPrimaryButtonTheme(
          dark: PaymentSheetPrimaryButtonThemeColors(background: theme.primaryColor),
          light: PaymentSheetPrimaryButtonThemeColors(background: theme.primaryColor),
        ),
      ),
    );
  }

  /// Presents the payment sheet and processes the payment
  Future<PaymentResult> _processPayment({required String referenceId}) async {
    final completer = Completer<PaymentResult>();

    try {
      await Stripe.instance.presentPaymentSheet();
      completer.complete(_createSuccessResult(referenceId));
    } catch (error, stackTrace) {
      debugPrint("Stripe payment sheet error: $error");
      debugPrintStack(stackTrace: stackTrace);
      completer.complete(_createErrorResult());
    }

    return completer.future;
  }

  /// Creates a payment intent with the Stripe API
  Future<Map<String, dynamic>?> _createPaymentIntent(num amount) async {
    try {
      // Convert currency if needed
      await _convertCurrencyIfNeeded(amount);

      if (convertedAmount == null) {
        debugPrint("Currency conversion failed");
        return null;
      }

      // Format amount based on currency
      _formatAmountForCurrency();

      // Prepare request body
      final body = {
        'amount': convertedAmount,
        'currency': baseCurrency.name.toLowerCase(),
        // 'payment_method_types[]': 'card'
      };

      // Make API request
      final response = await _httpClient.post(config.stripeApiUrl, queryParameters: body);

      debugPrint("Stripe payment intent created: ${response.data}");
      return response.data;
    } catch (err, stacktrace) {
      _handlePaymentIntentError(err, stacktrace);
      return null;
    }
  }

  /// Converts the amount to the base currency if needed
  Future<void> _convertCurrencyIfNeeded(num originalAmount) async {
    if (currency.name.toLowerCase() != baseCurrency.name.toLowerCase()) {
      convertedAmount = await PaymentUtils.convertAmount(
        originalAmount,
        converterCredentials,
        from: currency.name.toUpperCase(),
        to: baseCurrency.name.toUpperCase(),
      );
    } else {
      convertedAmount = originalAmount;
    }
  }

  /// Formats the amount according to the currency requirements
  void _formatAmountForCurrency() {
    if (baseCurrency == Currency.XOF) {
      // XOF doesn't use cents, so round to whole number
      convertedAmount = convertedAmount!.round();
    } else {
      // Most currencies need amount in cents (multiply by 100)
      convertedAmount = (convertedAmount! * 100).round();
    }
  }

  /// Handles errors during payment intent creation
  void _handlePaymentIntentError(Object err, StackTrace stacktrace) {
    debugPrint("Stripe payment intent error: $err");

    if (err is StripeConfigException) {
      debugPrint("Stripe config error: ${err.message}");
    } else if (err is DioException) {
      debugPrint("API error: ${err.response?.data}");
    }

    debugPrintStack(stackTrace: stacktrace);
  }
}
