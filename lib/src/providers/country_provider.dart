/// CountryProvider Class
///
/// This class provides a list of countries and handles the retrieval of country data for a payment checkout. It also manages loading and error states and can be used in combination with a Flutter provider for state management.
import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/ui/views/checkout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CountryProvider extends ChangeNotifier {
  List<Country> countries = [];
  bool _isLoading = false;
  bool _hasError = false;

  /// Get whether the provider has data (countries).
  bool get hasData => countries.isNotEmpty;

  /// Get whether the provider has encountered an error.
  bool get hasError => _hasError;

  /// Retrieve a list of countries for a payment checkout.
  ///
  /// @param checkout The DigitEasyPayCheckout instance used to access the payment provider.
  Future<void> getCountries(DigitEasyPayCheckout checkout) async {
    if (_isLoading) return;
    if (countries.isNotEmpty) return;

    _hasError = false;
    _isLoading = true;

    notifyListeners();

    countries = await checkout.provider.getAllCountries().whenComplete(() => _isLoading = false).onError((error, stackTrace) {
      _hasError = true;
      notifyListeners();

      if (error is DioException) {
        DigitEasyPayException.interpretError(error);
      }

      throw DigitEasyPayException(error.toString());
    });

    notifyListeners();
  }
}
