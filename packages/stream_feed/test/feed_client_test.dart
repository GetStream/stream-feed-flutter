import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/feed.dart';
import 'package:stream_feed_dart/src/client/flat_feed.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('Feed Client', () {
    final api = MockFeedApi();
    final feedId = FeedId('slug', 'userId');
    const token = Token('dummyToken');
    final client = Feed(feedId, api, userToken: token);
    final dummyResponse = Response(
        data: {},
        requestOptions: RequestOptions(
          path: '',
        ),
        statusCode: 200);

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

    test('unfollow', () async {
      final flatFeed = FlatFeed(feedId, api, userToken: token);
      // ignore: invalid_use_of_protected_member
      when(() => api.unfollow(token, feedId, flatFeed.feedId, true))
          .thenAnswer((_) async => dummyResponse);
      await client.unfollow(flatFeed, keepHistory: true);
      // ignore: invalid_use_of_protected_member
      verify(() => api.unfollow(token, feedId, flatFeed.feedId, true))
          .called(1);
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

    test('updateActivityToTargets', () async {
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
      // const actitivity =
      //     Activity(actor: 'actor', verb: 'verb', object: 'object');
      final add = <FeedId>[];
      final remove = <FeedId>[];
      final feed = FeedId('slug', 'userId');
      when(() => api.updateActivityToTargets(token, feed, update,
          add: add, remove: remove)).thenAnswer((_) async => dummyResponse);
      await client.updateActivityToTargets(update, add, remove);
      verify(() => api.updateActivityToTargets(token, feed, update,
          add: add, remove: remove)).called(1);
    });

    test('removeActivityByForeignId', () async {
      const foreignId = 'foreignId';
      when(() => api.removeActivityByForeignId(token, feedId, foreignId))
          .thenAnswer((_) async => dummyResponse);
      await client.removeActivityByForeignId(foreignId);
      verify(() => api.removeActivityByForeignId(token, feedId, foreignId))
          .called(1);
    });

    test('removeActivityById', () async {
      const id = 'foreignId';
      when(() => api.removeActivityById(token, feedId, id))
          .thenAnswer((_) async => dummyResponse);
      await client.removeActivityById(id);
      verify(() => api.removeActivityById(token, feedId, id)).called(1);
    });

    test('replaceActivityToTargets', () async {
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
      final newTargets = <FeedId>[];
      final feed = FeedId('slug', 'userId');
      when(() => api.updateActivityToTargets(token, feed, update,
          replace: newTargets)).thenAnswer((_) async => dummyResponse);
      await client.replaceActivityToTargets(update, newTargets);
      verify(() => api.updateActivityToTargets(token, feed, update,
          replace: newTargets)).called(1);
    });
  });
}
