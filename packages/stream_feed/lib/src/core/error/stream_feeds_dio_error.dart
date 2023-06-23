import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/error/stream_feeds_error.dart';

/// Error class specific to StreamFeed and Dio
class StreamFeedsDioError extends DioError {
  /// Initialize a stream feed dio error
  StreamFeedsDioError({
    required this.error,
    required RequestOptions requestOptions,
    Response? response,
    DioErrorType type = DioErrorType.unknown,
  }) : super(
          error: error,
          requestOptions: requestOptions,
          response: response,
          type: type,
        );

  @override
  final StreamFeedsNetworkError error;
}
