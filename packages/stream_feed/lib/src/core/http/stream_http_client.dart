import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stream_feed_dart/src/client/stream_client_options.dart';

import 'package:stream_feed_dart/src/core/exceptions.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';

class StreamHttpClient implements HttpClient {
  StreamHttpClient(
    this.apiKey, {
    this.options,
    Dio httpClient,
  }) {
    options ??= const StreamClientOptions();
    _setupDio(httpClient, options);
  }

  /// Your project Stream Chat api key.
  /// Find your API keys here https://getstream.io/dashboard/
  final String apiKey;

  /// Your project Stream Chat base url.
  String get baseURL => options.baseUrl;

  /// Your project Stream Feed clientOptions.
  StreamClientOptions options;

  Duration get receiveTimeout => options.receiveTimeout;

  Duration get connectTimeout => options.connectTimeout;

  String get userAgent => options.userAgent;

  /// [Dio] httpClient
  /// It's be chosen because it's easy to use
  /// and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  @visibleForTesting
  Dio httpClient;

  void _setupDio(
    Dio httpClient,
    StreamClientOptions options,
  ) {
    this.httpClient = httpClient ?? Dio();

    String url;
    if (!baseURL.startsWith('https') && !baseURL.startsWith('http')) {
      url = Uri.https(baseURL, '').toString();
    } else {
      url = baseURL;
    }
    this.httpClient
      ..options.baseUrl = url
      ..options.receiveTimeout = receiveTimeout.inMilliseconds
      ..options.connectTimeout = connectTimeout.inMilliseconds
      ..options.queryParameters = {
        'api_key': apiKey,
      }
      ..options.headers = {
        'stream-auth-type': 'jwt',
        'x-stream-client': userAgent,
      }
      ..interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
  }

  Exception _parseError(DioError error) {
    if (error.type == DioErrorType.RESPONSE) {
      final apiError = StreamApiException(
          error.response?.data?.toString(), error.response?.statusCode);
      return apiError;
    }
    return error;
  }

  /// Handy method to make http GET request with error parsing.
  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> headers,
  }) async {
    try {
      final response = await httpClient.get<T>(
        path,
        queryParameters: queryParameters?.nullProtect,
        options: Options(headers: headers?.nullProtect),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http POST request with error parsing.
  @override
  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
    Map<String, dynamic> headers,
  }) async {
    try {
      final response = await httpClient.post<T>(
        path,
        queryParameters: queryParameters?.nullProtect,
        data: data,
        options: Options(headers: headers?.nullProtect),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http DELETE request with error parsing.
  @override
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> headers,
  }) async {
    try {
      final response = await httpClient.delete<T>(
        path,
        queryParameters: queryParameters?.nullProtect,
        options: Options(headers: headers?.nullProtect),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PATCH request with error parsing.
  @override
  Future<Response<T>> patch<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
    Map<String, dynamic> headers,
  }) async {
    try {
      final response = await httpClient.patch<T>(
        path,
        queryParameters: queryParameters?.nullProtect,
        data: data,
        options: Options(headers: headers?.nullProtect),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PUT request with error parsing.
  @override
  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
    Map<String, dynamic> headers,
  }) async {
    try {
      final response = await httpClient.put<T>(
        path,
        queryParameters: queryParameters?.nullProtect,
        data: data,
        options: Options(headers: headers?.nullProtect),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to post files with error parsing.
  @override
  Future<Response<T>> postFile<T>(
    String path,
    MultipartFile file, {
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> headers,
  }) async {
    try {
      final formData = FormData.fromMap({'file': file});
      final response = await post<T>(
        path,
        queryParameters: queryParameters,
        data: formData,
        headers: headers,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }
}
