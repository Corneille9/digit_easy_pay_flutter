import 'package:digit_easy_pay_flutter/src/providers/paypal_payment_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/qosic_payment_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/stripe_payment_provider.dart';
import 'package:flutter/cupertino.dart';

import '../common/base_state_provider.dart';
import '../common/exceptions.dart';
import '../common/payment_constants.dart';
import '../models/payment_config.dart';
import '../models/payment_request.dart';
import '../models/payment_result.dart';
import 'fedapay_payment_provider.dart';

abstract class BasePaymentProvider extends BaseStateProvider {
  BasePaymentProvider();

  Future<void> init() async {}

  Future<PaymentResult> pay({required BuildContext context});

  static BasePaymentProvider of({
    required PaymentGateway gateway,
    required PaymentConfig config,
    required PaymentRequest request,
  }) {
    switch (gateway) {
      case PaymentGateway.FEDAPAY:
        return FedapayPaymentProvider(paymentConfig: config, request: request);
      case PaymentGateway.PAYPAL:
        return PaypalPaymentProvider(paymentConfig: config, request: request);
      case PaymentGateway.STRIPE:
        return StripePaymentProvider(paymentConfig: config, request: request);
      case PaymentGateway.QOSIC:
        return QosicPaymentProvider(paymentConfig: config, request: request);
      default:
        throw DigitEasyPayException("Unknown payment gateway $gateway");
    }
  }
}
