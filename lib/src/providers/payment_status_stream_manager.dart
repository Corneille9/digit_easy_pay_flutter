/// PaymentStatusStreamManager Class
///
/// This class is responsible for managing the status stream of a payment transaction rather than waiting for a delay. It continuously checks the status of the transaction at specified intervals and notifies the stream listeners with the latest status.
import 'dart:async';
import 'dart:ui';

import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_service.dart';

class PaymentStatusStreamManager {
  final String reference;
  final VoidCallback? onTimeOut;
  late final Timer _timer;
  final PaymentService _paymentProvider;
  final StreamController<TransactionStatus> _statusTransactionController = StreamController<TransactionStatus>();

  /// Constructor for the PaymentStatusStreamManager class.
  ///
  /// Initializes the stream manager with the payment provider, reference, stream interval, and an optional timeout callback.
  ///
  /// @param _paymentProvider The PaymentService instance for checking transaction status.
  /// @param reference The reference of the transaction to monitor.
  /// @param streamInterval The interval at which to check the transaction status (default: 5 seconds).
  /// @param onTimeOut An optional callback to be called when the transaction times out.
  PaymentStatusStreamManager(this._paymentProvider, {int streamInterval = 5, required this.reference, this.onTimeOut}) {
    _startStream(streamInterval);
  }

  /// Get the transaction status stream.
  Stream<TransactionStatus> get statusTransactionStream => _statusTransactionController.stream;

  /// Start the transaction status stream with the specified stream interval.
  void _startStream(int streamInterval) {
    _timer = Timer.periodic(Duration(seconds: streamInterval), (timer) async {
      if (_timer.tick >= 40) {
        dispose();
        onTimeOut?.call();
        return;
      }
      // Check the transaction status
      var status = await _paymentProvider.checkTransactionStatus(reference);
      // Update the stream with the latest status
      _statusTransactionController.sink.add(status);
    });
  }

  /// Dispose of the stream manager by canceling the timer and closing the stream controller.
  void dispose() {
    _timer.cancel();
    _statusTransactionController.close();
  }
}
