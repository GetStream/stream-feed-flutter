import 'package:stream_feed_dart/src/core/exceptions.dart';
import 'package:test/test.dart';

main() {
  test('StreamApiException', () {
    final streamApiException = StreamApiException('{"code":404}', 404);
    expect(streamApiException.code, 404);
  });
}
