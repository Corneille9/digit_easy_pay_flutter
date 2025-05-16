import '../../digit_easy_pay_flutter.dart';

class PaymentRequest {
  final num amount;
  final Currency currency;

  PaymentRequest({required this.amount, required this.currency});
}
