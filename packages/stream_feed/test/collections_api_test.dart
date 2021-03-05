import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_feed_dart/src/core/api/collections_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'utils.dart';

class MockHttpClient extends Mock implements HttpClient {}

Future<void> main() async {
  group('Collections API', () {
    final mockClient = MockHttpClient();
    final collectionsApi = CollectionsApiImpl(mockClient);
    test('Add', () async {
      const token = Token('dummyToken');
      const userId = 'userId';
      final entry = CollectionEntry(collection: "users", id: '123', data: {
        'name': 'john',
        'favorite_color': 'blue',
      });

      when(mockClient.post<Map>(
        Routes.buildCollectionsUrl(entry.collection),
        headers: {'Authorization': '$token'},
        data: {
          'data': entry.data,
          if (userId != null) 'user_id': userId,
          if (entry.id != null) 'id': entry.id,
        },
      )).thenAnswer((_) async => Response(
          data: jsonFixture('collection_entry.json'), statusCode: 200));

      await collectionsApi.add(token, userId, entry);

      verify(mockClient.post<Map>(
        Routes.buildCollectionsUrl(entry.collection),
        headers: {'Authorization': '$token'},
        data: {
          'data': entry.data,
          if (userId != null) 'user_id': userId,
          if (entry.id != null) 'id': entry.id,
        },
      )).called(1);
    });
  });
}
