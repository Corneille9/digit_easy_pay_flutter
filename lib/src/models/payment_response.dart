import '../common/payment_constants.dart';

class PaymentResponse {
  final num amount;
  final Currency currency;
  final String reference;
  final PaymentGateway gateway;
  final String? gatewayMethod;

  PaymentResponse({
    required this.amount,
    required this.currency,
    required this.reference,
    required this.gateway,
    this.gatewayMethod,
  });
}
