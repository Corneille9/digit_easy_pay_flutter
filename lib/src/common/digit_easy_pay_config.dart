import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';

/// [DigitEasyPayConfig] Class
///
/// This class represents the configuration settings required for initializing the [DigitEasyPay] SDK. It includes information about the environment, user key, username, and password needed for the integration.
class DigitEasyPayConfig {
  final List<DigitEasyPayPaymentMethod> paymentMethods;
  final DigitEasyPayEnvironment environment;
  final String userKey;
  final String username;
  final String password;
  final String? applicationKey;

//<editor-fold desc="Data Methods">
  const DigitEasyPayConfig({
    this.paymentMethods = DigitEasyPayPaymentMethod.values,
    this.environment = DigitEasyPayEnvironment.live,
    required this.userKey,
    required this.username,
    required this.password,
    this.applicationKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitEasyPayConfig &&
          runtimeType == other.runtimeType &&
          paymentMethods == other.paymentMethods &&
          environment == other.environment &&
          userKey == other.userKey &&
          username == other.username &&
          password == other.password &&
          applicationKey == other.applicationKey);

  @override
  int get hashCode =>
      paymentMethods.hashCode ^
      environment.hashCode ^
      userKey.hashCode ^
      username.hashCode ^
      password.hashCode ^
      applicationKey.hashCode;

  @override
  String toString() {
    return 'DigitEasyPayConfig{ paymentMethods: $paymentMethods, environment: $environment, userKey: $userKey, username: $username, password: $password, applicationKey: $applicationKey,}';
  }

  DigitEasyPayConfig copyWith({
    List<DigitEasyPayPaymentMethod>? paymentMethods,
    DigitEasyPayEnvironment? environment,
    String? userKey,
    String? username,
    String? password,
    String? applicationKey,
  }) {
    return DigitEasyPayConfig(
      paymentMethods: paymentMethods ?? this.paymentMethods,
      environment: environment ?? this.environment,
      userKey: userKey ?? this.userKey,
      username: username ?? this.username,
      password: password ?? this.password,
      applicationKey: applicationKey ?? this.applicationKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentMethods': this.paymentMethods,
      'environment': this.environment,
      'userKey': this.userKey,
      'username': this.username,
      'password': this.password,
      'applicationKey': this.applicationKey,
    };
  }

  factory DigitEasyPayConfig.fromMap(Map<String, dynamic> map) {
    return DigitEasyPayConfig(
      paymentMethods: map['paymentMethods'] as List<DigitEasyPayPaymentMethod>,
      environment: map['environment'] as DigitEasyPayEnvironment,
      userKey: map['userKey'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      applicationKey: map['applicationKey'] as String,
    );
  }

//</editor-fold>
}

class PayPalConfig{
  final String payPalClientID;
  final String payPalReturnUrl;
  final DigitEasyPayEnvironment environment;

//<editor-fold desc="Data Methods">
  const PayPalConfig({
    required this.payPalClientID,
    required this.payPalReturnUrl,
    this.environment = DigitEasyPayEnvironment.live,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayPalConfig &&
          runtimeType == other.runtimeType &&
          payPalClientID == other.payPalClientID &&
          payPalReturnUrl == other.payPalReturnUrl &&
          environment == other.environment);

  @override
  int get hashCode =>
      payPalClientID.hashCode ^ payPalReturnUrl.hashCode ^ environment.hashCode;

  @override
  String toString() {
    return 'PayPalConfig{ payPalClientID: $payPalClientID, payPalReturnUrl: $payPalReturnUrl, environment: $environment,}';
  }

  PayPalConfig copyWith({
    String? payPalClientID,
    String? payPalReturnUrl,
    DigitEasyPayEnvironment? environment,
  }) {
    return PayPalConfig(
      payPalClientID: payPalClientID ?? this.payPalClientID,
      payPalReturnUrl: payPalReturnUrl ?? this.payPalReturnUrl,
      environment: environment ?? this.environment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payPalClientID': this.payPalClientID,
      'payPalReturnUrl': this.payPalReturnUrl,
      'environment': this.environment,
    };
  }

  factory PayPalConfig.fromMap(Map<String, dynamic> map) {
    return PayPalConfig(
      payPalClientID: map['payPalClientID'] as String,
      payPalReturnUrl: map['payPalReturnUrl'] as String,
      environment: map['environment'] as DigitEasyPayEnvironment,
    );
  }

//</editor-fold>
}

class StripeConfig{
  final String stripePrivateKey;
  final String stripePublishableKey;
  final String merchantCountryCode;
  final String merchantDisplayName;
  final String stripeApiUrl =  "https://api.stripe.com/v1/payment_intents";
  final DigitEasyPayEnvironment environment;

//<editor-fold desc="Data Methods">
  const StripeConfig({
    required this.stripePrivateKey,
    required this.stripePublishableKey,
    required this.merchantCountryCode,
    required this.merchantDisplayName,
    this.environment = DigitEasyPayEnvironment.live,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StripeConfig &&
          runtimeType == other.runtimeType &&
          stripePrivateKey == other.stripePrivateKey &&
          stripePublishableKey == other.stripePublishableKey &&
          merchantCountryCode == other.merchantCountryCode &&
          merchantDisplayName == other.merchantDisplayName &&
          environment == other.environment);

  @override
  int get hashCode =>
      stripePrivateKey.hashCode ^
      stripePublishableKey.hashCode ^
      merchantCountryCode.hashCode ^
      merchantDisplayName.hashCode ^
      environment.hashCode;

  @override
  String toString() {
    return 'StripeConfig{' +
        ' stripePrivateKey: $stripePrivateKey,' +
        ' stripePublishableKey: $stripePublishableKey,' +
        ' merchantCountryCode: $merchantCountryCode,' +
        ' merchantDisplayName: $merchantDisplayName,' +
        ' environment: $environment,' +
        '}';
  }

  StripeConfig copyWith({
    String? stripePrivateKey,
    String? stripePublishableKey,
    String? merchantCountryCode,
    String? merchantDisplayName,
    DigitEasyPayEnvironment? environment,
  }) {
    return StripeConfig(
      stripePrivateKey: stripePrivateKey ?? this.stripePrivateKey,
      stripePublishableKey: stripePublishableKey ?? this.stripePublishableKey,
      merchantCountryCode: merchantCountryCode ?? this.merchantCountryCode,
      merchantDisplayName: merchantDisplayName ?? this.merchantDisplayName,
      environment: environment ?? this.environment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stripePrivateKey': this.stripePrivateKey,
      'stripePublishableKey': this.stripePublishableKey,
      'merchantCountryCode': this.merchantCountryCode,
      'merchantDisplayName': this.merchantDisplayName,
      'environment': this.environment,
    };
  }

  factory StripeConfig.fromMap(Map<String, dynamic> map) {
    return StripeConfig(
      stripePrivateKey: map['stripePrivateKey'] as String,
      stripePublishableKey: map['stripePublishableKey'] as String,
      merchantCountryCode: map['merchantCountryCode'] as String,
      merchantDisplayName: map['merchantDisplayName'] as String,
      environment: map['environment'] as DigitEasyPayEnvironment,
    );
  }

//</editor-fold>
}

class FedapayConfig{
  final String apiKey;
  final String? callbackUrl;
  final DigitEasyPayEnvironment environment;
  final Map<String, dynamic>? customer;

//<editor-fold desc="Data Methods">
  const FedapayConfig({
    required this.apiKey,
    this.callbackUrl,
    this.environment = DigitEasyPayEnvironment.live,
    this.customer,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FedapayConfig &&
          runtimeType == other.runtimeType &&
          apiKey == other.apiKey &&
          callbackUrl == other.callbackUrl &&
          environment == other.environment &&
          customer == other.customer);

  @override
  int get hashCode =>
      apiKey.hashCode ^
      callbackUrl.hashCode ^
      environment.hashCode ^
      customer.hashCode;

  @override
  String toString() {
    return 'FedapayConfig{' +
        ' apiKey: $apiKey,' +
        ' callbackUrl: $callbackUrl,' +
        ' environment: $environment,' +
        ' customer: $customer,' +
        '}';
  }

  FedapayConfig copyWith({
    String? apiKey,
    String? callbackUrl,
    DigitEasyPayEnvironment? environment,
    Map<String, dynamic>? customer,
  }) {
    return FedapayConfig(
      apiKey: apiKey ?? this.apiKey,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      environment: environment ?? this.environment,
      customer: customer ?? this.customer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apiKey': this.apiKey,
      'callbackUrl': this.callbackUrl,
      'environment': this.environment,
      'customer': this.customer,
    };
  }

  factory FedapayConfig.fromMap(Map<String, dynamic> map) {
    return FedapayConfig(
      apiKey: map['apiKey'] as String,
      callbackUrl: map['callbackUrl'] as String,
      environment: map['environment'] as DigitEasyPayEnvironment,
      customer: map['customer'] as Map<String, dynamic>,
    );
  }

//</editor-fold>
}

class PaymentConfig{
  final DigitEasyPayConfig? digitEasyPayConfig;
  final PayPalConfig? payPalConfig;
  final StripeConfig? stripeConfig;
  final FedapayConfig? fedapayConfig;

//<editor-fold desc="Data Methods">
  const PaymentConfig({
    this.digitEasyPayConfig,
    this.payPalConfig,
    this.stripeConfig,
    this.fedapayConfig,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentConfig &&
          runtimeType == other.runtimeType &&
          digitEasyPayConfig == other.digitEasyPayConfig &&
          payPalConfig == other.payPalConfig &&
          stripeConfig == other.stripeConfig &&
          fedapayConfig == other.fedapayConfig);

  @override
  int get hashCode =>
      digitEasyPayConfig.hashCode ^
      payPalConfig.hashCode ^
      stripeConfig.hashCode ^
      fedapayConfig.hashCode;

  @override
  String toString() {
    return 'PaymentConfig{' +
        ' digitEasyPayConfig: $digitEasyPayConfig,' +
        ' payPalConfig: $payPalConfig,' +
        ' stripeConfig: $stripeConfig,' +
        ' fedapayConfig: $fedapayConfig,' +
        '}';
  }

  PaymentConfig copyWith({
    DigitEasyPayConfig? digitEasyPayConfig,
    PayPalConfig? payPalConfig,
    StripeConfig? stripeConfig,
    FedapayConfig? fedapayConfig,
  }) {
    return PaymentConfig(
      digitEasyPayConfig: digitEasyPayConfig ?? this.digitEasyPayConfig,
      payPalConfig: payPalConfig ?? this.payPalConfig,
      stripeConfig: stripeConfig ?? this.stripeConfig,
      fedapayConfig: fedapayConfig ?? this.fedapayConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'digitEasyPayConfig': this.digitEasyPayConfig,
      'payPalConfig': this.payPalConfig,
      'stripeConfig': this.stripeConfig,
      'fedapayConfig': this.fedapayConfig,
    };
  }

  factory PaymentConfig.fromMap(Map<String, dynamic> map) {
    return PaymentConfig(
      digitEasyPayConfig: map['digitEasyPayConfig'] as DigitEasyPayConfig,
      payPalConfig: map['payPalConfig'] as PayPalConfig,
      stripeConfig: map['stripeConfig'] as StripeConfig,
      fedapayConfig: map['fedapayConfig'] as FedapayConfig,
    );
  }

//</editor-fold>
}