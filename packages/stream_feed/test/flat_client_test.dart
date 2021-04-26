import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/enrichment_flags.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/filter.dart';
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
      final activities = await client.getEnrichedActivities(
          limit: limit,
          offset: offset,
          filter: filter,
          flags: flags,
          ranking: ranking);

      expect(
          activities,
          rawActivities
              .map((e) => EnrichedActivity.fromJson(e))
              .toList(growable: false));
      verify(() => api.getEnrichedActivities(token, feedId, options)).called(1);
    });
  });
}
