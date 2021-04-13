import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('CollectionsClient', () {
    final api = MockCollectionsApi();
    const token = Token('dummyToken');
    final client = CollectionsClient(api, userToken: token);
    test('Add', () async {
      const collection = 'users';
      const entryId = '123';
      const userId = 'userId';
      const data = {'name': 'john', 'favorite_color': 'blue'};
      const entry = CollectionEntry(
        collection: collection,
        id: entryId,
        data: data,
      );
      when(() => api.add(token, userId, entry)).thenAnswer((_) async => entry);
      final addedCollection = await client.add(
        collection,
        data,
        entryId: entryId,
        userId: userId,
      );
      expect(addedCollection, entry);
      verify(() => api.add(token, userId, entry)).called(1);
    });

    test('delete', () async {
      const collection = 'food';
      const entryId = 'cheeseburger';
      when(() => api.delete(token, collection, entryId))
          .thenAnswer((_) async => Response(
              data: {},
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      await client.delete(collection, entryId);
      verify(() => api.delete(token, collection, entryId)).called(1);
    });
  });
}
