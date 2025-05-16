import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';

class PaymentResult {
  final String? reference;
  final bool success;
  final String? message;
  final PaymentGateway gateway;
  final String? gatewayMethod;

  PaymentResult({
    this.reference,
    this.success = false,
    this.message,
    required this.gateway,
    this.gatewayMethod,
  });

  @override
  String toString() {
    return 'PaymentResult{reference: $reference, success: $success, message: $message, gateway: $gateway, gatewayMethod: $gatewayMethod}';
  }
}
