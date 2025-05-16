import 'package:digit_easy_pay_flutter/src/common/form_request.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/http/payment_service.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:flutter/material.dart';

import '../../../digit_easy_pay_flutter.dart';
import '../../common/payment_validator.dart';
import '../../models/payment_result.dart';
import '../../providers/qosic_checkout_provider.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/qosic_card_payment_form.dart';
import '../widgets/qosic_mobile_payment_form.dart';
import '../widgets/theme_widget.dart';

class QosicCheckoutView extends StatefulWidget {
  const QosicCheckoutView({super.key, required this.paymentRequest, required this.gateway});

  final PaymentRequest paymentRequest;

  final QosicPaymentGateway gateway;

  static Future<PaymentResult?> open({
    required BuildContext context,
    required PaymentRequest paymentRequest,
    required QosicPaymentGateway gateway,
  }) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QosicCheckoutView(paymentRequest: paymentRequest, gateway: gateway),
      ),
    );
  }

  @override
  State<QosicCheckoutView> createState() => _QosicCheckoutViewState();
}

class _QosicCheckoutViewState extends State<QosicCheckoutView> {
  final GlobalKey<QosicMobilePaymentFormState> _mobileFormKey =
      GlobalKey<QosicMobilePaymentFormState>();
  final GlobalKey<QosicCardPaymentFormState> _cardFormKey = GlobalKey<QosicCardPaymentFormState>();
  final ValueNotifier<RequestStatus> paymentStatus = ValueNotifier(RequestStatus.initial);

  late final PaymentService paymentService = PaymentService(config.qosicConfig!);
  late final QosicCheckoutProvider provider = QosicCheckoutProvider(
    request: paymentRequest,
    paymentConfig: config,
    gateway: widget.gateway,
  );

  PaymentRequest get paymentRequest => widget.paymentRequest;

  PaymentConfig get config => DigitEasyPayFlutter.config;

  L10n get l10n => config.lang;

  PaymentTheme get theme => config.theme;

  QosicPaymentGateway get gateway => widget.gateway;

  bool get isMobilePayment =>
      gateway == QosicPaymentGateway.momo || gateway == QosicPaymentGateway.flooz;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ThemeWidget(
        theme: theme,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.textColor.withAlpha(10),
            surfaceTintColor: Colors.transparent,
            title: Text(gateway.toIntl()),
            centerTitle: true,
            leading: CustomBackButton(
              onPressed: () {
                _showCancelConfirmation(context);
              },
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                if (isMobilePayment)
                  QosicMobilePaymentForm(key: _mobileFormKey, paymentRequest: paymentRequest)
                else
                  QosicCardPaymentForm(
                    key: _cardFormKey,
                    paymentRequest: paymentRequest,
                    paymentService: paymentService,
                  ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder(
                    valueListenable: paymentStatus,
                    builder: (context, value, child) {
                      return Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.backgroundColor.withOpacity(.4),
                              theme.backgroundColor.withOpacity(.5),
                              theme.backgroundColor,
                              theme.backgroundColor,
                              theme.backgroundColor,
                              theme.backgroundColor,
                              theme.backgroundColor,
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
                              Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            SizedBox(height: 5),
                            SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  FormRequest? request;
                                  if (isMobilePayment) {
                                    request = _mobileFormKey.currentState!.validate(context);
                                  } else {
                                    request = _cardFormKey.currentState!.validate(context);
                                  }
                                  if (request == null) return;

                                  isMobilePayment
                                      ? _handleMobilePayment(request as MobilePayRequest)
                                      : _handleCardPayment(request as CardPayRequest);
                                },
                                child: Builder(
                                  builder: (context) {
                                    if (paymentStatus.value == RequestStatus.processing) {
                                      return SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      );
                                    }

                                    return Text(
                                      "${l10n.pay} ${PaymentUtils.formatAmount(paymentRequest.amount, paymentRequest.currency)}",
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before cancelling payment
  void _showCancelConfirmation(BuildContext context) {
    if (paymentStatus.value != RequestStatus.processing) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.cancelPayment),
            content: Text(l10n.wantToCancel),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.no)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close payment screen
                },
                child: Text(l10n.yes),
              ),
            ],
          ),
    );
  }

  Future<void> _handleMobilePayment(MobilePayRequest request) async {
    try {
      errorMessage = null;
      paymentStatus.value = RequestStatus.processing;

      var result = await provider.makeMobilePayment(service: paymentService, request: request);

      if (!result.success) {
        errorMessage = result.message ?? l10n.paymentFailed;
        paymentStatus.value = RequestStatus.error;
        return;
      }

      paymentStatus.value = RequestStatus.success;
      onPaymentSuccess(result);
    } catch (e) {
      errorMessage = config.lang.anErrorOccurCheckConnection;
      paymentStatus.value = RequestStatus.error;
    }
  }

  Future<void> _handleCardPayment(CardPayRequest request) async {
    try {
      errorMessage = null;
      paymentStatus.value = RequestStatus.processing;
      var result = await provider.makeCardPayment(
        service: paymentService,
        request: request,
        context: context,
      );

      if (!result.success) {
        errorMessage = result.message ?? l10n.paymentFailed;
        paymentStatus.value = RequestStatus.error;
        return;
      }

      paymentStatus.value = RequestStatus.success;
      onPaymentSuccess(result);
    } catch (e) {
      errorMessage = config.lang.anErrorOccurCheckConnection;
      paymentStatus.value = RequestStatus.error;
    }
  }

  void onPaymentSuccess(PaymentResult result) {
    Navigator.pop(context, result);
  }
}
