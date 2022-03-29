import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/feed.dart';
import 'package:stream_feed/src/core/models/follow_relation.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  group('Feed Client', () {
    final api = MockFeedAPI();
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
      when(() => api.unfollow(token, feedId, feedId, keepHistory: true))
          .thenAnswer((_) async => dummyResponse);
      await client.unfollow(flatFeed, keepHistory: true);
      // ignore: invalid_use_of_protected_member
      verify(() => api.unfollow(token, feedId, feedId, keepHistory: true))
          .called(1);
    });

    test('follows', () {
      final follows = <FollowRelation>[
        const FollowRelation(source: 'timeline:1', target: 'user:1'),
        const FollowRelation(source: 'timeline:1', target: 'user:2'),
        const FollowRelation(source: 'timeline:1', target: 'user:3'),
      ];
      expect(follows.map((e) => e.toJson()), [
        {'source': 'timeline:1', 'target': 'user:1'},
        {'source': 'timeline:1', 'target': 'user:2'},
        {'source': 'timeline:1', 'target': 'user:3'}
      ]);
    });

    test('followStats', () async {
      const followingSlugs = ['timeline'];
      const followerSlugs = ['user', 'news'];
      final options = FollowStats(
          following: Following(
            feed: feedId,
            slugs: followingSlugs,
          ),
          followers: Followers(
            feed: feedId,
            slugs: followerSlugs,
          ));
      when(() => api.followStats(token, options.toJson())).thenAnswer(
          (_) async => FollowStats.fromJson(jsonFixture('follow_stats.json')));
      await client.followStats(
          followerSlugs: ['user', 'news'], followingSlugs: ['timeline']);
      verify(() => api.followStats(token, options.toJson())).called(1);
    });

    test('getFollowed', () async {
      const limit = 5;
      const offset = 0;
      final feed = FeedId('slug', 'userId');
      final feedIds = [FeedId('slug', 'userId')];
      final date = DateTime.parse('2021-05-14T19:58:27.274792063Z');
      final follows = <Follow>[
        Follow(
            feedId: 'timeline:1',
            targetId: 'user:1',
            createdAt: date,
            updatedAt: date),
        Follow(
            feedId: 'timeline:1',
            targetId: 'user:2',
            createdAt: date,
            updatedAt: date),
      ];
      when(() => api.following(token, feed, limit, offset, feedIds))
          .thenAnswer((_) async => follows);
      await client.following(limit: limit, offset: offset, filter: feedIds);
      verify(() => api.following(token, feed, limit, offset, feedIds))
          .called(1);
    });

    test('getFollowers', () async {
      const limit = 5;
      const offset = 0;
      final feed = FeedId('slug', 'userId');
      final feedIds = [FeedId('slug', 'userId')];
      final date = DateTime.parse('2021-05-14T19:58:27.274792063Z');
      final follows = <Follow>[
        Follow(
            feedId: 'timeline:1',
            targetId: 'user:1',
            createdAt: date,
            updatedAt: date),
        Follow(
            feedId: 'timeline:1',
            targetId: 'user:2',
            createdAt: date,
            updatedAt: date),
      ];
      when(() => api.followers(token, feed, limit, offset, feedIds))
          .thenAnswer((_) async => follows);
      await client.followers(limit: limit, offset: offset, feedIds: feedIds);
      verify(() => api.followers(token, feed, limit, offset, feedIds))
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

      final update = ActivityUpdate.withId(id: id, set: set, unset: unset);
      const actitivity =
          Activity(actor: 'actor', verb: 'verb', object: 'object');
      when(() => api.updateActivityById(token, update))
          .thenAnswer((_) async => actitivity);
      await client.updateActivityById(
          id: update.id!, set: update.set, unset: update.unset);
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

      final updates = [ActivityUpdate.withId(id: id, set: set, unset: unset)];
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

      final updates = [ActivityUpdate.withId(id: id, set: set, unset: unset)];
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

      final update = ActivityUpdate.withForeignId(
          foreignId: id,
          set: set,
          unset: unset,
          time: DateTime.parse('2001-09-11T00:01:02.000'));
      const actitivity =
          Activity(actor: 'actor', verb: 'verb', object: 'object');
      when(() => api.updateActivityByForeignId(token, update))
          .thenAnswer((_) async => actitivity);
      await client.updateActivityByForeignId(
          time: DateTime.parse('2001-09-11T00:01:02.000'),
          foreignId: update.foreignId!,
          set: update.set,
          unset: update.unset);
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

      final update = ActivityUpdate.withId(id: id, set: set, unset: unset);
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

      final update = ActivityUpdate.withId(id: id, set: set, unset: unset);
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
