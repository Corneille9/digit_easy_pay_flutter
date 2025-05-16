import 'package:digit_easy_pay_flutter/src/models/payment_result.dart';
import 'package:digit_easy_pay_flutter/src/providers/qosic_checkout_provider.dart';
import 'package:digit_easy_pay_flutter/src/ui/widgets/checkout/qosic_gateway_list_view.dart';
import 'package:flutter/material.dart';

import '../../../digit_easy_pay_flutter.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/theme_widget.dart';

/// A view for processing payments through Qosic payment gateways.
class QosicPaymentView extends StatefulWidget {
  const QosicPaymentView({super.key, required this.paymentRequest});

  final PaymentRequest paymentRequest;

  /// Opens the Qosic payment view to process a payment.
  ///
  /// If there's only one available payment method, it will process the payment directly
  /// without showing the gateway selection view.
  ///
  /// [context] The BuildContext required to show the UI.
  /// [paymentRequest] The payment request details.
  ///
  /// Returns a Future<PaymentResult?> indicating the outcome of the payment attempt.
  static Future<PaymentResult?> open({
    required BuildContext context,
    required PaymentRequest paymentRequest,
  }) async {
    // Get the payment config
    final config = DigitEasyPayFlutter.config;
    final paymentMethods = config.qosicConfig?.paymentMethods ?? [];

    // If there's only one payment method, process payment directly without showing the view
    if (paymentMethods.length == 1) {
      try {
        final gateway = paymentMethods.first;
        final provider = QosicCheckoutProvider(
          paymentConfig: config,
          request: paymentRequest,
          gateway: gateway,
        );

        final result = await provider.pay(context: context);

        if (result.success) {
          return result;
        }

        return null;
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: s);
        return null;
      }
    }

    // Show the payment view for multiple gateways or if direct payment failed
    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => QosicPaymentView(paymentRequest: paymentRequest)),
    );
  }

  @override
  State<QosicPaymentView> createState() => _QosicPaymentViewState();
}

class _QosicPaymentViewState extends State<QosicPaymentView> {
  PaymentRequest get paymentRequest => widget.paymentRequest;

  PaymentConfig get config => DigitEasyPayFlutter.config;

  List<QosicPaymentGateway> get paymentMethods => config.qosicConfig?.paymentMethods ?? [];

  PaymentTheme get theme => config.theme;

  L10n get l10n => config.lang;

  String? errorMessage;
  String? successMessage;
  bool isProcessing = false;
  QosicPaymentGateway? processingGateway;

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      theme: theme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.textColor.withAlpha(10),
          surfaceTintColor: Colors.transparent,
          title: const Text("Digit Easy Pay"),
          centerTitle: true,
          leading: CustomBackButton(),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              QosicGatewayListView(
                gateways: paymentMethods,
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

                    var provider = QosicCheckoutProvider(
                      paymentConfig: config,
                      request: paymentRequest,
                      gateway: gateway,
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

                    Navigator.of(context).pop(result);
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
                  padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (errorMessage == null && successMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            successMessage!,
                            style: TextStyle(color: Colors.green, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 5),
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
