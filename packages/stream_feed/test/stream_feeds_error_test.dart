import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/api/responses.dart';
import 'package:stream_feed/src/core/error/feeds_error_code.dart';
import 'package:stream_feed/src/core/error/stream_feeds_error.dart';
import 'package:test/test.dart';

void main() {
  group('StreamFeedNetworkError', () {
    test('.raw', () {
      const code = 400;
      const message = 'test-error-message';
      final error = StreamFeedsNetworkError.raw(code: code, message: message);
      expect(error, isNotNull);
      expect(error.code, code);
      expect(error.message, message);
    });

    test('.fromDioError', () {
      const code = 333;
      const statusCode = 666;
      const message = 'test-error-message';
      final options = RequestOptions(path: 'test-path');
      const data = ErrorResponse(
        code: code,
        message: message,
        statusCode: statusCode,
      );

      final dioError = DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: data.statusCode,
          data: json.encode(data.toJson()),
        ),
      );
      final error = StreamFeedsNetworkError.fromDioError(dioError);
      expect(error, isNotNull);
      expect(error.code, code);
      expect(error.message, message);
      expect(error.statusCode, statusCode);
      expect(error.data?.code, data.code);
      expect(error.data?.statusCode, data.statusCode);
      expect(error.data?.message, data.message);
    });
  });

  test('should match if message, code and statusCode is same', () {
    const code = 333;
    const statusCode = 666;
    const message = 'test-error-message';
    final error = StreamFeedsNetworkError.raw(
      code: code,
      statusCode: statusCode,
      message: message,
    );
    final error2 = StreamFeedsNetworkError.raw(
      code: code,
      statusCode: statusCode,
      message: message,
    );

    expect(error, error2);
  });

  test('`.isRetrievable` should return true if data is not present', () {
    const errorCode = FeedsError.authenticationFailed;
    final error = StreamFeedsNetworkError(errorCode);

    expect(error.isRetriable, isTrue);
  });
}
