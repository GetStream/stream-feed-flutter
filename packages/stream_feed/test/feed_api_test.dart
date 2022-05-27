import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/activity_update.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

Future<void> main() async {
  group('Feed API', () {
    final mockClient = MockHttpClient();
    final feedApi = FeedAPI(mockClient);
    test('Follow', () async {
      const token = Token('dummyToken');
      const targetToken = Token('dummyToken2');

      final sourceFeed = FeedId('global', 'feed1');
      final targetFeed = FeedId('global', 'feed2');
      const activityCopyLimit = 10;
      when(() => mockClient.post(
            Routes.buildFeedUrl(sourceFeed, 'following'),
            headers: {'Authorization': '$token'},
            data: {
              'target': '$targetFeed',
              'activity_copy_limit': activityCopyLimit,
              'target_token': '$targetToken',
            },
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildFeedUrl(sourceFeed, 'following'),
          ),
          statusCode: 200));

      await feedApi.follow(
          token, targetToken, sourceFeed, targetFeed, activityCopyLimit);

      verify(() => mockClient.post(
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

      final feed = FeedId('global', 'feed1');

      final options = {
        'limit': limit,
        'offset': Default.offset,
        ...filter.params,
        ...Default.marker.params,
        'ranking': ranking,
      };

      when(() => mockClient.get<Map>(
            Routes.buildFeedUrl(feed),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildFeedUrl(feed),
          ),
          statusCode: 200));

      await feedApi.getActivities(token, feed, options);

      verify(() => mockClient.get<Map>(
            Routes.buildFeedUrl(feed),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).called(1);
    });

    test('GetPaginatedActivities', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      final options = {
        'limit': Default.limit,
        'offset': Default.offset,
        ...Default.filter.params,
        ...Default.enrichmentFlags.params,
        ...Default.marker.params
      };
      final json = {
        'next':
            '/api/v1.0/feed/user/1/?api_key=8rxdnw8pjmvb&id_lt=b253bfa1-83b3-11ec-8dc7-0a5c4613b2ff&limit=25',
        'results': [
          {
            'actor': '1',
            'verb': 'tweet',
            'target': 'test',
            'object': 'test',
            'origin': 'test',
          }
        ],
        'duration': '419.81ms'
      };
      // final paginatedActivities = PaginatedActivities.fromJson(json);

      when(() => mockClient.get<Map>(
            Routes.buildEnrichedFeedUrl(feed),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).thenAnswer((_) async => Response(
          data: json,
          requestOptions: RequestOptions(
            path: Routes.buildEnrichedFeedUrl(feed),
          ),
          statusCode: 200));

      await feedApi.paginatedActivities(token, feed, options);

      verify(() => mockClient.get<Map>(
            Routes.buildEnrichedFeedUrl(feed),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).called(1);
    });

    test('GetEnrichedActivities', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      final options = {
        'limit': Default.limit,
        'offset': Default.offset,
        ...Default.filter.params,
        ...Default.enrichmentFlags.params,
        ...Default.marker.params
      };

      when(() => mockClient.get(
            Routes.buildEnrichedFeedUrl(feed),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildEnrichedFeedUrl(feed),
          ),
          statusCode: 200));

      await feedApi.getEnrichedActivities(token, feed, options);

      verify(() => mockClient.get(
            Routes.buildEnrichedFeedUrl(feed),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).called(1);
    });

    test('GetFollowed', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      final feedIds = [FeedId('global', 'feed1')];
      const offset = 5;
      const limit = 10;

      when(() => mockClient.get<Map>(
            Routes.buildFeedUrl(feed, 'following'),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'limit': limit,
              'offset': offset,
              if (feedIds.isNotEmpty)
                'filter': feedIds.map((it) => it.toString()).join(',')
            },
          )).thenAnswer((_) async => Response(
              data: {
                'results': [
                  {
                    'feed_id': 'feedId',
                    'target_id': 'targetId',
                    'created_at': '2021-05-14T19:58:27.274792063Z',
                    'updated_at': '2021-05-14T19:58:27.274792063Z'
                  }
                ]
              },
              requestOptions: RequestOptions(
                path: Routes.buildFeedUrl(feed, 'following'),
              ),
              statusCode: 200));

      await feedApi.following(token, feed, limit, offset, feedIds);

      verify(() => mockClient.get<Map>(
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

    test('AddActivity', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      const activity = Activity(
        actor: 'user:1',
        verb: 'tweet',
        object: 'tweet:1',
      );

      when(() => mockClient.post<Map>(
            Routes.buildFeedUrl(feed),
            headers: {'Authorization': '$token'},
            data: activity,
          )).thenAnswer((_) async => Response(
          data: activity.toJson(),
          requestOptions: RequestOptions(
            path: Routes.buildFeedUrl(feed),
          ),
          statusCode: 200));

      await feedApi.addActivity(token, feed, activity);

      verify(() => mockClient.post<Map>(
            Routes.buildFeedUrl(feed),
            headers: {'Authorization': '$token'},
            data: activity,
          )).called(1);
    });

    test('AddActivities', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      final activities = <Activity>[
        const Activity(
          actor: 'user:1',
          verb: 'tweet',
          object: 'tweet:1',
        ),
        const Activity(
          actor: 'user:2',
          verb: 'watch',
          object: 'movie:1',
        ),
      ];
      final activityList =
          activities.map((activity) => activity.toJson()).toList();
      when(() => mockClient.post<Map>(
            Routes.buildFeedUrl(feed),
            headers: {'Authorization': '$token'},
            data: {'activities': activities},
          )).thenAnswer((_) async => Response(
          data: {'activities': activityList},
          requestOptions: RequestOptions(
            path: Routes.buildFeedUrl(feed),
          ),
          statusCode: 200));

      await feedApi.addActivities(token, feed, activities);

      verify(() => mockClient.post<Map>(
            Routes.buildFeedUrl(feed),
            headers: {'Authorization': '$token'},
            data: {'activities': activities},
          )).called(1);
    });

    test('GetFollowers', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      final feedIds = [FeedId('global', 'feed1')];
      const offset = 5;
      const limit = 10;

      when(() => mockClient.get(
            Routes.buildFeedUrl(feed, 'followers'),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'limit': limit,
              'offset': offset,
              if (feedIds.isNotEmpty)
                'filter': feedIds.map((it) => it.toString()).join(',')
            },
          )).thenAnswer((_) async => Response(
              data: {
                'results': [jsonFixture('follow.json')]
              },
              requestOptions: RequestOptions(
                path: Routes.buildFeedUrl(feed, 'followers'),
              ),
              statusCode: 200));

      await feedApi.followers(token, feed, limit, offset, feedIds);

      verify(() => mockClient.get(
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

      final feed = FeedId('global', 'feed1');

      const foreignId = 'foreignId';
      when(() => mockClient.delete(
            Routes.buildFeedUrl(feed, foreignId),
            headers: {'Authorization': '$token'},
            queryParameters: {'foreign_id': '1'},
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildFeedUrl(feed, foreignId),
          ),
          statusCode: 200));

      await feedApi.removeActivityByForeignId(token, feed, foreignId);

      verify(() => mockClient.delete(
            Routes.buildFeedUrl(feed, foreignId),
            headers: {'Authorization': '$token'},
            queryParameters: {'foreign_id': '1'},
          )).called(1);
    });

    test('RemoveActivityById', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      const id = 'id';
      when(() => mockClient.delete(
            Routes.buildFeedUrl(feed, id),
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildFeedUrl(feed, id),
          ),
          statusCode: 200));

      await feedApi.removeActivityById(token, feed, id);

      verify(() => mockClient.delete(
            Routes.buildFeedUrl(feed, id),
            headers: {'Authorization': '$token'},
          )).called(1);
    });

    test('UnFollow', () async {
      const token = Token('dummyToken');

      final source = FeedId('global', 'feed1');
      final target = FeedId('global', 'feed2');
      const keepHistory = true;

      when(() => mockClient.delete(
            Routes.buildFeedUrl(source, 'following/$target'),
            headers: {'Authorization': '$token'},
            queryParameters: {'keep_history': keepHistory},
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildFeedUrl(source, 'following/$target'),
          ),
          statusCode: 200));

      await feedApi.unfollow(token, source, target, keepHistory: keepHistory);

      verify(() => mockClient.delete(
            Routes.buildFeedUrl(source, 'following/$target'),
            headers: {'Authorization': '$token'},
            queryParameters: {'keep_history': keepHistory},
          )).called(1);
    });

    test('UpdateActivitiesByForeignId', () async {
      const token = Token('dummyToken');

      final unset = ['daily_likes', 'popularity'];

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final updates = [
        ActivityUpdate.withForeignId(
          foreignId: 'foreignId',
          set: set,
          unset: unset,
          time: DateTime.now(),
        )
      ];

      when(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: {'changes': updates},
          )).thenAnswer((_) async => Response(
              data: {
                'activities': [jsonFixture('activity.json')]
              },
              requestOptions: RequestOptions(
                path: Routes.activityUpdateUrl,
              ),
              statusCode: 200));

      await feedApi.updateActivitiesByForeignId(token, updates);

      verify(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: {'changes': updates},
          )).called(1);
    });

    test('UpdateActivitiesById', () async {
      const token = Token('dummyToken');

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
        ActivityUpdate.withId(
          id: id,
          set: set,
          unset: unset,
        )
      ];

      when(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: {'changes': updates},
          )).thenAnswer((_) async => Response(
              data: {
                'activities': [jsonFixture('activity.json')],
              },
              requestOptions: RequestOptions(
                path: Routes.activityUpdateUrl,
              ),
              statusCode: 200));

      await feedApi.updateActivitiesById(token, updates);

      verify(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: {'changes': updates},
          )).called(1);
    });

    test('UpdateActivityByForeignId', () async {
      const token = Token('dummyToken');

      final unset = ['daily_likes', 'popularity'];

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final update = ActivityUpdate.withForeignId(
        foreignId: 'foreignId',
        set: set,
        unset: unset,
        time: DateTime.now(),
      );

      when(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: update,
          )).thenAnswer((_) async => Response(
          data: jsonFixture('activity.json'),
          requestOptions: RequestOptions(
            path: Routes.activityUpdateUrl,
          ),
          statusCode: 200));

      await feedApi.updateActivityByForeignId(token, update);

      verify(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: update,
          )).called(1);
    });

    test('UpdateActivityById', () async {
      const token = Token('dummyToken');

      final unset = ['daily_likes', 'popularity'];

      const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final update = ActivityUpdate.withId(
        id: id,
        set: set,
        unset: unset,
      );

      when(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: update,
          )).thenAnswer((_) async => Response(
          data: jsonFixture('activity.json'),
          requestOptions: RequestOptions(
            path: Routes.activityUpdateUrl,
          ),
          statusCode: 200));

      await feedApi.updateActivityById(token, update);

      verify(() => mockClient.post<Map>(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: update,
          )).called(1);
    });

    test('UpdateActivityToTargets', () async {
      const token = Token('dummyToken');

      final feed = FeedId('global', 'feed1');

      final add = [FeedId('global', 'feed1')];
      final remove = [FeedId('global', 'feed1')];

      final unset = ['daily_likes', 'popularity'];

      final set = {
        'product.price': 19.99,
        'shares': {
          'facebook': '...',
          'twitter': '...',
        }
      };
      final update = ActivityUpdate.withForeignId(
        foreignId: 'foreignId',
        set: set,
        unset: unset,
        time: DateTime.now(),
      );

      when(() => mockClient.post(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: {
              'foreign_id': update.foreignId,
              'time': update.time!.toIso8601String(),
              'added_targets': add.map((it) => it.toString()).toList(),
              'removed_targets': remove.map((it) => it.toString()).toList(),
              'new_targets': []
            },
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.activityUpdateUrl,
          ),
          statusCode: 200));

      await feedApi.updateActivityToTargets(token, feed, update,
          add: add, remove: remove, replace: []);

      verify(() => mockClient.post(
            Routes.activityUpdateUrl,
            headers: {'Authorization': '$token'},
            data: {
              'foreign_id': update.foreignId,
              'time': update.time!.toIso8601String(),
              'added_targets': add.map((it) => it.toString()).toList(),
              'removed_targets': remove.map((it) => it.toString()).toList(),
              'new_targets': [] //empty because you can't update
              // and remove at the same time
            },
          )).called(1);
    });
  });
}
