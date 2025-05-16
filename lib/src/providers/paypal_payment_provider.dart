import 'dart:async';

import 'package:digit_easy_pay_flutter/src/lib/flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:digit_easy_pay_flutter/src/models/payment_result.dart';
import 'package:digit_easy_pay_flutter/src/providers/base_payment_provider.dart';
import 'package:flutter/material.dart';

import '../../digit_easy_pay_flutter.dart';
import '../common/payment_validator.dart';
import '../common/payment_constants.dart';

/// A payment provider that handles PayPal payments
class PaypalPaymentProvider extends BasePaymentProvider {
  /// Configuration for the payment
  final PaymentConfig paymentConfig;

  /// The payment request details
  final PaymentRequest request;

  /// The base currency for PayPal transactions
  Currency baseCurrency = Currency.EUR;

  /// The amount after currency conversion (if needed)
  num? convertedAmount;

  /// Creates a new PayPal payment provider
  PaypalPaymentProvider({required this.paymentConfig, required this.request});

  /// Gets the currency converter credentials from payment config
  Credentials get converterCredentials => paymentConfig.currencyConverterCredentials;

  /// Gets the amount from the payment request
  num get amount => request.amount;

  /// Gets the currency from the payment request
  Currency get currency => request.currency;

  /// Gets the PayPal configuration from payment config
  PayPalConfig get config => paymentConfig.payPalConfig!;

  /// Gets the payment theme from payment config
  PaymentTheme get theme => paymentConfig.theme;

  @override
  Future<void> init() async {
    // Only use USD, EUR as base currencies for PayPal
    if ([Currency.USD, Currency.EUR].contains(currency)) {
      baseCurrency = currency;
    }
    // Otherwise, default to EUR as set in the constructor
  }

  /// Creates a failed payment result and updates status
  PaymentResult _createErrorResult() {
    setStatus(RequestStatus.error);
    return PaymentResult(gateway: PaymentGateway.PAYPAL, success: false);
  }

  /// Creates a successful payment result and updates status
  PaymentResult _createSuccessResult(String reference) {
    setStatus(RequestStatus.success);
    return PaymentResult(
      gateway: PaymentGateway.PAYPAL,
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

      debugPrint("PayPal payment initializing...");
      setStatus(RequestStatus.loading);

      // Convert currency if needed
      await _convertCurrencyIfNeeded();

      if (convertedAmount == null) {
        debugPrint("Currency conversion failed");
        return _createErrorResult();
      }

      // Wait for the payment to complete
      return await _launchPayPalCheckout(context);
    } catch (e, s) {
      debugPrint("PayPal payment error: $e");
      debugPrintStack(stackTrace: s);

      return _createErrorResult();
    }
  }

  /// Converts the amount to the base currency if needed
  Future<void> _convertCurrencyIfNeeded() async {
    if (currency.name.toLowerCase() != baseCurrency.name.toLowerCase()) {
      convertedAmount = await PaymentUtils.convertAmount(
        amount,
        converterCredentials,
        from: currency.name.toUpperCase(),
        to: baseCurrency.name.toUpperCase(),
      );
    } else {
      convertedAmount = amount;
    }
  }

  /// Launches the PayPal checkout view
  Future<PaymentResult> _launchPayPalCheckout(BuildContext context) async {
    try {
      final formattedAmount = convertedAmount!.toStringAsFixed(2);

      var result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (BuildContext context) => PaypalCheckoutView(
                paymentConfig: paymentConfig,
                sandboxMode: config.sandbox,
                clientId: config.clientId,
                secretKey: config.clientSecret,
                transactions: [
                  {
                    "amount": {
                      "total": formattedAmount,
                      "currency": baseCurrency.name,
                      "details": {
                        "subtotal": formattedAmount,
                        "shipping": '0',
                        "shipping_discount": 0,
                      },
                    },
                    "description": "Payment transaction",
                    "item_list": {
                      "items": [
                        {
                          "name": "Digit Pay",
                          "quantity": 1,
                          "price": formattedAmount,
                          "currency": baseCurrency.name,
                        },
                      ],
                    },
                  },
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  debugPrint("PayPal payment successful: $params");
                  // Pop the PayPal view
                  Navigator.pop(context, params);
                },
                onError: (error) {
                  debugPrint("PayPal payment error: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  debugPrint('PayPal payment cancelled');
                  Navigator.pop(context);
                },
              ),
        ),
      );

      if (result is! Map) {
        return _createErrorResult();
      }

      var id = _extractTransactionId(result);

      if (id == null) {
        debugPrint("Error extracting transaction ID");
        return _createErrorResult();
      }

      return _createSuccessResult(id);
    } catch (e, s) {
      debugPrint("PayPal payment error: $e");
      debugPrintStack(stackTrace: s);
      return _createErrorResult();
    }
  }

  /// Extracts the transaction ID from the PayPal response
  String? _extractTransactionId(Map params) {
    try {
      // Try to extract transaction ID from different possible locations in the response
      if (params.containsKey('paymentId')) {
        return params['paymentId'];
      } else if (params.containsKey('data') &&
          params['data'] is Map &&
          params['data'].containsKey('id')) {
        return params['data']['id'];
      } else if (params.containsKey('response') &&
          params['response'] is Map &&
          params['response'].containsKey('id')) {
        return params['response']['id'];
      }

      // If we can't find a specific ID, convert the whole response to a string
      return params.toString();
    } catch (e) {
      debugPrint("Error extracting transaction ID: $e");
      return null;
    }
  }
}
