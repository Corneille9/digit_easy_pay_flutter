import 'dart:async';

import 'package:digit_easy_pay_flutter/src/http/payment_service.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/payment_result.dart';
import 'package:digit_easy_pay_flutter/src/providers/base_payment_provider.dart';
import 'package:digit_easy_pay_flutter/src/ui/views/qosic_checkout_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/payment_constants.dart';
import '../models/mobile_pay_response.dart';
import '../models/payment_config.dart';
import '../models/payment_request.dart';
import '../ui/views/qosic_card_checkout_view.dart';

/// A payment provider that handles Qosic payment gateway transactions.
///
/// This provider supports both mobile money and card payments through the Qosic
/// payment gateway. It manages the payment flow, status checking, and result handling.
class QosicCheckoutProvider extends BasePaymentProvider {
  /// Configuration for the payment process.
  ///
  /// Contains settings like API keys, environment configuration, and UI theme.
  final PaymentConfig paymentConfig;

  /// The payment request details.
  ///
  /// Contains information about the payment such as amount, currency, and description.
  final PaymentRequest request;

  /// The specific Qosic payment gateway to use.
  ///
  /// Determines which payment method will be used (e.g., MTN Mobile Money, Orange Money).
  final QosicPaymentGateway gateway;

  /// Creates a new Qosic payment provider.
  ///
  /// Requires payment configuration, payment request details, and the specific
  /// gateway to be used for processing the payment.
  ///
  /// [paymentConfig] The configuration for the payment process.
  /// [request] The payment request details.
  /// [gateway] The specific Qosic payment gateway to use.
  QosicCheckoutProvider({
    required this.paymentConfig,
    required this.request,
    required this.gateway,
  });

  /// Creates a failed payment result and updates the provider status.
  ///
  /// [errorMessage] Optional error message to include in the result.
  ///
  /// Returns a PaymentResult object with success set to false.
  PaymentResult _createErrorResult({String? errorMessage}) {
    setStatus(RequestStatus.error);
    return PaymentResult(gateway: PaymentGateway.QOSIC, success: false, message: errorMessage);
  }

  /// Initiates the payment process using the Qosic checkout flow.
  ///
  /// This method opens the Qosic checkout view and handles the payment flow.
  /// It prevents multiple concurrent payment attempts and manages the payment state.
  ///
  /// [context] The BuildContext required to show the checkout UI.
  ///
  /// Returns a Future<PaymentResult> indicating the outcome of the payment attempt.
  @override
  Future<PaymentResult> pay({required BuildContext context}) async {
    try {
      if (isLoading || isProcessing) {
        debugPrint("Payment already in progress");
        return _createErrorResult();
      }

      final Completer<PaymentResult> completer = Completer<PaymentResult>();

      setStatus(RequestStatus.processing);

      await QosicCheckoutView.open(
        context: context,
        paymentRequest: request,
        gateway: gateway,
      ).then(
        (value) {
          setStatus(value?.success == true ? RequestStatus.success : RequestStatus.error);

          if (value == null) {
            completer.completeError(_createErrorResult());
          }

          completer.complete(value);
        },
        onError: (error) {
          debugPrint("Qosic checkout error: $error");
          setStatus(RequestStatus.error);
          completer.completeError(_createErrorResult());
        },
      );

      return completer.future;
    } catch (e) {
      setStatus(RequestStatus.error);
      return _createErrorResult();
    }
  }

  /// Processes a mobile payment through the Qosic gateway.
  ///
  /// This method sends a mobile payment request to the Qosic API and monitors
  /// the transaction status until completion.
  ///
  /// [service] The payment service to use for API communication.
  /// [request] The mobile payment request details.
  ///
  /// Returns a Future<PaymentResult> indicating the outcome of the payment attempt.
  Future<PaymentResult> makeMobilePayment({
    required PaymentService service,
    required MobilePayRequest request,
  }) async {
    try {
      MobilePayResponse response = await service.makeMobilePayment(gateway, request);

      return _checkPaymentStatus(id: response.transferRef, service: service);
    } catch (e) {
      debugPrint("Error making mobile payment: $e");
      String? errorMessage;
      if (e is DioException) {
        debugPrint(e.response?.data.toString());
        errorMessage = e.response?.data["errorMessage"]?.toString();
      }
      return _createErrorResult(errorMessage: errorMessage);
    }
  }

