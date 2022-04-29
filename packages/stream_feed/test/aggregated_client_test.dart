import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/aggregated_feed.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/activity_marker.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/enrichment_flags.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/models/group.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  group('AggregatedFeed Client', () {
    final api = MockFeedAPI();
    final feedId = FeedId('slug', 'userId');
    const token = Token('dummyToken');
    final client = AggregatedFeed(feedId, api, userToken: token);

    test('getEnrichedActivityDetail', () async {
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

      final rawActivities = [jsonFixture('group.json')];
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
              .map((e) => Group<
                      GenericEnrichedActivity<String, String, String,
                          String>>.fromJson(
                  e,
                  (o) => GenericEnrichedActivity<String, String, String,
                      String>.fromJson(o as Map<String, dynamic>)))
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
              .map((e) => Group.fromJson(e,
                  (json) => Activity.fromJson(json as Map<String, dynamic>?)))
              .toList(growable: false)
              .first);
      verify(() => api.getActivities(token, feedId, options)).called(1);
    });

    test('getActivities', () async {
      const limit = 5;
      const offset = 0;
      final marker = ActivityMarker().allSeen();
      final filter =
          Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      final options = {
        'limit': limit,
        'offset': offset,
        ...filter.params,
        ...marker.params,
      };
      final rawActivities = [jsonFixture('group.json')];
      when(() => api.getActivities(token, feedId, options))
          .thenAnswer((_) async => Response(
              data: {'results': rawActivities},
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      final activities = await client.getActivities(
          limit: limit, offset: offset, filter: filter, marker: marker);

      expect(
          activities,
          rawActivities
              .map((e) => Group.fromJson(e,
                  (json) => Activity.fromJson(json as Map<String, dynamic>?)))
              .toList(growable: false));
      verify(() => api.getActivities(token, feedId, options)).called(1);
    });

    test('getEnrichedActivities', () async {
      const limit = 5;
      const offset = 0;
      final marker = ActivityMarker().allSeen();
      final filter =
          Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      final flags =
          EnrichmentFlags().withRecentReactions().withReactionCounts();
      final options = {
        'limit': limit,
        'offset': offset,
        ...filter.params,
        ...marker.params,
        ...flags.params
      };

      final rawActivities = [jsonFixture('group_enriched_activity.json')];
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
              marker: marker,
              flags: flags);

      expect(
          activities,
          rawActivities
              .map((e) => Group.fromJson(
                    e,
                    (json) => GenericEnrichedActivity<String, String, String,
                        String>.fromJson(json as Map<String, dynamic>?),
                  ))
              .toList(growable: false));
      verify(() => api.getEnrichedActivities(token, feedId, options)).called(1);
    });
  });
}
