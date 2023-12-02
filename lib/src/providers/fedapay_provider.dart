import 'dart:async';
import 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/fedapay_payment_webview.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/flexible_bottom_sheet_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FedapayPaymentProvider extends ChangeNotifier{
  FedapayConfig config;
  final num amount;
  final DigitEasyPayCurrency currency;
  final DigitEasyPayCallback? onSuccess;
  final VoidCallback? onCancel;
  final VoidCallback? onError;
  final PaymentTheme theme;
  final L10n l10n;

  String? transactionId;
  String? transactionUrl;
  String? transactionToken;
  var transaction;

  FedapayPaymentProvider({
    required this.config,
    required this.amount,
    required this.currency,
    required this.theme,
    required this.l10n,
    this.onSuccess,
    this.onCancel,
    this.onError,
  });

  String get apiBase => config.environment.isLive?"https://api.fedapay.com/v1":"https://sandbox-api.fedapay.com/v1";

  void makePayment({required BuildContext context, VoidCallback? onInitialized}) async {
    try{
      var data = {
        'description': "Transaction from digit pay",
        'callback_url': "https://digit.pay.sdk.com/callback/fedapay",
        // 'callback_url': config.callbackUrl,
        'amount': amount,
        if(config.customer!=null && config.customer!.isNotEmpty)'customer': config.customer,
        'currency': {
          "iso": currency.name,
        },
      };
      final Dio client = Dio(BaseOptions(headers: headers));
      var response = await client.post("$apiBase/transactions", data: data);

      transaction = response.data["v1/transaction"];
      transactionId = transaction["id"].toString();

      response =  await client.post("$apiBase/transactions/$transactionId/token");

      transactionToken = response.data['token'];
      transactionUrl = response.data["url"];
      onInitialized?.call();
      Future(() => showWebView(context),);
    }catch(e, _){
      onInitialized?.call();
      onError?.call();
      debugPrint("Fedapay Payment error: $e");
      if(e is DioException)debugPrint(e.response?.data.toString());
      debugPrintStack(stackTrace: _);
    }
  }

  void showWebView(BuildContext context){
    showFlexibleBottomSheet(
      minHeight: .5,
      initHeight: .95,
      maxHeight: 1,
      isDismissible: false,
      isCollapsible: false,
      bottomSheetBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),
      context: context,
      bottomSheetColor: theme.backgroundColor,
      onWillPop: () async{
        return false;
      },
      builder: (context, scrollController, bottomSheetOffset) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: theme.backgroundColor,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () async {
                    checkStatus();
                    Navigator.pop(context);
                  },
                  child: Text(l10n.cancelPayment, style: TextStyle(color: theme.textColor),)
              ),
            ),
            Expanded(
              child: FedapayPaymentWebView(
                provider: this,
                theme: theme,
              ),
            )
          ],
        );
      },
    );
  }

  Stream<FedapayTransactionStatus?> transactionStatus(String id) async*{
    yield* Stream.periodic(const Duration(seconds: 1),(_) async {
      return await _getTransactionStatus(id);
    }).asyncMap((event) async => await event);
  }

  Future<bool> checkStatus() async {
    var status = await _getTransactionStatus(transactionId!);
    // if(status==null){
    //   onCancel?.call();
    //   return true;
    // }

    if(status==FedapayTransactionStatus.approved){
      onSuccess?.call(transactionId!, DigitEasyPayPaymentSource.FEDAPAY, "");
      return true;
    }

    // else if(status==FedapayTransactionStatus.canceled || status==FedapayTransactionStatus.declined){
    //   onCancel?.call();
    //   return true;
    // }

    onCancel?.call();

    return false;
  }

  Future<FedapayTransactionStatus?> _getTransactionStatus(String id) async{
    final Dio client = Dio(BaseOptions(
      headers: headers,
      responseType: ResponseType.json,
      contentType: "application/json; charset=utf-8",
    ));
    try{
      var response = await client.get("$apiBase/transactions/$id");
      transaction = response.data["v1/transaction"];
      return FedapayTransactionStatus.values.firstWhere((element) => element.name==response.data["v1/transaction"]["status"], orElse: () => FedapayTransactionStatus.pending,);
    }catch(e,_){
      onError?.call();
      debugPrint(e.toString());
      if(e is DioException)debugPrint(e.response?.data);
      debugPrintStack(stackTrace: _);
      return null;
    }
  }

  Map<String, String> get headers => {
    "Authorization":"Bearer ${config.apiKey}",
  };
}