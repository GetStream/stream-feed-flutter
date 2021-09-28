import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/stream_feed_client_impl.dart';
import 'package:stream_feed/src/core/api/stream_api.dart';
import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/index.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

class MockAPI extends Mock implements StreamAPI {}

class MockUsersAPI extends Mock implements UsersAPI {}

void main() {
  group('StreamFeedServer -', () {
    test('getters', () async {
      const secret = 'secret';
      const userId = 'userId';
      final server = StreamFeedServer('apiKey', secret: secret);
      expect(server.runner, Runner.server);
      expect(server.collections, isNotNull);
      expect(server.batch, isNotNull);
      expect(server.aggregatedFeed('slug', userId: 'userId'), isNotNull);
      expect(server.flatFeed('slug', userId: 'userId'), isNotNull);
      expect(server.notificationFeed('slug', userId: 'userId'), isNotNull);
      expect(server.files, isNotNull);
      expect(server.images, isNotNull);
      expect(server.reactions, isNotNull);
      expect(server.user(userId), isNotNull);
      expect(server.frontendToken(userId), isNotNull);
    });
  });

  group('StreamFeedClient -', () {
    const id = 'user-id';
    const extraData = {'name': 'User name'};
    const token = Token('token');

    late StreamAPI mockAPI;
    late UsersAPI mockUsersAPI;
    late StreamFeedClient client;
    late User user;

    setUp(() async {
      mockAPI = MockAPI();
      mockUsersAPI = MockUsersAPI();
      client = StreamFeedClient(
        'apiKey',
        api: mockAPI,
      );
      user = User(id: id, createdAt: DateTime.now());

      when(() => mockAPI.users).thenReturn(mockUsersAPI);
      when(() => mockUsersAPI.create(token, id, extraData, getOrCreate: true))
          .thenAnswer((invocation) => Future.value(user));
      when(() => mockAPI.feed).thenReturn(MockFeedAPI());
      when(() => mockAPI.collections).thenReturn(MockCollectionsAPI());
      when(() => mockAPI.files).thenReturn(MockFilesAPI());
      when(() => mockAPI.images).thenReturn(MockImagesAPI());
      when(() => mockAPI.reactions).thenReturn(MockReactionsAPI());

      await client.setCurrentUser(
        const User(id: id),
        token,
        extraData: extraData,
      );
    });

    test('getters', () async {
      expect(client.runner, Runner.client);
      expect(client.collections, isNotNull);
      expect(client.aggregatedFeed('slug'), isNotNull);
      expect(client.flatFeed('slug'), isNotNull);
      expect(client.notificationFeed('slug'), isNotNull);
      expect(client.files, isNotNull);
      expect(client.images, isNotNull);
      expect(client.reactions, isNotNull);

      expect(client.user(id), isNotNull);
    });

    test('openGraph', () async {
      const targetUrl = 'targetUrl';

      when(() => mockAPI.openGraph(token, targetUrl)).thenAnswer(
        (_) async =>
            OpenGraphData.fromJson(jsonFixture('open_graph_data.json')),
      );
      await client.og(targetUrl);
      verify(() => mockAPI.openGraph(token, targetUrl)).called(1);
    });

    test('createUser', () async {
      const userId = 'test-user';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };

      when(() => mockUsersAPI.create(token, userId, data)).thenAnswer(
        (_) async => const User(id: userId, data: data),
      );

      final user = await client.createUser(userId, data);

      verify(() => mockUsersAPI.create(token, userId, data)).called(1);
      expect(user.id, userId);
      expect(user.data, data);
    });

    test('getUser', () async {
      const userId = 'test-user';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };

      when(() => mockUsersAPI.get(token, userId)).thenAnswer(
        (_) async => const User(id: userId, data: data),
      );

      final user = await client.getUser(userId);

      verify(() => mockUsersAPI.get(token, userId)).called(1);

      expect(user.id, userId);
      expect(user.data, data);
    });

    test('updateUser', () async {
      const userId = 'test-user';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };

      when(() => mockUsersAPI.update(token, userId, data)).thenAnswer(
        (_) async => const User(id: userId, data: data),
      );

      final user = await client.updateUser(userId, data);

      verify(() => mockUsersAPI.update(token, userId, data)).called(1);
      expect(user.id, userId);
      expect(user.data, data);
    });

    test('deleteUser', () async {
      const userId = 'test-user';

      when(() => mockUsersAPI.delete(token, userId)).thenAnswer(
        (_) async => Future.value(),
      );

      await client.deleteUser(userId);

      verify(() => mockUsersAPI.delete(token, userId)).called(1);
    });
  });
}
