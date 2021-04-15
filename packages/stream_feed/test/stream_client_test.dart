import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';
import 'package:stream_feed_dart/src/client/stream_client_impl.dart';

import 'mock.dart';
import 'utils.dart';

main() {
  group('StreamClientImpl', () {
    test('throws an AssertionError when no secret provided', () {
      expect(
          () => StreamClient.connect('apiKey'),
          throwsA(predicate<AssertionError>((e) =>
              e.message == 'At least a secret or userToken must be provided')));
    });
    test('getters', () async {
      const secret = 'secret';
      const userId = 'userId';
      final client = StreamClientImpl('apiKey', secret: secret);
      // const token = Token('dummyToken');
      // final token = TokenHelper.buildFrontendToken(secret, userId);
      expect(client.collections, isNotNull);
      expect(client.batch, isNotNull);
      expect(client.aggregatedFeed('slug', 'userId'), isNotNull);
      expect(client.flatFeed('slug', 'userId'), isNotNull);
      expect(client.notificationFeed('slug', 'userId'), isNotNull);
      expect(client.files, isNotNull);
      expect(client.images, isNotNull);
      expect(client.reactions, isNotNull);
      expect(client.users, isNotNull);
      expect(client.frontendToken(userId), isNotNull);
    });

    test('openGraph', () async {
      final mockApi = MockApi();
      const secret = 'secret';
      final client = StreamClientImpl('apiKey', secret: secret, api: mockApi);
      // const token = Token('token');
      const targetUrl = 'targetUrl';

      final token = TokenHelper.buildOpenGraphToken(secret);

      when(() => mockApi.openGraph(token, targetUrl)).thenAnswer(
        (_) async =>
            OpenGraphData.fromJson(jsonFixture('open_graph_data.json')!),
      );
      await client.openGraph(targetUrl);
      verify(() => mockApi.openGraph(token, targetUrl)).called(1);
    });
  });
  group('StreamHttpClient', () {
    final streamHttpClient = StreamHttpClient('apiKey');

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

      test('impression', () {
        expect(streamHttpClient.enrichUrl('impression', 'impression'),
            'https://impression.stream-io-api.com/impression/v1.0/impression'); //TODO: weird
      });

      test('engagement', () {
        expect(streamHttpClient.enrichUrl('engagement', 'engagement'),
            'https://engagement.stream-io-api.com/engagement/v1.0/engagement'); //TODO: weird
      });
    });
  });
}
