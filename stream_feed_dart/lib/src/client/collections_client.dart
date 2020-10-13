import 'package:stream_feed_dart/src/core/models/collection_entry.dart';

abstract class CollectionsClient {
  Future<CollectionEntry> get(String collection, String entryId);

  Future<CollectionEntry> add(
    String collection,
    Map<String, Object> data, {
    String entryId,
    String userId,
  });

  Future<CollectionEntry> update(
    String collection,
    String entryId,
    Map<String, Object> data, {
    String userId,
  });

  Future<void> delete(String collection, String entryId);

  Future<void> upsert(String collection, Iterable<CollectionEntry> entries);

  Future<List<CollectionEntry>> select(String collection, Iterable<String> ids);

  Future<void> deleteMany(String collection, Iterable<String> ids);
}
