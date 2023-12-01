import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';

class DigitEasyPayPaymentProvider extends ChangeNotifier {
  DigitEasyPay? _digitEasyPay;
  final DigitEasyPayConfig config;
  final PaymentTheme? theme;
  final L10n? l10n;
  final num amount;
  final DigitEasyPayCurrency currency;
  final DigitEasyPayCallback? onSuccess;
  final VoidCallback? onCancel;
  final VoidCallback? onError;

  DigitEasyPayPaymentProvider({
    required this.config,
    required this.amount,
    required this.currency,
    this.theme,
    this.l10n,
    this.onSuccess,
    this.onCancel,
    this.onError,
  });

  Future<String?> _initDigitEasyPay({required num amount, VoidCallback? onError}) async {
    _digitEasyPay = DigitEasyPay(config);
    await _digitEasyPay?.initialize();
    return null;
  }

  Future<void> _processPayment({required BuildContext context}) async {
    _digitEasyPay?.checkout(context, amount: amount, currency: currency, l10n: l10n ,onSuccess: onSuccess, onCancel: onCancel, theme: theme);
  }

  Future<void> makePayment({required BuildContext context}) async {
    try{
      debugPrint("Digit easy pay payment initializing ...");
      await _initDigitEasyPay(amount: amount, onError: onError);
      Future(() async => await _processPayment(context: context),);
    }catch(e, s){
      debugPrint("Stripe payment error: $e");
      debugPrintStack(stackTrace: s);
      onError?.call();
    }
  }
}
