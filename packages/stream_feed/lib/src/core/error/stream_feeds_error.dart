import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_feed/src/core/api/responses.dart';
import 'package:stream_feed/src/core/error/feeds_error_code.dart';

/// A custom [Exception] for printing Stream Feeds specific errors.
class StreamFeedsError with EquatableMixin implements Exception {
  /// Builds a [StreamFeedsError].
  const StreamFeedsError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'StreamFeedsError(message: $message)';
}

/// A custom [Exception] for printing http-related Stream Feeds errors.
class StreamFeedsNetworkError extends StreamFeedsError {
  /// Builds a [StreamFeedsNetworkError].
  StreamFeedsNetworkError(
    FeedsError errorCode, {
    int? statusCode,
    this.data,
  })  : code = errorCode.code,
        statusCode = statusCode ?? data?.statusCode,
        super(errorCode.message);

  StreamFeedsNetworkError.raw({
    required this.code,
    required String message,
    this.statusCode,
    this.data,
  }) : super(message);

  /// Builds a [StreamFeedsNetworkError] from a [DioException].
  factory StreamFeedsNetworkError.fromDioError(DioException error) {
    final response = error.response;
    ErrorResponse? errorResponse;
    final data = json.decode(response?.data);
    if (data != null) {
      errorResponse = ErrorResponse.fromJson(data);
    }
    return StreamFeedsNetworkError.raw(
      code: errorResponse?.code ?? -1,
      message:
          errorResponse?.message ?? response?.statusMessage ?? error.message!,
      statusCode: errorResponse?.statusCode ?? response?.statusCode,
      data: errorResponse,
    )..stackTrace = error.stackTrace;
  }

  /// Error code
  final int code;

  /// HTTP status code
  final int? statusCode;

  /// Response body. please refer to [ErrorResponse].
  final ErrorResponse? data;

  StackTrace? _stackTrace;

  set stackTrace(StackTrace? stack) => _stackTrace = stack;

  FeedsError? get errorCode => feedsErrorCodeFromCode(code);

  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code, statusCode];

  @override
  String toString({bool printStackTrace = false}) {
    var params = 'code: $code, message: $message';
    if (statusCode != null) params += ', statusCode: $statusCode';
    if (data != null) params += ', data: $data';
    var msg = 'StreamFeedsNetworkError($params)';

    if (printStackTrace && _stackTrace != null) {
      msg += '\n$_stackTrace';
    }
    return msg;
  }
}
