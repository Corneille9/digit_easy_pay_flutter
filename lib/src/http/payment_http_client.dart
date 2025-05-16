/// PaymentHttpClient Class
///
/// This class provides an HTTP client for making network requests to the DigitEasyPay API. It handles the configuration of the HTTP client and provides methods for making various types of HTTP requests, such as POST, GET, PATCH, PUT, and DELETE.
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../models/gateways/qosic_config.dart';

class PaymentHttpClient {
  final QosicConfig _config;
  Dio? _dio;

  /// Constructor for the PaymentHttpClient class.
  ///
  /// Initializes the HTTP client with the provided DigitEasyPayConfig.
  ///
  /// @param config The DigitEasyPayConfig object containing the configuration details.
  PaymentHttpClient({required QosicConfig config}) : _config = config;

  /// Get the Dio instance for making network requests.
  Dio get dio => _dio!;

  /// Ensure that the HTTP client is initialized. If it's already initialized, this method does nothing.
  Future<void> ensureInitialized() async {
    if (_dio != null) return;

    _dio = Dio(
      BaseOptions(
        baseUrl:
            !_config.sandbox
                ? "https://api.digiteasypay.com/digit-pay/api"
                : "https://digitpay.myroobot.com/digit-pay/api",
        responseType: ResponseType.json,
        contentType: "application/json; charset=utf-8",
      ),
    );

    _dio?.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Basic ${_getEncodedAuthorization()}',
      'userKey': _config.userKey,
    });
  }

  /// Dispose of the HTTP client by clearing the headers.
  void dispose() async {
    _dio?.options.headers.clear();
  }

  /// Send a POST request to the specified path.
  ///
  /// @param path The path for the POST request.
  /// @param data The request data to be sent.
  /// @param queryParameters Additional query parameters for the request.
  /// @param useFormData Whether to use form data for the request (optional).
  /// @return A Response object containing the result of the POST request.
  Future<Response> post({
    required String path,
    dynamic data = const {},
    Map<String, dynamic> queryParameters = const {},
    bool useFormData = false,
  }) async {
    await ensureInitialized();
    var response = await dio.post(
      path,
      data: useFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameters,
    );
    return response;
  }

  /// Send a GET request to the specified path.
  ///
  /// @param path The path for the GET request.
  /// @param queryParameters Additional query parameters for the request.
  /// @return A Response object containing the result of the GET request.
  Future<Response> get({
    required String path,
    Map<String, dynamic> queryParameters = const {},
  }) async {
    await ensureInitialized();
    var response = await dio.get(path, queryParameters: queryParameters);
    return response;
  }

  /// Send a PATCH request to the specified path.
  ///
  /// @param path The path for the PATCH request.
  /// @param data The request data to be sent.
  /// @param queryParameters Additional query parameters for the request.
  /// @return A Response object containing the result of the PATCH request.
  Future<Response> patch({
    required String path,
    dynamic data = const {},
    Map<String, dynamic> queryParameters = const {},
  }) async {
    await ensureInitialized();
    var response = await dio.patch(path, data: data, queryParameters: queryParameters);
    return response;
  }

  /// Send a PUT request to the specified path.
  ///
  /// @param path The path for the PUT request.
  /// @param data The request data to be sent.
  /// @param queryParameters Additional query parameters for the request.
  /// @return A Response object containing the result of the PUT request.
  Future<Response> put({
    required String path,
    dynamic data = const {},
    Map<String, dynamic> queryParameters = const {},
  }) async {
    await ensureInitialized();
    var response = await dio.put(path, data: data, queryParameters: queryParameters);
    return response;
  }

  /// Send a DELETE request to the specified path.
  ///
  /// @param path The path for the DELETE request.
  /// @param data Additional data to be sent with the request.
  /// @param queryParameters Additional query parameters for the request.
  /// @return A Response object containing the result of the DELETE request.
  Future<Response> delete({
    required String path,
    Map<String, dynamic> data = const {},
    Map<String, dynamic> queryParameters = const {},
  }) async {
    await ensureInitialized();
    var response = await dio.delete(path, data: data, queryParameters: queryParameters);
    return response;
  }

  /// Get the encoded authorization header value.
  String _getEncodedAuthorization() {
    return base64.encode(utf8.encode('${_config.username}:${_config.password}'));
  }
}
