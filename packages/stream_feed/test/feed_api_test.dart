import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_feed_dart/src/core/api/feed_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity_update.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'utils.dart';

class MockHttpClient extends Mock implements HttpClient {}

Future<void> main() async {
  group('Feed API', () {
    final mockClient = MockHttpClient();
    test('Follow', () async {
      const token = Token('dummyToken');
      const targetToken = Token('dummyToken2');

      final feedApi = FeedApiImpl(mockClient);
      final sourceFeed = FeedId('global', 'feed1');
      final targetFeed = FeedId('global', 'feed2');
      const activityCopyLimit = 10;
      when(mockClient.post(
        Routes.buildFeedUrl(sourceFeed, 'following'),
        headers: {'Authorization': '$token'},
        data: {
          'target': '$targetFeed',
          'activity_copy_limit': activityCopyLimit,
          'target_token': '$targetToken',
        },
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await feedApi.follow(
          token, targetToken, sourceFeed, targetFeed, activityCopyLimit);

      verify(mockClient.post(
        Routes.buildFeedUrl(sourceFeed, 'following'),
        headers: {'Authorization': '$token'},
        data: {
          'target': '$targetFeed',
          'activity_copy_limit': activityCopyLimit,
          'target_token': '$targetToken',
        },
      )).called(1);
    });

    test('GetActivities', () async {
      const token = Token('dummyToken');
      const limit = 5;
      const ranking = 'activity_popularity';
      final filter =
          Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0');

      final feedApi = FeedApiImpl(mockClient);
      final feed = FeedId('global', 'feed1');

      final options = {
        'limit': limit,
        'offset': Default.offset,
        ...filter.params,
        ...Default.marker.params,
        'ranking': ranking,
      };

      when(mockClient.get<Map>(
        Routes.buildFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await feedApi.getActivities(token, feed, options);

      verify(mockClient.get<Map>(
        Routes.buildFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      )).called(1);
    });

    test('GetEnrichedActivities', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final feed = FeedId('global', 'feed1');

      final options = {
        'limit': Default.limit,
        'offset': Default.offset,
        ...Default.filter.params,
        ...Default.enrichmentFlags.params,
        ...Default.marker.params
      };

      when(mockClient.get(
        Routes.buildEnrichedFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await feedApi.getEnrichedActivities(token, feed, options);

      verify(mockClient.get(
        Routes.buildEnrichedFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      )).called(1);
    });

    test('GetFollowed', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final feed = FeedId('global', 'feed1');

      final feedIds = [FeedId('global', 'feed1')];
      const offset = 5;
      const limit = 10;

      when(mockClient.get<Map>(
        Routes.buildFeedUrl(feed, 'following'),
        headers: {'Authorization': '$token'},
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (feedIds.isNotEmpty)
            'filter': feedIds.map((it) => it.toString()).join(',')
        },
      )).thenAnswer((_) async => Response(data: {
            'results': [
              {'feed_id': 'feedId', 'target_id': 'targetId'}
            ]
          }, statusCode: 200));

      await feedApi.getFollowed(token, feed, limit, offset, feedIds);

      verify(mockClient.get<Map>(
        Routes.buildFeedUrl(feed, 'following'),
        headers: {'Authorization': '$token'},
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (feedIds.isNotEmpty)
            'filter': feedIds.map((it) => it.toString()).join(',')
        },
      )).called(1);
    });

    test('GetFollowers', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final feed = FeedId('global', 'feed1');

      final feedIds = [FeedId('global', 'feed1')];
      const offset = 5;
      const limit = 10;

      when(mockClient.get<Map>(
        Routes.buildFeedUrl(feed, 'followers'),
        headers: {'Authorization': '$token'},
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (feedIds.isNotEmpty)
            'filter': feedIds.map((it) => it.toString()).join(',')
        },
      )).thenAnswer((_) async => Response(data: {
            'results': [jsonFixture('follow.json')]
          }, statusCode: 200));

      await feedApi.getFollowers(token, feed, limit, offset, feedIds);

      verify(mockClient.get<Map>(
        Routes.buildFeedUrl(feed, 'followers'),
        headers: {'Authorization': '$token'},
        queryParameters: {
          'limit': limit,
          'offset': offset,
          if (feedIds.isNotEmpty)
            'filter': feedIds.map((it) => it.toString()).join(',')
        },
      )).called(1);
    });

    test('RemoveActivityByForeignId', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final feed = FeedId('global', 'feed1');

      const foreignId = 'foreignId';
      when(mockClient.delete(
        Routes.buildFeedUrl(feed, foreignId),
        headers: {'Authorization': '$token'},
        queryParameters: {'foreign_id': '1'},
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await feedApi.removeActivityByForeignId(token, feed, foreignId);

      verify(mockClient.delete(
        Routes.buildFeedUrl(feed, foreignId),
        headers: {'Authorization': '$token'},
        queryParameters: {'foreign_id': '1'},
      )).called(1);
    });

    test('RemoveActivityById', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final feed = FeedId('global', 'feed1');

      const id = 'id';
      when(mockClient.delete(
        Routes.buildFeedUrl(feed, id),
        headers: {'Authorization': '$token'},
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await feedApi.removeActivityById(token, feed, id);

      verify(mockClient.delete(
        Routes.buildFeedUrl(feed, id),
        headers: {'Authorization': '$token'},
      )).called(1);
    });

    test('UnFollow', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final source = FeedId('global', 'feed1');
      final target = FeedId('global', 'feed2');
      const keepHistory = true;

      when(mockClient.delete(
        Routes.buildFeedUrl(source, 'following/$target'),
        headers: {'Authorization': '$token'},
        queryParameters: {'keep_history': keepHistory},
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await feedApi.unfollow(token, source, target, keepHistory);

      verify(mockClient.delete(
        Routes.buildFeedUrl(source, 'following/$target'),
        headers: {'Authorization': '$token'},
        queryParameters: {'keep_history': keepHistory},
      )).called(1);
    });

    test('UpdateActivitiesByForeignId', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final unset = ['daily_likes', 'popularity'];

      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final updates = [
        ActivityUpdate(
            id: id,
            foreignId: 'foreignId',
            set: set,
            unset: unset,
            time: DateTime.now())
      ];

      when(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: {'changes': updates},
      )).thenAnswer((_) async => Response(data: {
            'activities': [jsonFixture('activity.json')]
          }, statusCode: 200));

      await feedApi.updateActivitiesByForeignId(token, updates);

      verify(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: {'changes': updates},
      )).called(1);
    });

    test('UpdateActivitiesById', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final unset = ['daily_likes', 'popularity'];

      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final updates = [
        ActivityUpdate(
            id: id,
            foreignId: 'foreignId',
            set: set,
            unset: unset,
            time: DateTime.now())
      ];

      when(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: {'changes': updates},
      )).thenAnswer((_) async => Response(data: {
            'activities': [jsonFixture('activity.json')]
          }, statusCode: 200));

      await feedApi.updateActivitiesById(token, updates);

      verify(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: {'changes': updates},
      )).called(1);
    });

    test('UpdateActivityByForeignId', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final unset = ['daily_likes', 'popularity'];

      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final update = ActivityUpdate(
          id: id,
          foreignId: 'foreignId',
          set: set,
          unset: unset,
          time: DateTime.now());

      when(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: update,
      )).thenAnswer((_) async =>
          Response(data: jsonFixture('activity.json'), statusCode: 200));

      await feedApi.updateActivityByForeignId(token, update);

      verify(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: update,
      )).called(1);
    });

    test('UpdateActivityById', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final unset = ['daily_likes', 'popularity'];

      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final update = ActivityUpdate(
          id: id,
          foreignId: 'foreignId',
          set: set,
          unset: unset,
          time: DateTime.now());

      when(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: update,
      )).thenAnswer((_) async =>
          Response(data: jsonFixture('activity.json'), statusCode: 200));

      await feedApi.updateActivityById(token, update);

      verify(mockClient.post<Map>(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: update,
      )).called(1);
    });

    test('UpdateActivityToTargets', () async {
      const token = Token('dummyToken');

      final feedApi = FeedApiImpl(mockClient);
      final feed = FeedId('global', 'feed1');

      final add = [FeedId('global', 'feed1')];
      final remove = [FeedId('global', 'feed1')];

      final unset = ['daily_likes', 'popularity'];

      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final update = ActivityUpdate(
          id: id,
          foreignId: 'foreignId',
          set: set,
          unset: unset,
          time: DateTime.now());

      when(mockClient.post(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: {
          'foreign_id': update.foreignId,
          'time': update.time.toIso8601String(),
          'added_targets': add.map((it) => it.toString()).toList(),
          'removed_targets': remove.map((it) => it.toString()).toList(),
          'new_targets': []
        },
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await feedApi.updateActivityToTargets(token, feed, update,
          add: add, remove: remove, replace: []);

      verify(mockClient.post(
        Routes.activityUpdateUrl,
        headers: {'Authorization': '$token'},
        data: {
          'foreign_id': update.foreignId,
          'time': update.time.toIso8601String(),
          'added_targets': add.map((it) => it.toString()).toList(),
          'removed_targets': remove.map((it) => it.toString()).toList(),
          'new_targets': [] //empty because you can't update
          // and remove at the same time
        },
      )).called(1);
    });
  });
}
