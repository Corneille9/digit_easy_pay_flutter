import 'dart:async';
import 'dart:ui';

import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_provider.dart';

/// stream payment status rather than waiting for delay
class PaymentStatusStreamManager {
  PaymentStatusStreamManager(this._timer, this._paymentProvider, {int streamInterval = 10, required this.reference, this.onTimeOut,}) {
    _startStream(streamInterval);
  }

  final String reference;

  final VoidCallback? onTimeOut;

  late final Timer _timer;

  final PaymentProvider _paymentProvider;

  final StreamController<TransactionStatus> _statusTransactionController = StreamController<TransactionStatus>();

  Stream<TransactionStatus> get statusTransactionStream => _statusTransactionController.stream;

  void _startStream(int streamInterval) {
    _timer = Timer.periodic(Duration(seconds: streamInterval), (timer) async {
        if(_timer.tick==40) {
          dispose();
          onTimeOut?.call();
          return;
        }
        // check transaction
        var status = await _paymentProvider.checkTransactionStatus(reference);
        // update stream with latest result
        _statusTransactionController.sink.add(status);
      },
    );
  }

  /// close timer and stream controller
  void dispose() {
    _timer.cancel();
    _statusTransactionController.close();
  }
}