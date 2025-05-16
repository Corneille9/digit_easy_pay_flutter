/// CountryProvider Class
///
/// This class provides a list of countries and handles the retrieval of country data for a payment checkout. It also manages loading and error states and can be used in combination with a Flutter provider for state management.
import 'package:digit_easy_pay_flutter/src/common/base_state_provider.dart';
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:flutter/foundation.dart';

import '../common/payment_constants.dart';
import '../http/payment_service.dart';

class CountryProvider extends BaseStateProvider {
  List<Country> countries = [];

  /// Get whether the provider has data (countries).
  bool get hasData => countries.isNotEmpty;

  final PaymentService service;

  CountryProvider({required this.service});

  /// Retrieve a list of countries for a payment checkout.
  ///
  /// @param checkout The DigitEasyPayCheckout instance used to access the payment provider.
  Future<void> init() async {
    try {
      if (isLoading) return;

      if (countries.isNotEmpty) return;

      setStatus(RequestStatus.loading);

      countries = await service.getAllCountries();

      setStatus(RequestStatus.success);
    } catch (e, s) {
      debugPrint("Error retrieving countries: $e");
      debugPrint("Stack trace: $s");
      setStatus(RequestStatus.error);
    }
  }
}
