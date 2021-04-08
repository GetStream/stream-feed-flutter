import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:test/test.dart';

main() {
  test('StreamHttpClient', () {
    final streamHttpClient = StreamHttpClient("apiKey");
    expect(streamHttpClient.httpClient.options.headers, {
      'stream-auth-type': 'jwt',
      'x-stream-client': isA<String>(), //'stream-feed-dart-client-macos-0.0.1',
      'content-type': 'application/json; charset=utf-8'
    });
  });
}
