import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/ui/views/checkout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CountryProvider extends ChangeNotifier{
  List<Country> countries= [];

  bool _isLoading = false;

  bool _hasError = false;

  bool get hasData => countries.isNotEmpty;

  bool get hasError => _hasError;

  Future<void> getCountries(DigitEasyPayCheckout checkout) async {
    if(_isLoading)return;
    if(countries.isNotEmpty)return;

    _hasError = false;
    _isLoading = true;

    notifyListeners();

    countries = await checkout.provider.getAllCountries().whenComplete(() => _isLoading=false).onError((error, stackTrace) {
      _hasError = true;
      notifyListeners();
      throw Exception(error);
    });

    notifyListeners();
  }
}