import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';

// ignore: constant_identifier_names
enum Currency {
  AED,
  AFN,
  ALL,
  AMD,
  ANG,
  AOA,
  ARS,
  AUD,
  AWG,
  AZN,
  BAM,
  BBD,
  BDT,
  BGN,
  BIF,
  BMD,
  BND,
  BOB,
  BRL,
  BSD,
  BWP,
  BYN,
  BZD,
  CAD,
  CDF,
  CHF,
  CLP,
  CNY,
  COP,
  CRC,
  CVE,
  CZK,
  DJF,
  DKK,
  DOP,
  DZD,
  EGP,
  ETB,
  EUR,
  FJD,
  FKP,
  GBP,
  GEL,
  GIP,
  GMD,
  GNF,
  GTQ,
  GYD,
  HKD,
  HNL,
  HRK,
  HTG,
  HUF,
  IDR,
  ILS,
  INR,
  ISK,
  JMD,
  JPY,
  KES,
  KGS,
  KHR,
  KMF,
  KRW,
  KYD,
  KZT,
  LAK,
  LBP,
  LKR,
  LRD,
  LSL,
  MAD,
  MDL,
  MGA,
  MKD,
  MMK,
  MNT,
  MOP,
  MRO,
  MUR,
  MVR,
  MWK,
  MXN,
  MYR,
  MZN,
  NAD,
  NGN,
  NIO,
  NOK,
  NPR,
  NZD,
  PAB,
  PEN,
  PGK,
  PHP,
  PKR,
  PLN,
  PYG,
  QAR,
  RON,
  RSD,
  RUB,
  RWF,
  SAR,
  SBD,
  SCR,
  SEK,
  SGD,
  SHP,
  SLE,
  SLL,
  SOS,
  SRD,
  STD,
  SZL,
  THB,
  TJS,
  TOP,
  TRY,
  TTD,
  TWD,
  TZS,
  UAH,
  UGX,
  USD,
  UYU,
  UZS,
  VND,
  VUV,
  WST,
  XAF,
  XCD,
  XOF,
  XPF,
  YER,
  ZAR,
  ZMW,
}

// ignore: constant_identifier_names
enum TransactionStatus { SUCCESSFUL, PENDING, FAILED }

enum FedapayTransactionStatus { pending, approved, declined, canceled, refunded, transferred }

enum QosicPaymentGateway { momo, flooz, visa }

// ignore: constant_identifier_names
enum PaymentGateway { QOSIC, PAYPAL, STRIPE, KKIAPAY, FEDAPAY }

extension PaymentGatewayX on PaymentGateway {
  String get icon {
    switch (this) {
      case PaymentGateway.QOSIC:
        return PaymentImages.digitEasyPay;
      case PaymentGateway.PAYPAL:
        return PaymentImages.paypal;
      case PaymentGateway.STRIPE:
        return PaymentImages.stripe;
      case PaymentGateway.KKIAPAY:
        return PaymentImages.digitEasyPayDark;
      case PaymentGateway.FEDAPAY:
        return PaymentImages.fedapay;
    }
  }

  String get displayName {
    switch (this) {
      case PaymentGateway.QOSIC:
        return 'Digit Easy Pay';
      case PaymentGateway.PAYPAL:
        return 'PayPal';
      case PaymentGateway.STRIPE:
        return 'Stripe';
      case PaymentGateway.KKIAPAY:
        return 'KkiaPay';
      case PaymentGateway.FEDAPAY:
        return 'Fedapay';
    }
  }

  String get description {
    switch (this) {
      case PaymentGateway.QOSIC:
        return 'Mtn, Moov, Visa';
      case PaymentGateway.PAYPAL:
        return 'Visa, MasterCard, and other ...';
      case PaymentGateway.STRIPE:
        return 'Visa, MasterCard, and other ...';
      case PaymentGateway.KKIAPAY:
        return 'Mtn, Moov, Visa, and other ...';
      case PaymentGateway.FEDAPAY:
        return 'Mtn, Moov, Celtis';
    }
  }

  bool get hasSubMethods {
    switch (this) {
      case PaymentGateway.QOSIC:
        return true;
      case PaymentGateway.PAYPAL:
        return false;
      case PaymentGateway.STRIPE:
        return false;
      case PaymentGateway.KKIAPAY:
        return false;
      case PaymentGateway.FEDAPAY:
        return false;
    }
  }
}

extension DigitEasyPayPaymentMethodExtension on QosicPaymentGateway {
  String toIntl() {
    switch (this) {
      case QosicPaymentGateway.flooz:
        return 'Moov Money';
      case QosicPaymentGateway.momo:
        return 'MTN Mobile Money';
      case QosicPaymentGateway.visa:
        return 'Carte bancaire';
    }
  }

  String get icon {
    switch (this) {
      case QosicPaymentGateway.flooz:
        return PaymentImages.moovMoney;
      case QosicPaymentGateway.momo:
        return PaymentImages.mtnMoney;
      case QosicPaymentGateway.visa:
        return PaymentImages.mastercardVisa;
    }
  }

  static List<Map<String, dynamic>> toSelectFieldData() {
    return QosicPaymentGateway.values
        .map(
          (e) => {
            'value': e.name.toString(),
            'label': e.toIntl(),
            // 'enable': false,
          },
        )
        .toList();
  }

  String get toSnakeCase {
    return name.replaceAllMapped(RegExp('(?<=[a-z])[A-Z]'), (m) => '_${m.group(0)}').toLowerCase();
  }
}

enum RequestStatus { initial, loading, processing, success, error }
