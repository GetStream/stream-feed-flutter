import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'http_client.dart';

import '../core/exceptions.dart';

typedef LogHandlerFunction = void Function(LogRecord record);
typedef DecoderFunction<T> = T Function(Map<String, dynamic>);
typedef TokenProvider = Future<String> Function(String userId);

class StreamHttpClient implements HttpClient {
  StreamHttpClient(this.apiKey, {
    this.tokenProvider,
    this.baseURL = _defaultBaseURL,
    this.logLevel = Level.WARNING,
    this.logHandlerFunction,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    Dio httpClient,
  }) {
    _setupLogger();
    _setupDio(httpClient, receiveTimeout, connectTimeout);

    logger.info('instantiating new client');
  }

  /// By default the Chat Client will write all messages with level Warn or Error to stdout.
  /// During development you might want to enable more logging information, you can change the default log level when constructing the client.
  ///
  /// ```dart
  /// final client = Client("stream-feed-api-key", logLevel: Level.INFO);
  /// ```
  final Level logLevel;

  /// Client specific logger instance.
  /// Refer to the class [Logger] to learn more about the specific implementation.
  final Logger logger = Logger('📡');

  /// A function that has a parameter of type [LogRecord].
  /// This is called on every new log record.
  /// By default the client will use the handler returned by [_getDefaultLogHandler].
  /// Setting it you can handle the log messages directly instead of have them written to stdout,
  /// this is very convenient if you use an error tracking tool or if you want to centralize your logs into one facility.
  ///
  /// ```dart
  /// myLogHandlerFunction = (LogRecord record) {
  ///  // do something with the record (ie. send it to Sentry or Fabric)
  /// }
  ///
  /// final client = Client("stream-chat-api-key", logHandlerFunction: myLogHandlerFunction);
  ///```
  LogHandlerFunction logHandlerFunction;

  /// Your project Stream Chat api key.
  /// Find your API keys here https://getstream.io/dashboard/
  final String apiKey;

  /// Your project Stream Chat base url.
  final String baseURL;

  /// [Dio] httpClient
  /// It's be chosen because it's easy to use and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  @visibleForTesting
  Dio httpClient = Dio();

  /// A function in which you send a request to your own backend to get a Stream Chat API token.
  /// The token will be the return value of the function.
  /// It's used by the client to refresh the token once expired or to set the user without a predefined token using [setUserWithProvider].
  final TokenProvider tokenProvider;

  static const _defaultBaseURL =
      'https://us-east-api.stream-io-api.com/api/v1.0/';

  void _setupLogger() {
    Logger.root.level = logLevel;

    logHandlerFunction ??= _getDefaultLogHandler();

    logger.onRecord.listen(logHandlerFunction);

    logger.info('logger setup');
  }

  void _setupDio(Dio httpClient,
      Duration receiveTimeout,
      Duration connectTimeout,) {
    logger.info('http client setup');

    this.httpClient = httpClient ?? Dio();

    String url;
    if (!baseURL.startsWith('https') && !baseURL.startsWith('http')) {
      url = Uri.https(baseURL, '').toString();
    } else {
      url = baseURL;
    }

    this.httpClient.options.baseUrl = url;
    this.httpClient.options.receiveTimeout = receiveTimeout.inMilliseconds;
    this.httpClient.options.connectTimeout = connectTimeout.inMilliseconds;
    this.httpClient.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      logPrint: logger.info,
    ));
  }

  LogHandlerFunction _getDefaultLogHandler() {
    final levelEmojiMapper = {
      Level.INFO.name: 'ℹ️',
      Level.WARNING.name: '⚠️',
      Level.SEVERE.name: '🚨',
    };
    return (LogRecord record) {
      print(
          '(${record.time}) ${levelEmojiMapper[record.level.name] ??
              record.level.name} ${record.loggerName} ${record.message}');
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    };
  }

  Exception _parseError(DioError error) {
    if (error.type == DioErrorType.RESPONSE) {
      final apiError =
      ApiError(error.response?.data, error.response?.statusCode);
      logger.severe('apiError: ${apiError.toString()}');
      return apiError;
    }

    return error;
  }

  /// Handy method to make http GET request with error parsing.
  @override
  Future<Response<String>> get(String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await httpClient.get<String>(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http POST request with error parsing.
  @override
  Future<Response<String>> post(String path, {
    dynamic data,
  }) async {
    try {
      final response = await httpClient.post<String>(path, data: data);
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http DELETE request with error parsing.
  @override
  Future<Response<String>> delete(String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await httpClient.delete<String>(path,
          queryParameters: queryParameters);
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PATCH request with error parsing.
  @override
  Future<Response<String>> patch(String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.patch<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PUT request with error parsing.
  @override
  Future<Response<String>> put(String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.put<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }
}
