import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/enrichment_flags.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/models/paginated_activities.dart';
import 'package:stream_feed/src/core/models/personalized_feed.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  group('FlatFeed Client', () {
    final api = MockFeedAPI();
    final feedId = FeedId('slug', 'userId');
    const token = Token('dummyToken');
    final client = FlatFeed(feedId, api, userToken: token);

    test('personalizedFeed', () async {
      const limit = Default.limit;
      const offset = Default.offset;
      final marker = Default.marker;
      final filter = Default.filter;
      final flags = EnrichmentFlags().withOwnReactions();
      const ranking = 'popularity';
      final options = {
        'limit': limit,
        'offset': offset, //TODO:add session everywhere
        ...filter.params,
        ...marker.params,
        'ranking': ranking,
      };

      when(() => api.personalizedFeed(token, options)).thenAnswer((_) async =>
          const PersonalizedFeed(
              limit: limit, offset: offset, version: 'whatever'));
      await client.personalizedFeed(
          limit: limit,
          offset: offset,
          marker: marker,
          filter: filter,
          ranking: ranking,
          flags: flags);

      verify(() => api.personalizedFeed(token, options)).called(1);
    });

    test('getEnrichedActivity', () async {
      const limit = 1;
      const activityId = 'e561de8f-00f1-11e4-b400-0cc47a024be0';
      final filter = Filter()
          .idLessThanOrEqual(activityId)
          .idGreaterThanOrEqual(activityId);
      final options = {
        'limit': limit,
        'offset': Default.offset, //TODO:add session everywhere
        ...filter.params,
        ...Default.marker.params,
      };

      final rawActivities = [jsonFixture('enriched_activity.json')];
      when(() => api.getEnrichedActivities(token, feedId, options))
          .thenAnswer((_) async => Response(
              data: {'results': rawActivities},
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      final activities = await client.getEnrichedActivityDetail<String, String,
          String, String>(activityId);

      expect(
          activities,
          rawActivities
              .map((e) => GenericEnrichedActivity<String, String, String,
                  String>.fromJson(e))
              .toList(growable: false)
              .first);
      verify(() => api.getEnrichedActivities(token, feedId, options)).called(1);
    });

    test('getActivityDetail', () async {
      const limit = 1;
      const activityId = 'e561de8f-00f1-11e4-b400-0cc47a024be0';
      final filter = Filter()
          .idLessThanOrEqual(activityId)
          .idGreaterThanOrEqual(activityId);
      final options = {
        'limit': limit,
        'offset': Default.offset,
        ...filter.params,
        ...Default.marker.params,
      };
      final rawActivities = [jsonFixture('group.json')];
      when(() => api.getActivities(token, feedId, options))
          .thenAnswer((_) async => Response(
              data: {'results': rawActivities},
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      final activities = await client.getActivityDetail(activityId);

      expect(
          activities,
          rawActivities
              .map((e) => Activity.fromJson(e))
              .toList(growable: false)
              .first);
      verify(() => api.getActivities(token, feedId, options)).called(1);
    });

    test('getPaginatedActivities', () async {
      const limit = 5;
      const offset = 0;
      const ranking = 'popularity';
      final filter =
          Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      final options = {
        'limit': limit,
        'offset': offset,
        ...filter.params,
        'ranking': ranking
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
      final paginatedActivities = PaginatedActivities.fromJson(json);
      when(() => api.paginatedActivities(token, feedId, options))
          .thenAnswer((_) async => paginatedActivities);
      final result = await client.getPaginatedEnrichedActivities(
          limit: limit, offset: offset, filter: filter, ranking: ranking);

      expect(result, paginatedActivities);
      verify(() => api.paginatedActivities(token, feedId, options)).called(1);
    });

    test('getActivities', () async {
      const limit = 5;
      const offset = 0;
      const ranking = 'popularity';
      final filter =
          Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      final options = {
        'limit': limit,
        'offset': offset,
        ...filter.params,
        'ranking': ranking
      };

      final rawActivities = [jsonFixture('activity.json')];
      when(() => api.getActivities(token, feedId, options))
          .thenAnswer((_) async => Response(
              data: {'results': rawActivities},
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      final activities = await client.getActivities(
          limit: limit, offset: offset, filter: filter, ranking: ranking);

      expect(
          activities,
          rawActivities
              .map((e) => Activity.fromJson(e))
              .toList(growable: false));
      verify(() => api.getActivities(token, feedId, options)).called(1);
    });

    test('getEnrichedActivities', () async {
      const limit = 5;
      const offset = 0;
      final filter =
          Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      const ranking = 'popularity';
      final flags =
          EnrichmentFlags().withRecentReactions().withReactionCounts();
      final options = {
        'limit': limit,
        'offset': offset,
        ...filter.params,
        ...Default.marker.params,
        ...flags.params,
        'ranking': ranking,
      };

      final rawActivities = [jsonFixture('enriched_activity.json')];
      when(() => api.getEnrichedActivities(token, feedId, options))
          .thenAnswer((_) async => Response(
              data: {'results': rawActivities},
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      final activities =
          await client.getEnrichedActivities<String, String, String, String>(
        limit: limit,
        offset: offset,
        filter: filter,
        flags: flags,
        ranking: ranking,
      );

      expect(
          activities,
          rawActivities
              .map((e) => GenericEnrichedActivity<String, String, String,
                  String>.fromJson(e))
              .toList(growable: false));
      verify(() => api.getEnrichedActivities(token, feedId, options)).called(1);
    });
  });
}
