import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/aggregated_feed.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_marker.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

main() {
  group('AggregatedFeed Client', () {
    final api = MockFeedApi();
    final feedId = FeedId('slug', 'userId');
    const token = Token('dummyToken');
    final client = AggregatedFeed(feedId, api, userToken: token);
    final dummyResponse = Response(
        data: {},
        requestOptions: RequestOptions(
          path: '',
        ),
        statusCode: 200);
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
              .map((e) => Group.fromJson(e!,
                  (json) => Activity.fromJson(json as Map<String, dynamic>?)))
              .toList(growable: false));
      verify(() => api.getActivities(token, feedId, options)).called(1);
    });
  });
}
