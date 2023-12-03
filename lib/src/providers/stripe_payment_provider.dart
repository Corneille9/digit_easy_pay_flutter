import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentProvider extends ChangeNotifier{
  final StripeConfig config;
  final num amount;
  final DigitEasyPayCurrency currency;
  final DigitEasyPayCallback? onSuccess;
  final VoidCallback? onCancel;
  final VoidCallback? onError;
  final PaymentTheme theme;

  StripePaymentProvider({
    required this.config,
    required this.amount,
    required this.currency,
    required this.theme,
    this.onSuccess,
    this.onCancel,
    this.onError,
  });

  Future<String?> _initStripe() async {
    Map<String, dynamic>? paymentIntent = await createPaymentIntent(amount, currency.name);
    if(paymentIntent == null){
      onError?.call();
      return null;
    }

    Stripe.publishableKey = config.stripePublishableKey;

    //Payment Sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        appearance: PaymentSheetAppearance(
          shapes: const PaymentSheetShape(borderRadius: 20),
          primaryButton: PaymentSheetPrimaryButtonAppearance(
            colors: PaymentSheetPrimaryButtonTheme(
              dark: PaymentSheetPrimaryButtonThemeColors(
                background: theme.primaryColor
              ),
              light: PaymentSheetPrimaryButtonThemeColors(
                  background: theme.primaryColor
              )
            ),
          )
        ),
        paymentIntentClientSecret: paymentIntent['client_secret'],
        // googlePay: PaymentSheetGooglePay(
        //     testEnv: true,
        //     currencyCode: currency.name,
        //     merchantCountryCode: config.merchantCountryCode
        // ),
        style: theme.isLight?ThemeMode.light:ThemeMode.dark,
        merchantDisplayName: config.merchantDisplayName,
        // applePay: PaymentSheetApplePay(
        //     merchantCountryCode: config.merchantCountryCode,
        // ),
      ),
    );

    return paymentIntent['id'];
  }

  Future<void> _processPayment({required String referenceId}) async {
    await Stripe.instance.presentPaymentSheet().then((value) {
      onSuccess?.call(referenceId, DigitEasyPayPaymentSource.STRIPE, "visa_card");
    }).onError((error, stackTrace) {
      debugPrint("Stripe Payment error: $error");
      debugPrintStack(stackTrace: stackTrace);
      onCancel?.call();
    },);
  }

  Future<Map<String, dynamic>?> createPaymentIntent(num amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        // 'payment_method_types[]': 'card'
      };
      var headers = {
        'Authorization': 'Bearer ${config.stripePrivateKey}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };

      final Dio httpClient = Dio(BaseOptions(headers: headers));
      var response = await httpClient.post(config.stripeApiUrl, queryParameters: body);
      debugPrint("Stripe payment response: ${response.data}");
      return response.data;
    } catch (err, stacktrace) {
      debugPrint("Stripe payment error: $err");
      if(err is StripeConfigException)debugPrint(err.message);
      if(err is DioException) {
        debugPrint(err.response?.data);
      }
      debugPrintStack(stackTrace: stacktrace);
      return null;
    }
  }

  Future<void> makePayment({VoidCallback? onInitialized}) async {
    try{
      debugPrint("Stripe payment initializing ...");
      var referenceId = await _initStripe();
      onInitialized?.call();
      if(referenceId == null) return;
      await _processPayment(referenceId: referenceId);
    }catch(e, s){
      onInitialized?.call();
      debugPrint("Stripe payment error: $e");
      if(e is StripeConfigException)debugPrint(e.message);
      if(e is DioException)debugPrint(e.response?.data);
      debugPrintStack(stackTrace: s);
      onError?.call();
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
