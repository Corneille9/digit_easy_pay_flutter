import 'dart:convert';
import 'dart:io';

import 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class PaymentHttpClient {

  final DigitEasyPayConfig _config;

  PaymentHttpClient({required DigitEasyPayConfig config}): _config = config;

  Dio? _dio;

  Dio get dio => _dio!;

  Future<void> ensureInitialized() async {
    if(_dio!=null)return;

    _dio = Dio(BaseOptions(baseUrl: _config.environment.isLive?"https://api.digiteasypay.com/digit-pay/api":"https://digitpay.myroobot.com/digit-pay/api", responseType: ResponseType.json, contentType: "application/json; charset=utf-8"));
    _dio?.options.headers.addAll({
        HttpHeaders.authorizationHeader: 'Basic ${_getEncodedAuthorization()}',
        'userKey': _config.userKey
      },);
  }

  void dispose() async {
    _dio?.options.headers.clear();
  }

  Future<Response> post({required String path, dynamic data = const {}, Map<String, dynamic> queryParameters = const {}, bool useFormData = false})async{
    await ensureInitialized();
    var response = await dio.post(path, data: useFormData?FormData.fromMap(data):data, queryParameters: queryParameters);
    return response;
  }

  Future<Response> get({required String path, Map<String, dynamic> queryParameters = const {}})async{
    await ensureInitialized();
    var response = await dio.get(path, queryParameters: queryParameters,);
    return response;
  }

  Future<Response> patch({required String path, dynamic data = const {}, Map<String, dynamic> queryParameters = const {}})async{
    await ensureInitialized();
    var response = await dio.patch(path, data: data, queryParameters: queryParameters,);
    return response;
  }

  Future<Response> put({required String path, dynamic data = const {}, Map<String, dynamic> queryParameters = const {}})async{
    await ensureInitialized();
    var response = await dio.put(path, data: data, queryParameters: queryParameters,);
    return response;
  }

  Future<Response> delete({required String path, Map<String, dynamic> data = const {}, Map<String, dynamic> queryParameters = const {}})async{
    await ensureInitialized();
    var response = await dio.delete(path, data: data, queryParameters: queryParameters);
    return response;
  }

  String _getEncodedAuthorization() {
    return base64.encode(utf8.encode('${_config.username}:${_config.password}'));
  }
}
