import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';

class CloudCollectionsClient {
  const CloudCollectionsClient(this.token, this.collections);
  final Token token;
  final CollectionsApi collections;

  
  Future<CollectionEntry> add(
    String collection,
    Map<String, Object> data, {
    String? entryId,
    String? userId,
  }) {
    final entry = CollectionEntry(
      id: entryId,
      collection: collection,
      data: data,
    );
    return collections.add(token, userId, entry);
  }

  
  Future<void> delete(String collection, String entryId) =>
      collections.delete(token, collection, entryId);

  
  Future<CollectionEntry> get(String collection, String entryId) =>
      collections.get(token, collection, entryId);

  
  Future<CollectionEntry> update(
    String collection,
    String entryId,
    Map<String, Object> data, {
    String? userId,
  }) {
    final entry = CollectionEntry(
      id: entryId,
      collection: collection,
      data: data,
    );
    return collections.update(token, userId, entry);
  }
}
