/// PaymentService Class
///
/// This class provides services for making mobile and card payments, initializing the HTTP client, and handling transaction status checks and country data retrieval.
import 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_response.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_http_client.dart';

class PaymentService {
  final DigitEasyPayConfig config;
  final PaymentHttpClient client;

  /// Constructor for the PaymentService class.
  ///
  /// Initializes the service with the provided DigitEasyPayConfig and creates a PaymentHttpClient instance.
  ///
  /// @param config The configuration settings for the service.
  PaymentService(this.config) : client = PaymentHttpClient(config: config);

  /// Initialize the service by ensuring that the HTTP client is initialized.
  Future<void> initialize() async {
    await client.ensureInitialized();
  }

  /// Dispose of the service, including the HTTP client.
  void dispose() {
    client.dispose();
  }

  /// Make a mobile payment with the specified payment method and mobile payment request.
  ///
  /// @param paymentMethod The payment method to use (e.g., Visa, MasterCard).
  /// @param mobilePayRequest The MobilePayRequest for the payment.
  /// @return A MobilePayResponse with the payment result.
  Future<MobilePayResponse> makeMobilePayment(DigitEasyPayPaymentMethod paymentMethod, MobilePayRequest mobilePayRequest) async {
    var response = await client.post(path: "/mobile/make-payment", data: mobilePayRequest.toMap(), queryParameters: {"paymentMethod": paymentMethod.toSnakeCase, if(config.applicationKey!=null)"applicationKey":config.applicationKey});
    return MobilePayResponse.fromMap(response.data);
  }

  /// Make a card payment with the specified card payment request.
  ///
  /// @param cardPayRequest The CardPayRequest for the payment.
  /// @return A CardPayResponse with the payment result.
  Future<CardPayResponse> makeCardPayment(CardPayRequest cardPayRequest) async {
    var response = await client.post(path: "/card/request-payment", data: cardPayRequest.toMap(), queryParameters: {if(config.applicationKey!=null)"applicationKey":config.applicationKey});
    return CardPayResponse.fromMap(response.data);
  }

  /// Check the status of a transaction using its reference.
  ///
  /// @param reference The reference of the transaction to check.
  /// @return The status of the transaction.
  Future<TransactionStatus> checkTransactionStatus(String reference) async {
    var response = await client.get(path: "/transactions/$reference");
    return TransactionStatus.values.firstWhere((element) => element.name.toLowerCase() == response.data["status"].toString().toLowerCase());
  }

  /// Retrieve a list of all available countries.
  ///
  /// @return A list of Country objects representing available countries.
  Future<List<Country>> getAllCountries() async {
    var response = await client.get(path: "/resources/countries/all");
    return ((response.data ?? []) as List).map((e) => Country.fromMap(e)).toList();
  }
}
