import 'package:digit_currency_converter/digit_currency_converter.dart';
import 'package:digit_easy_pay_flutter/src/models/gateways/fedapay_config.dart';
import 'package:digit_easy_pay_flutter/src/models/gateways/paypal_config.dart';

import '../common/payment_constants.dart';
import '../common/payment_l10n.dart';
import '../common/payment_theme.dart';
import 'gateways/qosic_config.dart';
import 'gateways/payment_gateway_config.dart';
import 'gateways/stripe_config.dart';

class PaymentConfig {
  final PaymentTheme theme;
  final L10n lang;
  final List<PaymentGateway> gateways;
  final Credentials currencyConverterCredentials;
  final PaymentGatewayConfig gatewayConfig;

  PaymentConfig({
    PaymentTheme? theme,
    this.lang = const L10nFr(),
    this.gateways = PaymentGateway.values,
    required this.currencyConverterCredentials,
    required this.gatewayConfig,
  }) : theme = theme ?? DefaultPaymentTheme(),
       assert(gateways.isNotEmpty);

  FedapayConfig? get fedapayConfig => gatewayConfig.fedapayConfig;

  PayPalConfig? get payPalConfig => gatewayConfig.payPalConfig;

  QosicConfig? get qosicConfig => gatewayConfig.qosicConfig;

  StripeConfig? get stripeConfig => gatewayConfig.stripeConfig;

  List<PaymentGateway> get availableGateways => gatewayConfig.availableGateways;
}
