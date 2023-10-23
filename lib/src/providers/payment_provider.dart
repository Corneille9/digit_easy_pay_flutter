import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_status_stream_manager.dart';
import 'package:digit_easy_pay_flutter/ui/views/checkout.dart';
import 'package:flutter/material.dart';

class PaymentProvider  extends ChangeNotifier{

  bool _isLoading = false;
  bool _hasError = false;
  PaymentStatusStreamManager? _statusStreamManager;

  bool get hasData => true;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  Future<void> makeMobilePayment({required DigitEasyPayCheckout checkout, required MobilePayRequest charge}) async {
    if(_isLoading)return;
    _isLoading = true;
    _hasError = false;

    notifyListeners();


    MobilePayResponse mobilePayResponse = await checkout.provider.makeMobilePayment(checkout.selectedMethod.value, charge).onError((error, stackTrace) {
      _hasError = true;
      _isLoading=false;
      notifyListeners();

      checkout.onPayError.call(ref: "");

      throw Exception(error);
    });

    _statusStreamManager = PaymentStatusStreamManager(
      checkout.provider,
      reference: mobilePayResponse.transferRef,
      onTimeOut: () {
        cancelStream();
        checkout.onPayError.call(ref: mobilePayResponse.transferRef);
      },
    );

    _statusStreamManager?.statusTransactionStream.listen((TransactionStatus status) {
      if(status==TransactionStatus.PENDING) {
        return;
      }

      if(status==TransactionStatus.SUCCESSFUL) {
        cancelStream();
        checkout.onPaySuccess(ref: mobilePayResponse.transferRef);
        return;
      }

      if(status==TransactionStatus.FAILED) {
        cancelStream();
        checkout.onPayError.call(ref: mobilePayResponse.transferRef);
        return;
      }
    });

  }

  Future<void> makeCardPayment({required DigitEasyPayCheckout checkout, required CardPayRequest charge}) async {

    checkout.onPaySuccess(ref: "aaskhdkhdks");
    return;
    if(_isLoading)return;
    _isLoading = true;
    _hasError = false;

    notifyListeners();

    return;

    CardPayResponse cardPayResponse = await checkout.provider.makeCardPayment(charge).onError((error, stackTrace) {
      _hasError = true;
      _isLoading=false;
      notifyListeners();
      throw Exception(error);
    });

    // _statusStreamManager = PaymentStatusStreamManager(
    //   checkout.provider,
    //   reference: mobilePayResponse.transferRef,
    //   onTimeOut: () {
    //   },
    // );
    //
    // _statusStreamManager?.statusTransactionStream.listen((TransactionStatus status) {
    //   if(status==TransactionStatus.PENDING) {
    //     return;
    //   }
    //
    //   if(status==TransactionStatus.SUCCESSFUL) {
    //     _statusStreamManager?.dispose();
    //     return;
    //   }
    //
    //   if(status==TransactionStatus.FAILED) {
    //     _statusStreamManager?.dispose();
    //     return;
    //   }
    // });

  }

  void cancelStream(){
    _isLoading = false;
    _hasError = false;
    _statusStreamManager?.dispose();
  }

  @override
  void dispose() {
    _isLoading = false;
    _hasError = false;
    _statusStreamManager?.dispose();
    super.dispose();
  }
}