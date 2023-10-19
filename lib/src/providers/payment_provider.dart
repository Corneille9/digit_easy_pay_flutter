import 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_http_client.dart';

class PaymentProvider{
  final DigitEasyPayConfig config;
  final PaymentHttpClient client;

  PaymentProvider(this.config):client = PaymentHttpClient(config: config);

  Future<void> initialize() async {
    await client.ensureInitialized();
  }

  void dispose() {
    client.dispose();
  }

  Future<MobilePayResponse> makeMobilePayment(DigitEasyPayPaymentMethod paymentMethod, MobilePayRequest mobilePayRequest) async {
    var response = await client.post(path: "/mobile/make-payment", data: mobilePayRequest.toMap(), queryParameters: {"paymentMethod": paymentMethod.toSnakeCase});
    return MobilePayResponse.fromMap(response.data);
  }

  Future<CardPayResponse> makeCardPayment(CardPayRequest cardPayRequest) async {
    var response = await client.post(path: "/card/request-payment", data: cardPayRequest.toMap());
    return CardPayResponse.fromMap(response.data);
  }

  Future<TransactionStatus> checkTransactionStatus(String reference) async {
    var response = await client.get(path: "/transactions/$reference");
    return TransactionStatus.values.firstWhere((element) => element.name.toLowerCase()==response.data["status"].toString().toLowerCase());
  }

  Future<List<Country>> getAllCountries() async {
    print('sdjjkhsdkfhkjsdfhdfkhdskfhdskhfkdshfhsdkfhksdfhjdsfd');
    print(client.dio.options.headers);
    print('sdjjkhsdkfhkjsdfhdfkhdskfhdskhfkdshfhsdkfhksdfhjdsfd');
    var response = await client.get(path: "/resources/countries/all");
    return ((response.data??[]) as List).map((e) => Country.fromMap(e)).toList();
  }
}