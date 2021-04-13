import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/feed.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('Feed Client', () {
    final api = MockFeedApi();
    final feedId = FeedId('slug', 'userId');
    const secret = 'secret';
    const token = Token('dummyToken');
    const targetToken = Token('dummyToken2');
    final client = Feed(feedId, api, userToken: token);

    test('addActivity', () async {
      const activity = Activity(
        actor: 'user:1',
        verb: 'tweet',
        object: 'tweet:1',
      );
      when(() => api.addActivity(token, feedId, activity))
          .thenAnswer((_) async => activity);
      await client.addActivity(activity);
      verify(() => api.addActivity(token, feedId, activity)).called(1);
    });

    test('addActivities', () async {
      const activities = [
        Activity(
          actor: 'user:1',
          verb: 'tweet',
          object: 'tweet:1',
        )
      ];
      when(() => api.addActivities(token, feedId, activities))
          .thenAnswer((_) async => activities);
      await client.addActivities(activities);
      verify(() => api.addActivities(token, feedId, activities)).called(1);
    });

    test('getFollowed', () async {
      const limit = 5;
      const offset = 0;
      final feed = FeedId('slug', 'userId');
      final feedIds = [FeedId('slug', 'userId')];
      final follows = <Follow>[
        const Follow('timeline:1', 'user:1'),
        const Follow('timeline:1', 'user:2'),
        const Follow('timeline:1', 'user:3'),
      ];
      when(() => api.getFollowed(token, feed, limit, offset, feedIds))
          .thenAnswer((_) async => follows);
      await client.getFollowed(limit: limit, offset: offset, feedIds: feedIds);
      verify(() => api.getFollowed(token, feed, limit, offset, feedIds))
          .called(1);
    });

    test('getFollowers', () async {
      const limit = 5;
      const offset = 0;
      final feed = FeedId('slug', 'userId');
      final feedIds = [FeedId('slug', 'userId')];
      final follows = <Follow>[
        const Follow('timeline:1', 'user:1'),
        const Follow('timeline:1', 'user:2'),
        const Follow('timeline:1', 'user:3'),
      ];
      when(() => api.getFollowers(token, feed, limit, offset, feedIds))
          .thenAnswer((_) async => follows);
      await client.getFollowers(limit: limit, offset: offset, feedIds: feedIds);
      verify(() => api.getFollowers(token, feed, limit, offset, feedIds))
          .called(1);
    });

    test('updateActivityById', () async {
      final unset = ['daily_likes', 'popularity'];
      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';
      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };

      final update = ActivityUpdate.withId(id, set, unset);
      const actitivity =
          Activity(actor: 'actor', verb: 'verb', object: 'object');
      when(() => api.updateActivityById(token, update))
          .thenAnswer((_) async => actitivity);
      await client.updateActivityById(update);
      verify(() => api.updateActivityById(token, update)).called(1);
    });

    test('updateActivitiesById', () async {
      final unset = ['daily_likes', 'popularity'];
      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';
      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };

      final updates = [ActivityUpdate.withId(id, set, unset)];
      const actitivities = [
        Activity(actor: 'actor', verb: 'verb', object: 'object')
      ];
      when(() => api.updateActivitiesById(token, updates))
          .thenAnswer((_) async => actitivities);
      await client.updateActivitiesById(updates);
      verify(() => api.updateActivitiesById(token, updates)).called(1);
    });

    test('updateActivitiesByForeignId', () async {
      final unset = ['daily_likes', 'popularity'];
      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';
      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };

      final updates = [ActivityUpdate.withId(id, set, unset)];
      const actitivities = [
        Activity(actor: 'actor', verb: 'verb', object: 'object')
      ];
      when(() => api.updateActivitiesByForeignId(token, updates))
          .thenAnswer((_) async => actitivities);
      await client.updateActivitiesByForeignId(updates);
      verify(() => api.updateActivitiesByForeignId(token, updates)).called(1);
    });

    test('updateActivityByForeignId', () async {
      final unset = ['daily_likes', 'popularity'];
      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';
      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };

      final update = ActivityUpdate.withId(id, set, unset);
      const actitivity =
          Activity(actor: 'actor', verb: 'verb', object: 'object');
      when(() => api.updateActivityByForeignId(token, update))
          .thenAnswer((_) async => actitivity);
      await client.updateActivityByForeignId(update);
      verify(() => api.updateActivityByForeignId(token, update)).called(1);
    });
  });
}
