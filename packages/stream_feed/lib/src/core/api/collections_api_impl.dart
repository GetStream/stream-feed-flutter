import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class CollectionsApiImpl implements CollectionsApi {
  const CollectionsApiImpl(this.client);

  final Dio client;

  @override
  Future<CollectionEntry> add(
      Token token, String userId, CollectionEntry entry) async {
    checkNotNull(entry, "Collection can't be null");
    checkNotNull(entry.collection, "Collection name can't be null");
    checkArgument(
        entry.collection.isNotEmpty, "Collection name can't be empty");
    checkNotNull(entry.data, "Collection data can't be null");
    final result = await client.post<Map>(
      Routes.buildCollectionsUrl(entry.collection),
      options:Options(headers: {'Authorization': '$token'}),
      data: {
        'data': entry.data,
        if (userId != null) 'user_id': userId,
        if (entry.id != null) 'id': entry.id,
      },
    );
    return CollectionEntry.fromJson(result.data);
  }

  @override
  Future<Response> delete(
      Token token, String collection, String entryId) async {
    checkNotNull(collection, "Collection name can't be null");
    checkArgument(collection.isNotEmpty, "Collection name can't be empty");
    checkNotNull(entryId, "Collection id can't be null");
    checkArgument(entryId.isNotEmpty, "Collection id can't be empty");
    return client.delete(
      Routes.buildCollectionsUrl('$collection/$entryId/'),
     options:Options( headers: {'Authorization': '$token'}),
    );
  }

  @override
  Future<Response> deleteMany(
      Token token, String collection, Iterable<String> entryIds) async {
    checkNotNull(collection, "Collection name can't be null");
    checkArgument(collection.isNotEmpty, "Collection name can't be empty");
    checkNotNull(entryIds, "Collection ids can't be null");
    checkArgument(entryIds.isNotEmpty, "Collection ids can't be empty");
    return client.delete(
      Routes.buildCollectionsUrl(),
      options:Options(headers: {'Authorization': '$token'}),
      queryParameters: {
        'collection_name': collection,
        'ids': entryIds.join(','),
      },
    );
  }

  @override
  Future<CollectionEntry> get(
      Token token, String collection, String entryId) async {
    checkNotNull(collection, "Collection name can't be null");
    checkArgument(collection.isNotEmpty, "Collection name can't be empty");
    checkNotNull(entryId, "Collection id can't be null");
    checkArgument(entryId.isNotEmpty, "Collection id can't be empty");
    final result = await client.get<Map>(
      Routes.buildCollectionsUrl('$collection/$entryId/'),
      options:Options(headers: {'Authorization': '$token'}),
    );
    return CollectionEntry.fromJson(result.data);
  }

  @override
  Future<List<CollectionEntry>> select(
      Token token, String collection, Iterable<String> entryIds) async {
    checkNotNull(collection, "Collection name can't be null");
    checkArgument(collection.isNotEmpty, "Collection name can't be empty");
    checkNotNull(entryIds, "Collection ids can't be null");
    checkArgument(entryIds.isNotEmpty, "Collection ids can't be empty");
    final result = await client.get<Map>(
      Routes.buildCollectionsUrl(),
     options:Options( headers: {'Authorization': '$token'}),
      queryParameters: {
        'foreign_ids': entryIds.map((id) => '$collection:$id').join(','),
      },
    );
    final data = (result.data['response']['data'] as List)
        .map((e) => CollectionEntry.fromJson(e))
        .toList(growable: false);
    return data;
  }

  @override
  Future<CollectionEntry> update(
      Token token, String userId, CollectionEntry entry) async {
    checkNotNull(entry, "Collection can't be null");
    checkNotNull(entry.collection, "Collection name can't be null");
    checkArgument(
        entry.collection.isNotEmpty, "Collection name can't be empty");
    checkNotNull(entry.data, "Collection data can't be null");
    final result = await client.put<Map>(
      Routes.buildCollectionsUrl('${entry.collection}/${entry.id}/'),
      options:Options(headers: {'Authorization': '$token'}),
      data: {
        'data': entry.data,
        if (userId != null) 'user_id': userId,
      },
    );
    return CollectionEntry.fromJson(result.data);
  }

  @override
  Future<Response> upsert(
      Token token, String collection, Iterable<CollectionEntry> entries) async {
    checkNotNull(collection, "Collection name can't be null");
    checkArgument(collection.isNotEmpty, "Collection name can't be empty");
    checkNotNull(entries, "Collection data can't be null");
    checkArgument(entries.isNotEmpty, "Collection data can't be empty");
    return client.post(
      Routes.buildCollectionsUrl(),
      options:Options(headers: {'Authorization': '$token'}),
      data: {
        'data': {collection: entries}
      },
    );
  }
}
