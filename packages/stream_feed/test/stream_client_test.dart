import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';
import 'package:stream_feed/src/client/stream_client_impl.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  group('StreamClientImpl', () {
    group('throw', () {
      test('throws an AssertionError when no secret provided', () {
        expect(
          () => StreamClient.connect('apiKey'),
          throwsA(
            predicate<AssertionError>((e) =>
                e.message == 'At least a secret or userToken must be provided'),
          ),
        );
      });

      test('throws an AssertionError if secret provided alone', () {
        expect(
          () => StreamClient.connect('apiKey', secret: 'secret'),
          throwsA(
            predicate<AssertionError>(
                (e) => e.message == 'you should not use a secret clientside'),
          ),
        );
      });

      test("don't throw if secret provided with clientSide false", () {
        StreamClient.connect('apiKey', secret: 'secret', clientSide: false);
      });

      test("don't throw if token provided ", () {
        StreamClient.connect('apiKey',
            token: TokenHelper.buildFrontendToken('secret', 'userId'));
      });
    });
    test('getters', () async {
      const secret = 'secret';
      const userId = 'userId';
      final client =
          StreamClientImpl('apiKey', secret: secret, clientSide: false);
      expect(client.collections, isNotNull);
      expect(client.batch, isNotNull);
      expect(client.aggregatedFeed('slug', 'userId'), isNotNull);
      expect(client.flatFeed('slug', 'userId'), isNotNull);
      expect(client.notificationFeed('slug', 'userId'), isNotNull);
      expect(client.files, isNotNull);
      expect(client.images, isNotNull);
      expect(client.reactions, isNotNull);
      expect(client.user(userId), isNotNull);
      expect(client.frontendToken(userId), isNotNull);
    });

    test('openGraph', () async {
      final mockApi = MockAPI();
      when(() => mockApi.users).thenReturn(MockUserAPI());
      final token = TokenHelper.buildFrontendToken('secret', 'userId');
      final client = StreamClientImpl('apiKey', userToken: token, api: mockApi);

      const targetUrl = 'targetUrl';

      when(() => mockApi.openGraph(token, targetUrl)).thenAnswer(
        (_) async =>
            OpenGraphData.fromJson(jsonFixture('open_graph_data.json')),
      );
      await client.og(targetUrl);
      verify(() => mockApi.openGraph(token, targetUrl)).called(1);
    });
  });
}
