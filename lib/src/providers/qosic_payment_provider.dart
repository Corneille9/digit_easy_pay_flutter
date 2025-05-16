import 'dart:async';

import 'package:digit_easy_pay_flutter/src/models/payment_result.dart';
import 'package:digit_easy_pay_flutter/src/providers/base_payment_provider.dart';
import 'package:flutter/material.dart';

import '../common/payment_constants.dart';
import '../models/payment_config.dart';
import '../models/payment_request.dart';
import '../ui/views/qosic_payment_view_.dart';

class QosicPaymentProvider extends BasePaymentProvider {
  /// Configuration for the payment
  final PaymentConfig paymentConfig;

  /// The payment request details
  final PaymentRequest request;

  /// Creates a new PayPal payment provider
  QosicPaymentProvider({required this.paymentConfig, required this.request});

  /// Creates a failed payment result and updates status
  PaymentResult _createErrorResult() {
    setStatus(RequestStatus.error);
    return PaymentResult(gateway: PaymentGateway.QOSIC, success: false);
  }

  @override
  Future<PaymentResult> pay({required BuildContext context}) async {
    try {
      if (isLoading || isProcessing) {
        debugPrint("Payment already in progress");
        return _createErrorResult();
      }
      final Completer<PaymentResult> completer = Completer<PaymentResult>();

      setStatus(RequestStatus.processing);

      await QosicPaymentView.open(context: context, paymentRequest: request).then(
        (value) {
          setStatus(value?.success == true ? RequestStatus.success : RequestStatus.error);

          if (value == null) {
            completer.completeError(_createErrorResult());
          }

          completer.complete(value);
        },
        onError: (error) {
          debugPrint("Qosic payment error: $error");
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
}
