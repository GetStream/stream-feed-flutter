import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:test/test.dart';
import 'package:stream_feed_dart/src/client/stream_client_impl.dart';

main() {
  group('StreamHttpClient', () {
    final streamHttpClient = StreamHttpClient('apiKey');

    test('throws an AssertionError when no secret provided', () {
      expect(
          () => StreamClientImpl('apiKey'),
          throwsA(predicate<AssertionError>((e) =>
              e.message == 'At least a secret or userToken must be provided')));
    });
    test('headers', () {
      expect(streamHttpClient.httpClient.options.headers, {
        'stream-auth-type': 'jwt',
        'x-stream-client':
            isA<String>(), //'stream-feed-dart-client-macos-0.0.1',
        'content-type': 'application/json; charset=utf-8'
      });
    });
    group('enrichUrl', () {
      test('api', () {
        expect(streamHttpClient.enrichUrl('feed', 'api'),
            'https://api.stream-io-api.com/api/v1.0/feed');
      });

      test('analytics', () {
        expect(streamHttpClient.enrichUrl('analytics', 'analytics'),
            'https://analytics.stream-io-api.com/analytics/v1.0/analytics'); //TODO: weird
      });
    });
  });
}
