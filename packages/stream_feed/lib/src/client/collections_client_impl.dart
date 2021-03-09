import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

import 'package:stream_feed_dart/src/client/collections_client.dart';

class CollectionsClientImpl implements CollectionsClient {
  const CollectionsClientImpl(this.secret, this.collections);
  final String secret;
  final CollectionsApi collections;

  /// Add item to collection
  /// 
  /// Usage:
  /// 
  /// For example let's our CheeseBurger object to the food collection
  /// ```dart
  /// final cheeseBurger = await client.collections.add(
  ///   'food',
  ///   {
  ///     'name': 'Cheese Burger',
  ///     'ingredients': [
  ///       'cheese',
  ///       'burger',
  ///       'bread',
  ///       'lettuce',
  ///       'tomato',
  ///     ],
  ///   },
  ///   entryId: '123',
  /// );
  /// ```
  /// Example
  /// Parameters:
  /// - [collection] : collection name
  /// - [entryId] : entry id, if null a random id will be assigned to the item
  /// - [data] :  ObjectStore data
  ///
  /// API docs: [adding-collections](https://getstream.io/activity-feeds/docs/flutter-dart/collections_introduction/?language=dart#adding-collections)
  @override
  Future<CollectionEntry> add(
    String collection,
    Map<String, Object> data, {
    String entryId,
    String userId,
  }) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.write);
    final entry = CollectionEntry(
      id: entryId,
      collection: collection,
      data: data,
    );
    return collections.add(token, userId, entry);
  }

  @override
  Future<void> delete(String collection, String entryId) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.delete);
    return collections.delete(token, collection, entryId);
  }

  @override
  Future<void> deleteMany(String collection, Iterable<String> ids) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.delete);
    return collections.deleteMany(token, collection, ids);
  }

  @override
  Future<CollectionEntry> get(String collection, String entryId) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.read);
    return collections.get(token, collection, entryId);
  }

  @override
  Future<List<CollectionEntry>> select(
      String collection, Iterable<String> ids) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.read);
    return collections.select(token, collection, ids);
  }

  @override
  Future<CollectionEntry> update(
    String collection,
    String entryId,
    Map<String, Object> data, {
    String userId,
  }) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.write);
    final entry = CollectionEntry(
      id: entryId,
      collection: collection,
      data: data,
    );
    return collections.update(token, userId, entry);
  }

  @override
  Future<void> upsert(String collection, Iterable<CollectionEntry> entries) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.write);
    return collections.upsert(token, collection, entries);
  }
}
