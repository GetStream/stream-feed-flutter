import 'package:stream_feed_dart/src/models/collection_data.dart';

import 'collections_client.dart';

class CollectionsClientImpl implements CollectionsClient {
  @override
  Future<CollectionData> add(
      String collection, String itemId, CollectionData data) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String collection, String entryId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany(String collection, Iterable<String> ids) {
    // TODO: implement deleteMany
    throw UnimplementedError();
  }

  @override
  Future<CollectionData> get(String collection, String itemId) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<CollectionData>> select(String collection, Iterable<String> ids) {
    // TODO: implement select
    throw UnimplementedError();
  }

  @override
  Future<CollectionData> update(
      String collection, String entryId, CollectionData data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> upsert(String collection, Iterable<CollectionData> data) {
    // TODO: implement upsert
    throw UnimplementedError();
  }
}
