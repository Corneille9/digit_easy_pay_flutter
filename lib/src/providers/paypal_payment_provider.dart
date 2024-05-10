import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';

class PaypalPaymentProvider extends ChangeNotifier{
  final FlutterPaypalNative _flutterPaypalPlugin = FlutterPaypalNative.instance;
  final FPayPalCurrencyCode baseCurrency = FPayPalCurrencyCode.eur;
  final Credentials converterCredentials;

  final PayPalConfig config;
  final num amount;
  final DigitEasyPayCurrency currency;
  final DigitEasyPayCallback? onSuccess;
  final VoidCallback? onCancel;
  final VoidCallback? onError;

  num? convertedAmount;

  PaypalPaymentProvider({
    required this.config,
    required this.amount,
    required this.currency,
    required this.converterCredentials,
    this.onSuccess,
    this.onCancel,
    this.onError,
  });

  Future<void> _initPaypal({required String referenceId}) async {
    //initiate payPal plugin
    await _flutterPaypalPlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: config.payPalReturnUrl,
      //client id from developer dashboard
      clientID: config.payPalClientID,
      //sandbox, staging, live etc
      payPalEnvironment: config.environment.isLive?FPayPalEnvironment.live:FPayPalEnvironment.sandbox,
      //what currency do you plan to use? default is US dollars
      currencyCode: baseCurrency,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
    _flutterPaypalPlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          onCancel?.call();
          debugPrint("Paypal payment cancel");
        },
        onSuccess: (data) {
          _flutterPaypalPlugin.removeAllPurchaseItems();
          onSuccess?.call(data.orderId ?? referenceId, DigitEasyPayPaymentSource.PAYPAL, "visa_card");
          debugPrint("Paypal payment success");
        },
        onError: (data) {
          debugPrint("Paypal payment fail :${data.reason}");
          debugPrint(data.error);
          onError?.call();
        },
      ),
    );
  }

  Future<void> makePayment({VoidCallback? onInitialized}) async {
    try{
      debugPrint("PaypalInternational - Convert amount...");

      if(currency.name.toLowerCase() != baseCurrency.name.toLowerCase()){
        convertedAmount = await PaymentUtils.convertAmount(amount, converterCredentials,
          from: currency.name.toUpperCase(),
          to: baseCurrency.name.toUpperCase(),
        );
      }else{
        convertedAmount = amount;
      }
      
      if(convertedAmount == null){
        onError?.call();
        return;
      }

      String referenceId = FPayPalStrHelper.getRandomString(16);

      await _initPaypal(referenceId: referenceId);

      _flutterPaypalPlugin.removeAllPurchaseItems();

      _flutterPaypalPlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          amount: convertedAmount!.toDouble(),
          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: referenceId,
          currencyCode: baseCurrency,
        ),
      );

      Future.delayed(const Duration(seconds: 5), () => onInitialized?.call());

      _flutterPaypalPlugin.makeOrder(
        action: FPayPalUserAction.payNow,
      ).onError((error, stackTrace) {
        debugPrint('PaypalInternational - makeOrder - error: $error');
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
        onError?.call();
      },);

    }catch(error, stackTrace) {
      onInitialized?.call();
      debugPrint('PaypalInternational - makePayment - error: $error');
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      onError?.call();
    }
  }
}
