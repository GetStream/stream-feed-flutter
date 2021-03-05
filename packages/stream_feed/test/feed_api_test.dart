import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_feed_dart/src/core/api/feed_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

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
  });
}
