import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/providers/base_payment_provider.dart';
import 'package:digit_easy_pay_flutter/src/ui/widgets/checkout/gateway_list_view.dart';
import 'package:digit_easy_pay_flutter/src/ui/widgets/custom_widgets.dart';
import 'package:digit_easy_pay_flutter/src/ui/widgets/theme_widget.dart';
import 'package:flutter/material.dart';

import '../../common/payment_constants.dart';
import '../../models/payment_response.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.paymentRequest});

  final PaymentRequest paymentRequest;

  static Future<PaymentResponse?> open({
    required BuildContext context,
    required PaymentRequest paymentRequest,
  }) async {
    // Get the payment config
    final config = DigitEasyPayFlutter.config;
    final gateways = config.availableGateways;

    // If there's only one gateway, process payment directly without showing the view
    if (gateways.length == 1) {
      try {
        // Show a loading dialog while processing
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                backgroundColor: Colors.transparent,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(config.theme.primaryColor),
                    ),
                    SizedBox(height: 16),
                    Text("${config.lang.processingPayment}..."),
                  ],
                ),
              ),
        );

        await Future.delayed(Duration(seconds: 1));

        final gateway = gateways.first;
        final provider = BasePaymentProvider.of(
          gateway: gateway,
          config: config,
          request: paymentRequest,
        );

        final result = await provider.pay(context: context);

        // Close the loading dialog
        Navigator.of(context).pop();

        if (result.success) {
          return PaymentResponse(
            amount: paymentRequest.amount,
            currency: paymentRequest.currency,
            reference: result.reference!,
            gateway: result.gateway,
            gatewayMethod: result.gatewayMethod,
          );
        }

        return null;
      } catch (e, s) {
        // Close the loading dialog if it's still showing
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        debugPrint(e.toString());
        debugPrintStack(stackTrace: s);
        // Continue to show the view if direct payment fails
        return null;
      }
    }

    // Show the checkout view for multiple gateways or if direct payment failed
    return await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => CheckoutView(paymentRequest: paymentRequest)));
  }

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  PaymentRequest get paymentRequest => widget.paymentRequest;

  PaymentConfig get config => DigitEasyPayFlutter.config;

  List<PaymentGateway> get gateways => config.availableGateways;

  PaymentTheme get theme => config.theme;

  L10n get l10n => config.lang;

  String? errorMessage;
  String? successMessage;
  bool isProcessing = false;
  PaymentGateway? processingGateway;

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      theme: theme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.textColor.withAlpha(10),
          surfaceTintColor: Colors.transparent,
          leading: CustomBackButton(),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              GatewayListView(
                paymentRequest: paymentRequest,
                disableGateways: isProcessing,
                onGatewaySelected: (gateway) async {
                  // Prevent multiple payment attempts
                  if (isProcessing) {
                    return;
                  }

                  try {
                    // Set processing state
                    setState(() {
                      isProcessing = true;
                      processingGateway = gateway;
                      errorMessage = null;
                      successMessage = null;
                    });

                    await Future.delayed(Duration(seconds: 1));

                    var provider = BasePaymentProvider.of(
                      gateway: gateway,
                      config: config,
                      request: paymentRequest,
                    );

                    var result = await provider.pay(context: context);

                    if (!result.success) {
                      setState(() {
                        errorMessage = result.message ?? l10n.paymentFailed;
                        isProcessing = false;
                        processingGateway = null;
                      });
                      return;
                    }

                    setState(() {
                      successMessage = result.message ?? l10n.paymentSuccessfully;
                    });

                    await Future.delayed(Duration(seconds: 1));

                    Navigator.of(context).pop(
                      PaymentResponse(
                        amount: paymentRequest.amount,
                        currency: paymentRequest.currency,
                        reference: result.reference!,
                        gateway: result.gateway,
                        gatewayMethod: result.gatewayMethod,
                      ),
                    );
                  } catch (e, s) {
                    debugPrint(e.toString());
                    debugPrintStack(stackTrace: s);
                    setState(() {
                      errorMessage = l10n.anErrorOccur;
                      isProcessing = false;
                      processingGateway = null;
                    });
                  }
                },
              ),

              // Loading overlay when processing payment
              if (isProcessing)
                Container(
                  color: theme.backgroundColor.withOpacity(0.7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${l10n.processingPayment}...",
                          style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

              // Error and success messages
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.backgroundColor.withOpacity(.05),
                        theme.backgroundColor.withOpacity(.1),
                        theme.backgroundColor.withOpacity(.3),
                        theme.backgroundColor.withOpacity(.4),
                        theme.backgroundColor,
                        theme.backgroundColor,
                        theme.backgroundColor,
                        theme.backgroundColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (errorMessage == null && successMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            successMessage!,
                            style: TextStyle(color: Colors.green, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