  /// Processes a card payment through the Qosic gateway.
  ///
  /// This method sends a card payment request to the Qosic API, opens a web checkout
  /// for the user to enter card details, and monitors the transaction status until completion.
  ///
  /// [context] The BuildContext required to show the card checkout UI.
  /// [service] The payment service to use for API communication.
  /// [request] The card payment request details.
  ///
  /// Returns a Future<PaymentResult> indicating the outcome of the payment attempt.
  Future<PaymentResult> makeCardPayment({
    required BuildContext context,
    required PaymentService service,
    required CardPayRequest request,
  }) async {
    try {
      CardPayResponse response = await service.makeCardPayment(request);

      var success = await _launchQosicCardCheckout(context, response.url);

      if (success != true) {
        return _createErrorResult();
      }

      return _checkPaymentStatus(id: response.reference, service: service);
    } catch (e) {
      String? errorMessage;
      if (e is DioException) {
        debugPrint(e.response?.data?.toString());
        errorMessage = e.response?.data?["errorMessage"]?.toString();
      }
      return _createErrorResult(errorMessage: errorMessage);
    }
  }

  /// Launches the Qosic card checkout view.
  ///
  /// Opens a web view that allows the user to enter their card details securely.
  ///
  /// [context] The BuildContext required to show the checkout UI.
  /// [url] The URL of the Qosic card payment page.
  ///
  /// Returns a Future<bool?> indicating whether the payment was successful (true),
  /// cancelled (false), or encountered an error (null).
  Future<bool?> _launchQosicCardCheckout(BuildContext context, String url) async {
    return await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return QosicCardCheckoutView(
            theme: paymentConfig.theme,
            l10n: paymentConfig.lang,
            checkoutUrl: url,
          );
        },
      ),
    );
  }

  /// Monitors the status of a payment transaction until completion.
  ///
  /// This method polls the transaction status at regular intervals until
  /// the transaction is no longer pending.
  ///
  /// [id] The transaction reference ID to check.
  /// [service] The payment service to use for API communication.
  ///
  /// Returns a Future<PaymentResult> indicating the final outcome of the payment.
  Future<PaymentResult> _checkPaymentStatus({
    required String id,
    required PaymentService service,
  }) async {
    Timer? timer;
    try {
      final Completer<PaymentResult> completer = Completer<PaymentResult>();

      timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        var status = await getTransactionStatus(id: id, service: service);
        debugPrint("Qosic payment status: $status");
        if (status != TransactionStatus.PENDING) {
          completer.complete(
            PaymentResult(
              gateway: PaymentGateway.QOSIC,
              gatewayMethod: gateway.name,
              success: status == TransactionStatus.SUCCESSFUL,
              reference: id,
            ),
          );
          timer.cancel();
          return;
        }

        if (timer.tick >= 24) {
          completer.completeError(_createErrorResult());
          timer.cancel();
        }
      });

      return completer.future;
    } catch (e, s) {
      debugPrint("Error checking payment status: $e");
      debugPrintStack(stackTrace: s);
      timer?.cancel();

      return _createErrorResult();
    }
  }

  /// Retrieves the current status of a transaction.
  ///
  /// Makes an API call to check the current status of a payment transaction.
  ///
  /// [id] The transaction reference ID to check.
  /// [service] The payment service to use for API communication.
  ///
  /// Returns a Future<TransactionStatus?> representing the current status of the transaction,
  /// or null if the status check failed.
  Future<TransactionStatus?> getTransactionStatus({
    required String id,
    required PaymentService service,
  }) async {
    try {
      return await service.checkTransactionStatus(id);
    } catch (e, s) {
      debugPrint("Error checking payment status: $e");
      debugPrintStack(stackTrace: s);
      return null;
    }
  }
}
