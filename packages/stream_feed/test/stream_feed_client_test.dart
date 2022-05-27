import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/stream_feed_client_impl.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  late Map<String, String> data;
  late String userId;
  late User user;
  late MockAPI mockApi;
  late MockUserAPI mockUserAPI;
  late Token userToken;
  group('StreamFeedClientImpl', () {
    mockUserAPI = MockUserAPI();

    data = {
      'name': 'John Doe',
      'occupation': 'Software Engineer',
      'gender': 'male',
    };
    userId = 'userId';
    user = User(id: userId, data: data);
    userToken = TokenHelper.buildFrontendToken('secret', userId);

    mockApi = MockAPI();
    when(() => mockApi.users).thenReturn(mockUserAPI);
    when(() => mockUserAPI.create(userToken, userId, data, getOrCreate: true))
        .thenAnswer((_) async => user);

    when(() => mockUserAPI.get(userToken, userId, withFollowCounts: true))
        .thenAnswer((_) async => user);

    test('setUser', () async {
      final client = StreamFeedClient('apiKey', api: mockApi);

      await client.setUser(user, userToken, extraData: data);
      verify(() =>
              mockUserAPI.create(userToken, userId, data, getOrCreate: true))
          .called(1);

      verify(() => mockUserAPI.get(userToken, userId, withFollowCounts: true))
          .called(1);
    });

    test('createUser', () async {
      final client = StreamFeedClient('apiKey', api: mockApi);
      await client.setUser(user, userToken, extraData: data);

      when(() => mockUserAPI.create(userToken, userId, data)).thenAnswer(
        (_) async => user,
      );

      final newUser = await client.createUser(userId, data);

      expect(newUser.id, userId);
      expect(newUser.data, data);

      verify(() => mockUserAPI.create(userToken, userId, data)).called(1);
    });

    test('getUser', () async {
      final client = StreamFeedClient('apiKey', api: mockApi);

      await client.setUser(user, userToken, extraData: data);
      when(() => mockUserAPI.get(userToken, userId)).thenAnswer(
        (_) async => user,
      );

      final newUser = await client.getUser(userId);

      expect(newUser.id, userId);
      expect(newUser.data, data);

      verify(() => mockUserAPI.get(userToken, userId)).called(1);
    });

    test('updateUser', () async {
      final client = StreamFeedClient('apiKey', api: mockApi);
      await client.setUser(user, userToken, extraData: data);
      when(() => mockUserAPI.update(userToken, userId, data)).thenAnswer(
        (_) async => user,
      );

      final newUser = await client.updateUser(userId, data);

      expect(newUser.id, userId);
      expect(newUser.data, data);

      verify(() => mockUserAPI.update(userToken, userId, data)).called(1);
    });

    test('delete', () async {
      final client = StreamFeedClient('apiKey', api: mockApi);
      await client.setUser(user, userToken, extraData: data);

      when(() => mockUserAPI.delete(userToken, userId)).thenAnswer(
        (_) async => Future.value(),
      );

      await client.deleteUser(userId);

      verify(() => mockUserAPI.delete(userToken, userId)).called(1);
    });

    group('throw', () {
      test('throws an AssertionError when no secret or token provided', () {
        expect(
          () => StreamFeedClient('apiKey').collections,
          throwsA(
            predicate<AssertionError>((e) =>
                e.message == 'At least a secret or userToken must be provided'),
          ),
        );
      });

      test(
        'throws an AssertionError if token is not provided '
        'while running on client-side',
        () async {
          final client = StreamFeedClient('apiKey', secret: 'secret');

          expect(
            () => client.collections,
            throwsA(
              predicate<AssertionError>(
                (e) =>
                    e.message ==
                    '''`userToken` must be provided while running on client-side please make sure to call client.setUser''',
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
              runner: Runner.server,
            ).collections,
            throwsA(
              predicate<AssertionError>(
                (e) =>
                    e.message ==
                    'At least a secret or userToken must be provided',
              ),
            ),
          );
        },
      );

      test(
        'throws an AssertionError if secret is provided '
        'while running on client-side',
        () async {
          final client =
              StreamFeedClient('apiKey', secret: 'secret', api: mockApi);
          await client.setUser(user, userToken, extraData: data);
          expect(
            () => client.collections,
            throwsA(
              predicate<AssertionError>(
                (e) =>
                    e.message ==
                    'You are publicly sharing your App Secret. '
                        'Do not expose the App Secret in `browsers`, '
                        '''`native` mobile apps, or other non-trusted environments.''',
              ),
            ),
          );
        },
      );

      test("don't throw if secret provided while running on server-side", () {
        StreamFeedClient('apiKey', secret: 'secret', runner: Runner.server);
      });

      test("don't throw if token provided while running on client-side", () {
        StreamFeedClient('apiKey');
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
      final client = StreamFeedClient('apiKey', api: mockApi);
      await client.setUser(user, userToken, extraData: data);
      const targetUrl = 'targetUrl';

      when(() => mockApi.openGraph(userToken, targetUrl)).thenAnswer(
        (_) async =>
            OpenGraphData.fromJson(jsonFixture('open_graph_data.json')),
      );
      await client.og(targetUrl);
      verify(() => mockApi.openGraph(userToken, targetUrl)).called(1);
    });
  });
}
