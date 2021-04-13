import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('CollectionsClient', () {
    final api = MockCollectionsApi();

    final mockTokenHelper = MockTokenHelper();
    const secret = 'secret';
    final clientWithSecret =
        CollectionsClient(api, secret: secret, tokenHelper: mockTokenHelper);
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

    test('get', () async {
      const collection = 'food';
      const entryId = 'cheeseburger';
      const entry = CollectionEntry(
        collection: collection,
        id: entryId,
      );
      when(() => api.get(token, collection, entryId))
          .thenAnswer((_) async => entry);
      await client.get(collection, entryId);
      verify(() => api.get(token, collection, entryId)).called(1);
    });

    test('update', () async {
      const collection = 'users';
      const entryId = '123';
      const userId = 'userId';
      const data = {'name': 'john', 'favorite_color': 'blue'};
      const entry = CollectionEntry(
        collection: collection,
        id: entryId,
        data: data,
      );
      when(() => api.update(token, userId, entry))
          .thenAnswer((_) async => entry);
      final updatedCollection = await client.update(
        collection,
        entryId,
        data,
        userId: userId,
      );
      expect(updatedCollection, entry);
      verify(() => api.update(token, userId, entry)).called(1);
    });

    test('select', () async {
      const collection = 'food';
      const entryId = 'cheeseburger';
      const entryIds = [entryId];
      const entries = [CollectionEntry(id: entryId, collection: collection)];
      when(() =>
              mockTokenHelper.buildCollectionsToken('secret', TokenAction.read))
          .thenReturn(token);
      when(() => api.select(token, collection, entryIds))
          .thenAnswer((_) async => entries);
      final selectEd = await clientWithSecret.select(collection, entryIds);
      expect(selectEd, entries);
      when(() => api.select(token, collection, entryIds))
          .thenAnswer((_) async => entries);
    });

    test('upsert', () async {
      const collection = 'food';
      const entryId = 'cheeseburger';

      const data = {'name': 'john', 'favorite_color': 'blue'};
      const entries = [
        CollectionEntry(collection: collection, id: entryId, data: data)
      ];
      when(() =>
              mockTokenHelper.buildCollectionsToken(secret, TokenAction.write))
          .thenReturn(token);
      when(() => api.upsert(token, collection, entries))
          .thenAnswer((_) async => Response(
              data: {},
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      await clientWithSecret.upsert(collection, entries);
      verify(() => api.upsert(token, collection, entries)).called(1);
    });
  });
}
