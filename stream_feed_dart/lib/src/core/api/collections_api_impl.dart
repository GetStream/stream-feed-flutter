import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class CollectionsApiImpl implements CollectionsApi {
  final HttpClient client;

  const CollectionsApiImpl(this.client);

  @override
  Future<CollectionEntry> add(
      Token token, String userId, CollectionEntry entry) async {
    final result = await client.post(
      Routes.buildCollectionsUrl('${entry.collection}'),
      headers: {'Authorization': '$token'},
      data: {
        'data': entry.data,
        if (userId != null) 'user_id': userId,
        if (entry.id != null) 'id': entry.id,
      },
    );
    print(result);
  }

  @override
  Future<void> delete(Token token, String collection, String entryId) async {
    final result = await client.delete(
      Routes.buildCollectionsUrl('$collection/$entryId/'),
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  Future<void> deleteMany(
      Token token, String collection, Iterable<String> entryIds) async {
    final result = await client.delete(
      Routes.buildCollectionsUrl(),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'collection_name': collection,
        'ids': entryIds.join(','),
      },
    );
    print(result);
  }

  @override
  Future<CollectionEntry> get(
      Token token, String collection, String entryId) async {
    final result = await client.get(
      Routes.buildCollectionsUrl('$collection/$entryId/'),
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  Future<List<CollectionEntry>> select(
      Token token, String collection, Iterable<String> entryIds) async {
    final result = await client.get(
      Routes.buildCollectionsUrl(),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'foreign_ids': entryIds.map((id) => '$collection:$id').toList(),
      },
    );
    print(result);
  }

  @override
  Future<CollectionEntry> update(
      Token token, String userId, CollectionEntry entry) async {
    final result = await client.put(
      Routes.buildCollectionsUrl('${entry.collection}/${entry.id}/'),
      headers: {'Authorization': '$token'},
      data: {
        'data': entry.data,
        if (userId != null) 'user_id': userId,
      },
    );
    print(result);
  }

  @override
  Future<void> upsert(
      Token token, String collection, Iterable<CollectionEntry> entries) async {
    final result = await client.post(
      Routes.buildCollectionsUrl(),
      headers: {'Authorization': '$token'},
      data: {
        'data': {collection: entries}
      },
    );
    print(result);
  }

  @override
  String ref(String collection, String entryId) => 'SO:$collection:$entryId';
}
