import 'package:stream_feed_dart/src/core/api/stream_api_impl.dart';
import 'package:test/test.dart';

import 'mock.dart';

main() {
  test('streamApi', () {
    final mockClient = MockHttpClient();

    final streamApi = StreamApiImpl('apiKey', client: mockClient);
    expect(streamApi.collections, isNotNull);
    expect(streamApi.batch, isNotNull);
    expect(streamApi.feed, isNotNull);
    expect(streamApi.files, isNotNull);
    expect(streamApi.images, isNotNull);
    expect(streamApi.reactions, isNotNull);
    expect(streamApi.users, isNotNull);
  });
}
