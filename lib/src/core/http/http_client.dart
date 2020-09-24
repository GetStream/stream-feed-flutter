import 'package:dio/dio.dart';

abstract class HttpClient {
  /// Handy method to make http GET request with error parsing.
  Future<Response<String>> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> headers,
  });

  /// Handy method to make http POST request with error parsing.
  Future<Response<String>> post(
    String path, {
    dynamic data,
    Map<String, dynamic> headers,
  });

  /// Handy method to make http DELETE request with error parsing.
  Future<Response<String>> delete(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> headers,
  });

  /// Handy method to make http PATCH request with error parsing.
  Future<Response<String>> patch(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
    Map<String, dynamic> headers,
  });

  /// Handy method to make http PUT request with error parsing.
  Future<Response<String>> put(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
    Map<String, dynamic> headers,
  });
}
