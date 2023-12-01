import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';

enum DigitEasyPayEnvironment { sandbox, live }

// ignore: constant_identifier_names
enum DigitEasyPayCurrency { AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BAM, BBD, BDT, BGN, BIF, BMD, BND, BOB, BRL, BSD, BWP, BYN, BZD, CAD, CDF, CHF, CLP, CNY, COP, CRC, CVE, CZK, DJF, DKK, DOP, DZD, EGP, ETB, EUR, FJD, FKP, GBP, GEL, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, IDR, ILS, INR, ISK, JMD, JPY, KES, KGS, KHR, KMF, KRW, KYD, KZT, LAK, LBP, LKR, LRD, LSL, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRO, MUR, MVR, MWK, MXN, MYR, MZN, NAD, NGN, NIO, NOK, NPR, NZD, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON, RSD, RUB, RWF, SAR, SBD, SCR, SEK, SGD, SHP, SLE, SLL, SOS, SRD, STD, SZL, THB, TJS, TOP, TRY, TTD, TWD, TZS, UAH, UGX, USD, UYU, UZS, VND, VUV, WST, XAF, XCD, XOF, XPF, YER, ZAR, ZMW }

// ignore: constant_identifier_names
enum TransactionStatus { SUCCESSFUL, PENDING, FAILED }
enum FedapayTransactionStatus{pending, approved, declined, canceled, refunded, transferred}

enum DigitEasyPayPaymentMethod {momo, flooz, visa}

// ignore: constant_identifier_names
enum DigitEasyPayPaymentSource {QOSIC, PAYPAL, STRIPE, KKIAPAY, FEDAPAY}

extension EnvironmentExtension on DigitEasyPayEnvironment {
  bool get isLive => this==DigitEasyPayEnvironment.live;
}

extension DigitEasyPayPaymentMethodExtension on DigitEasyPayPaymentMethod {
  String toIntl(){
    switch(this){
      case DigitEasyPayPaymentMethod.flooz:
        return 'Moov Money';
      case DigitEasyPayPaymentMethod.momo:
        return 'MTN MoMo';
      case DigitEasyPayPaymentMethod.visa:
        return 'Carte bancaire';
    }
  }

  String get icon {
    switch(this){
      case DigitEasyPayPaymentMethod.flooz:
        return PaymentImages.moovMoney;
      case DigitEasyPayPaymentMethod.momo:
        return PaymentImages.mtnMoney;
      case DigitEasyPayPaymentMethod.visa:
        return PaymentImages.mastercardVisa;
    }
  }

  static List<Map<String, dynamic>> toSelectFieldData(){
    return DigitEasyPayPaymentMethod.values.map((e) => {
      'value': e.name.toString(),
      'label': e.toIntl(),
      // 'enable': false,
    }).toList();
  }

  String get toSnakeCase{
    return name.replaceAllMapped(RegExp('(?<=[a-z])[A-Z]'), (m) => '_${m.group(0)}').toLowerCase();
  }
}

typedef DigitEasyPayCallback = void Function(String reference, DigitEasyPayPaymentSource source, String paymentMethod);