
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';

class CardPayRequest{
  final String phoneNumber;
  final num totalAmount;
  final String firstName;
  final String lastName;
  final String middleName;
  final DigitEasyPayCurrency currency;
  final String title;
  final String city;
  final String address2;
  final String town;
  final String department;
  final String buildingNumber;
  final String email;
  final String postalCode;
  final String emailDomain;
  final Country country;
  final String iso2Code;

  const CardPayRequest({
    required this.phoneNumber,
    required this.totalAmount,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.currency,
    required this.title,
    required this.city,
    required this.address2,
    required this.town,
    required this.department,
    required this.buildingNumber,
    required this.email,
    this.postalCode = "",
    this.emailDomain = "",
    required this.country,
    this.iso2Code = "",
  });


  @override
  String toString() {
    return 'CardPayRequest{phoneNumber: $phoneNumber, totalAmount: $totalAmount, firstName: $firstName, lastName: $lastName, middleName: $middleName, currency: $currency, title: $title, city: $city, address2: $address2, town: $town, department: $department, buildingNumber: $buildingNumber, email: $email, postalCode: $postalCode, emailDomain: $emailDomain, country: $country, iso2Code: $iso2Code}';
  }

  CardPayRequest copyWith({
    String? phoneNumber,
    num? totalAmount,
    String? firstName,
    String? lastName,
    String? middleName,
    DigitEasyPayCurrency? currency,
    String? title,
    String? city,
    String? address2,
    String? town,
    String? department,
    String? buildingNumber,
    String? email,
    String? postalCode,
    String? emailDomain,
    Country? country,
    String? iso2Code,
  }) {
    return CardPayRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      currency: currency ?? this.currency,
      title: title ?? this.title,
      city: city ?? this.city,
      address2: address2 ?? this.address2,
      town: town ?? this.town,
      department: department ?? this.department,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      email: email ?? this.email,
      postalCode: postalCode ?? this.postalCode,
      emailDomain: emailDomain ?? this.emailDomain,
      country: country ?? this.country,
      iso2Code: iso2Code ?? this.iso2Code,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'phoneNumber': this.phoneNumber,
      'totalAmount': this.totalAmount,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'middleName': this.middleName,
      'currency': this.currency.name,
      'title': this.title,
      'city': this.city,
      'address2': this.address2,
      'town': this.town,
      'department': this.department,
      'buildingNumber': this.buildingNumber,
      'email': this.email,
      // 'postalCode': this.postalCode,
      // 'emailDomain': this.emailDomain,
      'country': this.country.toMap(),
      // 'iso2Code': this.iso2Code,
    };
    // map.removeWhere((key, value) => value.toString().isEmpty);
    return map;
  }

  factory CardPayRequest.fromMap(Map<String, dynamic> map) {
    return CardPayRequest(
      phoneNumber: map['phoneNumber'] as String,
      totalAmount: map['totalAmount'] as num,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      middleName: map['middleName'] as String,
      currency: map['currency'] as DigitEasyPayCurrency,
      title: map['title'] as String,
      city: map['city'] as String,
      address2: map['address2'] as String,
      town: map['town'] as String,
      department: map['department'] as String,
      buildingNumber: map['buildingNumber'] as String,
      email: map['email'] as String,
      postalCode: map['postalCode'] as String,
      emailDomain: map['emailDomain'] as String,
      country: map['country'] as Country,
      iso2Code: map['iso2Code'] as String,
    );
  }
}