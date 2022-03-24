import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/collections_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/collection_entry.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

Future<void> main() async {
  group('Collections API', () {
    final mockClient = MockHttpClient();
    final collectionsApi = CollectionsAPI(mockClient);
    test('Add', () async {
      const token = Token('dummyToken');
      const userId = 'userId';
      const entry = CollectionEntry(collection: 'users', id: '123', data: {
        'name': 'john',
        'favorite_color': 'blue',
      });

      when(() => mockClient.post<Map<String, dynamic>>(
            Routes.buildCollectionsUrl(entry.collection),
            headers: {'Authorization': '$token'},
            data: {
              'data': entry.data,
              'user_id': userId,
              if (entry.id != null) 'id': entry.id,
            },
          )).thenAnswer((_) async => Response(
            data: jsonFixture('collection_entry.json'),
            statusCode: 200,
            requestOptions: RequestOptions(
              path: Routes.buildCollectionsUrl(entry.collection),
            ),
          ));

      await collectionsApi.add(token, userId, entry);

      verify(() => mockClient.post<Map<String, dynamic>>(
            Routes.buildCollectionsUrl(entry.collection),
            headers: {'Authorization': '$token'},
            data: {
              'data': entry.data,
              'user_id': userId,
              if (entry.id != null) 'id': entry.id,
            },
          )).called(1);
    });

    test('Delete', () async {
      const token = Token('dummyToken');
      const collection = 'food';
      const entryId = 'cheeseburger';
      when(() => mockClient.delete(
            Routes.buildCollectionsUrl('$collection/$entryId/'),
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildCollectionsUrl('$collection/$entryId/'),
          ),
          statusCode: 200));

      await collectionsApi.delete(token, collection, entryId);

      verify(() => mockClient.delete(
            Routes.buildCollectionsUrl('$collection/$entryId/'),
            headers: {'Authorization': '$token'},
          )).called(1);
    });

    test('DeleteMany', () async {
      const token = Token('dummyToken');
      const collection = 'food';
      const entryId = 'cheeseburger';
      final entryIds = [entryId];
      when(() => mockClient.delete(
            Routes.buildCollectionsUrl(),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'collection_name': collection,
              'ids': entryIds.join(','),
            },
          )).thenAnswer((_) async => Response<Map>(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildCollectionsUrl(),
          ),
          statusCode: 200));

      await collectionsApi.deleteMany(token, collection, entryIds);

      verify(() => mockClient.delete(
            Routes.buildCollectionsUrl(),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'collection_name': collection,
              'ids': entryIds.join(','),
            },
          )).called(1);
    });

    test('Get', () async {
      const token = Token('dummyToken');
      const collection = 'food';
      const entryId = 'cheeseburger';
      when(() => mockClient.get<Map<String, dynamic>>(
            Routes.buildCollectionsUrl('$collection/$entryId/'),
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: jsonFixture('collection_entry.json'),
          requestOptions: RequestOptions(
            path: Routes.buildCollectionsUrl('$collection/$entryId/'),
          ),
          statusCode: 200));

      await collectionsApi.get(token, collection, entryId);

      verify(() => mockClient.get<Map<String, dynamic>>(
            Routes.buildCollectionsUrl('$collection/$entryId/'),
            headers: {'Authorization': '$token'},
          )).called(1);
    });

    test('Select', () async {
      const token = Token('dummyToken');
      const collection = 'food';
      const entryId = 'cheeseburger';
      const entryIds = [entryId];
      when(() => mockClient.get<Map>(
            Routes.buildCollectionsUrl(),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'foreign_ids': entryIds.map((id) => '$collection:$id').join(','),
            },
          )).thenAnswer((_) async => Response(
              data: {
                'response': {
                  'data': [jsonFixture('collection_entry.json')]
                }
              },
              requestOptions: RequestOptions(
                path: Routes.buildCollectionsUrl(),
              ),
              statusCode: 200));

      await collectionsApi.select(token, collection, entryIds);

      verify(() => mockClient.get<Map>(
            Routes.buildCollectionsUrl(),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'foreign_ids': entryIds.map((id) => '$collection:$id').join(','),
            },
          )).called(1);
    });

    test('Update', () async {
      const token = Token('dummyToken');
      const userId = 'userId';
      const entry = CollectionEntry(collection: 'users', id: '123', data: {
        'name': 'john',
        'favorite_color': 'blue',
      });
      when(() => mockClient.put<Map<String, dynamic>>(
            Routes.buildCollectionsUrl('${entry.collection}/${entry.id}/'),
            headers: {'Authorization': '$token'},
            data: {
              'data': entry.data,
              'user_id': userId,
            },
          )).thenAnswer((_) async => Response(
          data: jsonFixture('collection_entry.json'),
          requestOptions: RequestOptions(
            path:
                Routes.buildCollectionsUrl('${entry.collection}/${entry.id}/'),
          ),
          statusCode: 200));

      await collectionsApi.update(token, userId, entry);

      verify(() => mockClient.put<Map<String, dynamic>>(
            Routes.buildCollectionsUrl('${entry.collection}/${entry.id}/'),
            headers: {'Authorization': '$token'},
            data: {
              'data': entry.data,
              'user_id': userId,
            },
          )).called(1);
    });

    test('Upsert', () async {
      const token = Token('dummyToken');
      const collection = 'food';
      const entries = [
        CollectionEntry(collection: 'users', id: '123', data: {
          'name': 'john',
          'favorite_color': 'blue',
        })
      ];
      final rawEntries = [jsonFixture('collection_entry.json')];
      when(() => mockClient.post<Map>(
            Routes.buildCollectionsUrl(),
            headers: {'Authorization': '$token'},
            data: {
              'data': {collection: entries}
            },
          )).thenAnswer((_) async => Response<Map>(
              data: {
                'data': {collection: rawEntries}
              },
              requestOptions: RequestOptions(
                path: Routes.buildCollectionsUrl(),
              ),
              statusCode: 200));

      await collectionsApi.upsert(token, collection, entries);

      verify(() => mockClient.post<Map>(
            Routes.buildCollectionsUrl(),
            headers: {'Authorization': '$token'},
            data: {
              'data': {collection: entries}
            },
          )).called(1);
    });
  });
}
