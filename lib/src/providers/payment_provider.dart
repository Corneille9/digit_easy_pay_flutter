/// PaymentProvider Class
///
/// This class provides a payment provider that handles mobile and card payments, including handling payment status streams and transactions. It uses the `PaymentStatusStreamManager` to manage the status of transactions and notifies the user of successful or failed payments.
import 'package:digit_easy_pay_flutter/src/common/exceptions.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_status_stream_manager.dart';
import 'package:digit_easy_pay_flutter/ui/views/checkout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  PaymentStatusStreamManager? _statusStreamManager;

  bool get hasData => true;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  /// Make a mobile payment using the provided checkout and charge details.
  ///
  /// @param checkout The DigitEasyPayCheckout instance.
  /// @param charge The MobilePayRequest for the payment.
  Future<void> makeMobilePayment({required DigitEasyPayCheckout checkout, required MobilePayRequest charge}) async {
    if (_isLoading) return;
    _isLoading = true;
    _hasError = false;

    notifyListeners();

    MobilePayResponse mobilePayResponse = await checkout.provider.makeMobilePayment(checkout.selectedMethod.value, charge).onError((error, stackTrace) {
      _hasError = true;
      _isLoading = false;
      notifyListeners();

      checkout.onPayError.call(ref: "");

      if (error is DioException) {
        DigitEasyPayException.interpretError(error);
      }

      throw DigitEasyPayException(error.toString());
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
      if (status == TransactionStatus.PENDING) {
        return;
      }

      if (status == TransactionStatus.SUCCESSFUL) {
        cancelStream();
        checkout.onPaySuccess(ref: mobilePayResponse.transferRef);
        return;
      }

      if (status == TransactionStatus.FAILED) {
        cancelStream();
        checkout.onPayError.call(ref: mobilePayResponse.transferRef);
        return;
      }
    });
  }

  /// Make a card payment using the provided checkout and charge details.
  ///
  /// @param checkout The DigitEasyPayCheckout instance.
  /// @param charge The CardPayRequest for the payment.
  Future<void> makeCardPayment({required DigitEasyPayCheckout checkout, required CardPayRequest charge}) async {
    if (_isLoading) return;
    _isLoading = true;
    _hasError = false;

    notifyListeners();

    CardPayResponse cardPayResponse = await checkout.provider.makeCardPayment(charge).onError((error, stackTrace) {
      _hasError = true;
      _isLoading = false;
      notifyListeners();
      checkout.onPayError.call(ref: "");

      if (error is DioException) {
        DigitEasyPayException.interpretError(error);
      }

      throw DigitEasyPayException(error.toString());
    });

    await PaymentValidator.tryLaunchUrl(cardPayResponse.url);

    _statusStreamManager = PaymentStatusStreamManager(
      checkout.provider,
      reference: cardPayResponse.reference,
      onTimeOut: () {
        cancelStream();
        checkout.onPayError.call(ref: cardPayResponse.reference);
      },
    );

    _statusStreamManager?.statusTransactionStream.listen((TransactionStatus status) {
      if (status == TransactionStatus.PENDING) {
        return;
      }

      if (status == TransactionStatus.SUCCESSFUL) {
        cancelStream();
        checkout.onPaySuccess(ref: cardPayResponse.reference);
        return;
      }

      if (status == TransactionStatus.FAILED) {
        cancelStream();
        checkout.onPayError.call(ref: cardPayResponse.reference);
        return;
      }
    });
  }

  /// Cancel the payment status stream and reset the state.
  void cancelStream() {
    _isLoading = false;
    _hasError = false;
    _statusStreamManager?.dispose();
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoading = false;
    _hasError = false;
    _statusStreamManager?.dispose();
    super.dispose();
  }
}
