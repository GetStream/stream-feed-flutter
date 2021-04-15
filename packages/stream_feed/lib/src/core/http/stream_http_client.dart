import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'package:stream_feed_dart/src/core/exceptions.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/version.dart';
import 'package:stream_feed_dart/src/core/platform_detector/platform_detector.dart';
import 'package:stream_feed_dart/src/core/location.dart';

part 'stream_http_client_options.dart';

///
class StreamHttpClient {
  ///
  StreamHttpClient(
    this.apiKey, {
    StreamHttpClientOptions? options,
  })  : options = options ?? const StreamHttpClientOptions(),
        httpClient = Dio() {
    httpClient
      ..options.receiveTimeout = this.options.receiveTimeout.inMilliseconds
      ..options.connectTimeout = this.options.connectTimeout.inMilliseconds
      ..options.queryParameters = {
        'api_key': apiKey,
        'location': this.options.group,
      }
      ..options.headers = {
        'stream-auth-type': 'jwt',
        'x-stream-client': this.options._userAgent,
      }
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
  }

  /// Your project Stream Chat api key.
  /// Find your API keys here https://getstream.io/dashboard/
  final String apiKey;

  /// Your project Stream Feed clientOptions.
  final StreamHttpClientOptions options;

  /// [Dio] httpClient
  /// It's been chosen because it's easy to use
  /// and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  @visibleForTesting
  final Dio httpClient;

  Exception _parseError(DioError error) {
    if (error.type == DioErrorType.response) {
      final apiError = StreamApiException(
          error.response?.data?.toString(), error.response?.statusCode);
      return apiError;
    }
    return error;
  }

  /// Combines the base url with the [relativeUrl]
  String enrichUrl(String relativeUrl, String serviceName) =>
      '${options._getBaseUrl(serviceName)}/$relativeUrl';

  /// Handy method to make http GET request with error parsing.
  Future<Response<T>> get<T>(
    String path, {
    String serviceName = 'api',
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
  }) async {
    try {
      final response = await httpClient.get<T>(
        enrichUrl(path, serviceName),
        queryParameters: queryParameters?.nullProtected,
        options: Options(headers: headers?.nullProtected),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http POST request with error parsing.
  Future<Response<T>> post<T>(
    String path, {
    String serviceName = 'api',
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
  }) async {
    try {
      final response = await httpClient.post<T>(
        enrichUrl(path, serviceName),
        queryParameters: queryParameters?.nullProtected,
        data: data,
        options: Options(headers: headers?.nullProtected),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http DELETE request with error parsing.
  Future<Response<T>> delete<T>(
    String path, {
    String serviceName = 'api',
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
  }) async {
    try {
      final response = await httpClient.delete<T>(
        enrichUrl(path, serviceName),
        queryParameters: queryParameters?.nullProtected,
        options: Options(headers: headers?.nullProtected),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PATCH request with error parsing.
  Future<Response<T>> patch<T>(
    String path, {
    String serviceName = 'api',
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
  }) async {
    try {
      final response = await httpClient.patch<T>(
        enrichUrl(path, serviceName),
        queryParameters: queryParameters?.nullProtected,
        data: data,
        options: Options(headers: headers?.nullProtected),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PUT request with error parsing.
  Future<Response<T>> put<T>(
    String path, {
    String serviceName = 'api',
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
  }) async {
    try {
      final response = await httpClient.put<T>(
        enrichUrl(path, serviceName),
        queryParameters: queryParameters?.nullProtected,
        data: data,
        options: Options(headers: headers?.nullProtected),
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to post files with error parsing.
  Future<Response<T>> postFile<T>(
    String path,
    MultipartFile file, {
    String serviceName = 'api',
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
  }) async {
    try {
      final formData = FormData.fromMap({'file': file});
      final response = await post<T>(
        path,
        serviceName: serviceName,
        data: formData,
        queryParameters: queryParameters,
        headers: headers,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }
}
