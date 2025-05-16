import 'package:flutter/cupertino.dart';

import '../common/payment_constants.dart';

abstract class BaseStateProvider extends ValueNotifier<int> {
  BaseStateProvider() : super(0);

  RequestStatus _status = RequestStatus.initial;

  RequestStatus get status => _status;

  bool get isLoading => _status == RequestStatus.loading;

  bool get isProcessing => _status == RequestStatus.processing;

  bool get isSuccess => _status == RequestStatus.success;

  bool get isError => _status == RequestStatus.error;

  @protected
  void setStatus(RequestStatus status) {
    _status = status;
    notifyListeners();
  }
}
