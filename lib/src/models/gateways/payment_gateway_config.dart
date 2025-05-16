import '../../common/payment_constants.dart';
import 'gateways.dart';

class PaymentGatewayConfig {
  final QosicConfig? qosicConfig;
  final PayPalConfig? payPalConfig;
  final StripeConfig? stripeConfig;
  final FedapayConfig? fedapayConfig;

  // must have one config min
  PaymentGatewayConfig({
    this.qosicConfig,
    this.payPalConfig,
    this.stripeConfig,
    this.fedapayConfig,
  }): assert(qosicConfig != null || payPalConfig != null || stripeConfig != null || fedapayConfig != null);

  List<PaymentGateway> get availableGateways => [
    if (qosicConfig != null) PaymentGateway.QOSIC,
    if (payPalConfig != null) PaymentGateway.PAYPAL,
    if (stripeConfig != null) PaymentGateway.STRIPE,
    if (fedapayConfig != null) PaymentGateway.FEDAPAY,
  ];
}
