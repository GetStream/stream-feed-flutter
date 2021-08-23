import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/collections_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/collection_entry.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('CollectionsClient', () {
    final api = MockCollectionsAPI();

    const secret = 'secret';
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

    test('entry', () {
      const entryId = 'entryId';
      const collection = 'collection';
      final entry = client.entry(collection, entryId);
      expect(entry, const CollectionEntry(collection: collection, id: entryId));
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
        entry,
        userId: userId,
      );
      expect(updatedCollection, entry);
      verify(() => api.update(token, userId, entry)).called(1);
    });

    test('deleteMany', () async {
      const collection = 'food';
      const entryId = 'cheeseburger';
      final entryIds = [entryId];

      final token =
          TokenHelper.buildCollectionsToken(secret, TokenAction.delete);
      final clientWithSecret = CollectionsClient(api, secret: secret);
      when(() => api.deleteMany(token, collection, entryIds))
          .thenAnswer((_) async => Response<Map>(
              data: {}, //TODO: flaky
              requestOptions: RequestOptions(
                path: '',
              ),
              statusCode: 200));
      await clientWithSecret.deleteMany(collection, entryIds);
      verify(() => api.deleteMany(token, collection, entryIds)).called(1);
    });

    test('select', () async {
      const collection = 'food';
      const entryId = 'cheeseburger';
      const entryIds = [entryId];
      const entries = [CollectionEntry(id: entryId, collection: collection)];
      final token =
          TokenHelper.buildCollectionsToken('secret', TokenAction.read);
      final clientWithSecret = CollectionsClient(api, secret: secret);
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
      final token =
          TokenHelper.buildCollectionsToken(secret, TokenAction.write);
      final clientWithSecret = CollectionsClient(api, secret: secret);
      when(() => api.upsert(token, collection, entries))
          .thenAnswer((_) async => entries);
      await clientWithSecret.upsert(collection, entries);
      verify(() => api.upsert(token, collection, entries)).called(1);
    });
  });
}
