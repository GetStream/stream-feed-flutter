import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_feed_dart/src/core/api/batch_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements HttpClient {}

Future<void> main() async {
  group('Batch API', () {
    final mockClient = MockHttpClient();

    test('AddToMany', () async {
      const token = Token('dummyToken');
      const activity = Activity(
        actor: 'testActor',
        object: 'testObject',
        verb: 'testVerb',
      );

      final feedIds = <FeedId>[
        FeedId('global', 'feed1'),
        FeedId('global', 'feed2'),
      ];

      final batchApi = BatchApiImpl(mockClient);

      when(mockClient.post(Routes.addToManyUrl,
          headers: {'Authorization': '$token'},
          queryParameters: {
            'api_key': 'apiKey',
          },
          data: json.encode({
            'feeds': feedIds.map((e) => e.toString()).toList(),
            'activity': activity,
          }))).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await batchApi.addToMany(token, activity, feedIds);

      verify(mockClient.post(Routes.addToManyUrl,
          headers: {'Authorization': '$token'},
          queryParameters: {
            'api_key': 'apiKey',
          },
          data: json.encode({
            'feeds': feedIds.map((e) => e.toString()).toList(),
            'activity': activity,
          }))).called(1);
    });
  });
}
