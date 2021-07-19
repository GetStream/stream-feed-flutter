import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/stream_feed_client_impl.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  group('StreamFeedClientImpl', () {
    group('throw', () {
      test('throws an AssertionError when no secret or token provided', () {
        expect(
          () => StreamFeedClient.connect('apiKey'),
          throwsA(
            predicate<AssertionError>((e) =>
                e.message == 'At least a secret or userToken must be provided'),
          ),
        );
      });

      test(
        'throws an AssertionError if token is not provided '
        'while running on client-side',
        () {
          expect(
            () => StreamFeedClient.connect('apiKey', secret: 'secret'),
            throwsA(
              predicate<AssertionError>(
                (e) =>
                    e.message ==
                    '`userToken` must be provided while running on client-side',
              ),
            ),
          );
        },
      );

      test(
        'throws an AssertionError if secret is not provided '
        'while running on server-side',
        () {
          expect(
            () => StreamFeedClient.connect(
              'apiKey',
              token: TokenHelper.buildFrontendToken('secret', 'userId'),
              runner: Runner.server,
            ),
            throwsA(
              predicate<AssertionError>(
                (e) =>
                    e.message ==
                    '`secret` must be provided while running on server-side',
              ),
            ),
          );
        },
      );

      test(
        'throws an AssertionError if secret is provided '
        'while running on client-side',
        () {
          expect(
            () => StreamFeedClient.connect(
              'apiKey',
              secret: 'secret',
              token: TokenHelper.buildFrontendToken('secret', 'userId'),
            ),
            throwsA(
              predicate<AssertionError>(
                (e) =>
                    e.message ==
                    'You are publicly sharing your App Secret. '
                        'Do not expose the App Secret in `browsers`, '
                        '`native` mobile apps, or other non-trusted environments. ',
              ),
            ),
          );
        },
      );

      test("don't throw if secret provided while running on server-side", () {
        StreamFeedClient.connect('apiKey',
            secret: 'secret', runner: Runner.server);
      });

      test("don't throw if token provided while running on client-side", () {
        StreamFeedClient.connect(
          'apiKey',
          token: TokenHelper.buildFrontendToken('secret', 'userId'),
        );
      });
    });
    test('getters', () async {
      const secret = 'secret';
      const userId = 'userId';
      final client =
          StreamFeedClientImpl('apiKey', secret: secret, runner: Runner.server);
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
      final client =
          StreamFeedClientImpl('apiKey', userToken: token, api: mockApi);

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
