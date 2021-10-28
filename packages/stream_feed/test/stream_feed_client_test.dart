import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/stream_feed_client_impl.dart';
import 'package:stream_feed/src/core/index.dart';
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
          () => StreamFeedClient('apiKey'),
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
            () => StreamFeedClient('apiKey', secret: 'secret'),
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
            () => StreamFeedClient(
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
            () => StreamFeedClient(
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
        StreamFeedClient('apiKey', secret: 'secret', runner: Runner.server);
      });

      test("don't throw if token provided while running on client-side", () {
        StreamFeedClient(
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

    test('createUser', () async {
      final mockApi = MockAPI();
      final token = TokenHelper.buildFrontendToken('secret', 'userId');
      final client =
          StreamFeedClientImpl('apiKey', userToken: token, api: mockApi);

      const userId = 'test-user';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };

      when(() => mockApi.users.create(token, userId, data)).thenAnswer(
        (_) async => const User(id: userId, data: data),
      );

      final user = await client.createUser(userId, data);

      expect(user.id, userId);
      expect(user.data, data);

      verify(() => mockApi.users.create(token, userId, data)).called(1);
    });

    test('getUser', () async {
      final mockApi = MockAPI();
      final token = TokenHelper.buildFrontendToken('secret', 'userId');
      final client =
          StreamFeedClientImpl('apiKey', userToken: token, api: mockApi);

      const userId = 'test-user';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };

      when(() => mockApi.users.get(token, userId)).thenAnswer(
        (_) async => const User(id: userId, data: data),
      );

      final user = await client.getUser(userId);

      expect(user.id, userId);
      expect(user.data, data);

      verify(() => mockApi.users.get(token, userId)).called(1);
    });

    test('updateUser', () async {
      final mockApi = MockAPI();
      final token = TokenHelper.buildFrontendToken('secret', 'userId');
      final client =
          StreamFeedClientImpl('apiKey', userToken: token, api: mockApi);

      const userId = 'test-user';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };

      when(() => mockApi.users.update(token, userId, data)).thenAnswer(
        (_) async => const User(id: userId, data: data),
      );

      final user = await client.updateUser(userId, data);

      expect(user.id, userId);
      expect(user.data, data);

      verify(() => mockApi.users.update(token, userId, data)).called(1);
    });

    test('updateUser', () async {
      final mockApi = MockAPI();
      final token = TokenHelper.buildFrontendToken('secret', 'userId');
      final client =
          StreamFeedClientImpl('apiKey', userToken: token, api: mockApi);

      const userId = 'test-user';

      when(() => mockApi.users.delete(token, userId)).thenAnswer(
        (_) async => Future.value(),
      );

      await client.deleteUser(userId);

      verify(() => mockApi.users.delete(token, userId)).called(1);
    });
  });
}
