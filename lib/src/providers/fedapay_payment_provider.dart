import 'dart:async';

import 'package:digit_easy_pay_flutter/src/models/payment_result.dart';
import 'package:digit_easy_pay_flutter/src/providers/base_payment_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../digit_easy_pay_flutter.dart';
import '../common/payment_validator.dart';
import '../ui/views/fedapay_checkout_view.dart';
import '../common/payment_constants.dart';


/// Enum representing the possible transaction statuses for FedaPay
enum FedapayTransactionStatus { pending, approved, canceled, declined }

/// A payment provider that handles FedaPay payments
class FedapayPaymentProvider extends BasePaymentProvider {
  /// Configuration for the payment
  final PaymentConfig paymentConfig;

  /// The payment request details
  final PaymentRequest request;

  /// The base currency for FedaPay transactions
  Currency baseCurrency = Currency.XOF;

  /// The amount after currency conversion (if needed)
  num? convertedAmount;

  /// HTTP client for API requests
  late final Dio _httpClient;

  /// Creates a new FedaPay payment provider
  FedapayPaymentProvider({required this.paymentConfig, required this.request}) {
    _httpClient = Dio(BaseOptions(headers: {"Authorization": "Bearer ${config.apiKey}"}));
  }

  /// Gets the currency converter credentials from payment config
  Credentials get converterCredentials => paymentConfig.currencyConverterCredentials;

  /// Gets the amount from the payment request
  num get amount => request.amount;

  /// Gets the currency from the payment request
  Currency get currency => request.currency;

  /// Gets the FedaPay configuration from payment config
  FedapayConfig get config => paymentConfig.fedapayConfig!;

  /// Gets the payment theme from payment config
  PaymentTheme get theme => paymentConfig.theme;

  /// Gets the localization from payment config
  L10n get l10n => paymentConfig.lang;

  /// Gets the API base URL based on sandbox mode
  String get apiBase =>
      !config.sandbox ? "https://api.fedapay.com/v1" : "https://sandbox-api.fedapay.com/v1";

  @override
  Future<void> init() async {
    // FedaPay primarily supports XOF
    if (currency == Currency.XOF) {
      baseCurrency = currency;
    }
    // Otherwise, we'll need to convert to XOF
  }

  /// Creates a failed payment result and updates status
  PaymentResult _createErrorResult() {
    setStatus(RequestStatus.error);
    return PaymentResult(gateway: PaymentGateway.FEDAPAY, success: false);
  }

  /// Creates a successful payment result and updates status
  PaymentResult _createSuccessResult(String reference, String method) {
    setStatus(RequestStatus.success);
    return PaymentResult(
      gateway: PaymentGateway.FEDAPAY,
      reference: reference,
      gatewayMethod: method,
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

      debugPrint("FedaPay payment initializing...");
      setStatus(RequestStatus.loading);

      // Convert currency if needed
      await _convertCurrencyIfNeeded();

      if (convertedAmount == null) {
        debugPrint("Currency conversion failed");
        return _createErrorResult();
      }

      // Initialize the transaction
      var transaction = await _createTransaction();

      // Set processing status before launching checkout
      setStatus(RequestStatus.processing);

      // Launch the FedaPay checkout view
      var success = await _launchFedaPayCheckout(context, transaction["url"]);

      if (success != true) {
        return _createErrorResult();
      }

      // Get updated transaction details after payment
      transaction = await _getTransaction(transaction["id"]);
      var transactionStatus = await _getTransactionStatus(transaction);

      if (transactionStatus != FedapayTransactionStatus.approved) {
        return _createErrorResult();
      }

      return _createSuccessResult(transaction["id"].toString(), transaction["mode"] ?? "unknown");
    } catch (e, s) {
      debugPrint("FedaPay payment error: $e");
      if (e is DioException) {
        debugPrint("API error: ${e.response?.data}");
      }
      debugPrintStack(stackTrace: s);

      return _createErrorResult();
    } finally {
      // Ensure we're not left in a loading state if there's an error
      if (isLoading) {
        setStatus(RequestStatus.error);
      }
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

  /// Creates and initializes a FedaPay transaction
  Future<Map<String, dynamic>> _createTransaction() async {
    try {
      // Create transaction data
      final data = {
        'description': "Payment",
        'callback_url': "https://digit.pay.sdk.com/callback/fedapay",
        'amount': convertedAmount,
        if (config.customer != null && config.customer!.isNotEmpty) 'customer': config.customer,
        'currency': {"iso": baseCurrency.name},
      };

      // Create transaction
      var response = await _httpClient.post("$apiBase/transactions", data: data);

      var transaction = response.data["v1/transaction"];
      var transactionId = transaction["id"].toString();

      // Get transaction token
      response = await _httpClient.post("$apiBase/transactions/$transactionId/token");

      var token = response.data['token'];
      var url = response.data["url"];

      debugPrint("FedaPay transaction initialized: $transactionId");

      return {'id': transactionId, 'token': token, 'url': url};
    } catch (e, s) {
      debugPrint("FedaPay transaction initialization error: $e");
      if (e is DioException) {
        debugPrint("API error: ${e.response?.data}");
      }
      debugPrintStack(stackTrace: s);
      rethrow; // Rethrow to be caught by the pay method
    }
  }

  /// Launches the FedaPay checkout view
  Future<bool?> _launchFedaPayCheckout(BuildContext context, String url) async {
    return await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return FedapayCheckoutView(theme: theme, l10n: l10n, checkoutUrl: url);
        },
      ),
    );
  }

  /// Gets transaction details by ID
  Future<Map<String, dynamic>> _getTransaction(String id) async {
    try {
      var response = await _httpClient.get(
        "$apiBase/transactions/$id",
        options: Options(
          responseType: ResponseType.json,
          contentType: "application/json; charset=utf-8",
        ),
      );
      return response.data["v1/transaction"];
    } catch (e, s) {
      debugPrint("Error fetching transaction: $e");
      if (e is DioException) {
        debugPrint("API error: ${e.response?.data}");
      }
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  /// Gets the current transaction status
  Future<FedapayTransactionStatus> _getTransactionStatus(Map<String, dynamic> transaction) {
    return Future.value(
      FedapayTransactionStatus.values.firstWhere(
        (element) => element.name == transaction["status"],
        orElse: () => FedapayTransactionStatus.pending,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources
    _httpClient.close();
    super.dispose();
  }
}
