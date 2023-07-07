import 'package:dio/dio.dart' hide Headers;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stream_feed/src/core/error/stream_feeds_dio_error.dart';
import 'package:stream_feed/src/core/error/stream_feeds_error.dart';
import 'package:stream_feed/src/core/http/interceptor/logging_interceptor.dart';
import 'package:stream_feed/src/core/http/location.dart';
import 'package:stream_feed/src/core/http/typedefs.dart';
import 'package:stream_feed/src/core/platform_detector/platform_detector.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/version.dart';

part 'stream_http_client_options.dart';

/// This is where we configure the base url, headers, query parameters and
/// convenience methods for http verbs with error parsing.
class StreamHttpClient {
  /// [StreamHttpClient] constructor
  StreamHttpClient(
    this.apiKey, {
    Dio? dio,
    StreamHttpClientOptions? options,
    Logger? logger,
  })  : options = options ?? const StreamHttpClientOptions(),
        httpClient = dio ?? Dio() {
    httpClient
      ..options.receiveTimeout = this.options.receiveTimeout
      ..options.connectTimeout = this.options.connectTimeout
      ..options.queryParameters = {
        'api_key': apiKey,
        'location': this.options.group,
      }
      ..options.headers = {
        'stream-auth-type': 'jwt',
        'x-stream-client': this.options._userAgent,
      }
      ..interceptors.addAll([
        if (logger != null && logger.level != Level.OFF)
          LoggingInterceptor(
            requestHeader: true,
            logPrint: (step, message) {
              switch (step) {
                case InterceptStep.request:
                  return logger.info(message);
                case InterceptStep.response:
                  return logger.info(message);
                case InterceptStep.error:
                  return logger.severe(message);
              }
            },
          ),
      ]);
  }

  /// Your project Stream Feed api key.
  ///
  /// Find your API keys here https://getstream.io/dashboard/.
  ///
  /// An API key can be safely shared with untrusted entities.
  final String apiKey;

  /// Your project Stream Feed clientOptions.
  final StreamHttpClientOptions options;

  /// [Dio] `httpClient`.
  ///
  /// Dio was chosen because it's easy to use and supports interesting features
  /// out of the box (Interceptors, Global configuration, FormData, File
  /// downloading etc.)
  @visibleForTesting
  final Dio httpClient;

  StreamFeedsNetworkError _parseError(DioError err) {
    StreamFeedsNetworkError error;
    // locally thrown dio error
    if (err is StreamFeedsDioError) {
      error = err.error;
    } else {
      // real network request dio error
      error = StreamFeedsNetworkError.fromDioError(err);
    }
    return error..stackTrace = err.stackTrace;
  }

  /// Combines the base url with the [relativeUrl]
  String enrichUrl(String relativeUrl, String serviceName) =>
      '${options._getBaseUrl(serviceName)}/$relativeUrl';

  /// Handy method to make an http GET request with error parsing.
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

  /// Handy method to make an http POST request with error parsing.
  Future<Response<T>> post<T>(
    String path, {
    String serviceName = 'api',
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    OnSendProgress? onSendProgress,
    OnReceiveProgress? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.post<T>(enrichUrl(path, serviceName),
          queryParameters: queryParameters?.nullProtected,
          data: data,
          options: Options(headers: headers?.nullProtected),
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken);
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make an http DELETE request with error parsing.
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

  /// Handy method to make an http PATCH request with error parsing.
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

  /// Handy method to make an http PUT request with error parsing.
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
  Future<Response<T>> postFile<T>(String path, MultipartFile file,
      {String serviceName = 'api',
      Map<String, Object?>? queryParameters,
      Map<String, Object?>? headers,
      OnSendProgress? onSendProgress,
      OnReceiveProgress? onReceiveProgress,
      CancelToken? cancelToken}) async {
    try {
      final formData = FormData.fromMap({'file': file});
      final response = await post<T>(path,
          serviceName: serviceName,
          data: formData,
          queryParameters: queryParameters,
          headers: headers,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken);
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }
}
