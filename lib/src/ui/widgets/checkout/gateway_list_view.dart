import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';

import '../../../common/payment_constants.dart';
import '../../../common/payment_validator.dart';

class GatewayListView extends StatelessWidget {
  const GatewayListView({
    super.key,
    this.onGatewaySelected,
    required this.paymentRequest,
    this.disableGateways = false,
  });

  final Function(PaymentGateway gateway)? onGatewaySelected;

  final PaymentRequest paymentRequest;

  final bool disableGateways;

  PaymentConfig get config => DigitEasyPayFlutter.config;

  List<PaymentGateway> get gateways => config.availableGateways;

  PaymentTheme get theme => config.theme;

  L10n get l10n => config.lang;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${l10n.pay}: ${PaymentUtils.formatAmount(paymentRequest.amount, paymentRequest.currency)}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(l10n.selectYourPreferredPaymentMethod, style: TextStyle(fontSize: 12)),
          SizedBox(height: 30),

          if (gateways.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Center(child: Text(l10n.noPaymentMethod)),
            ),

          ...gateways.map((gateway) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InkWell(
                onTap:
                    disableGateways
                        ? null
                        : () {
                          onGatewaySelected?.call(gateway);
                        },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.textColor.withOpacity(.1)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(gateway.icon, package: "digit_easy_pay_flutter", height: 50),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gateway.displayName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(gateway.description, style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
