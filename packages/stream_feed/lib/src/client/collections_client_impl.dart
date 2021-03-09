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

  /// Delete entry from collection
  ///
  /// ## Parameters
  /// [entryId] : Collection entry id
  /// [collection] : Collection name
  ///
  ///
  /// ## Usage:
  ///
  /// Let's delete the burger we created in the [add] example, like this:
  /// ```dart
  /// await client.collections.delete('food', 'cheese-burger');
  /// ```
  /// API docs: [removing-collections](https://getstream.io/activity-feeds/docs/flutter-dart/collections_introduction/?language=dart#removing-collections)
  @override
  Future<void> delete(String collection, String entryId) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.delete);
    return collections.delete(token, collection, entryId);
  }

  /// Remove all objects by id from the collection.
  ///
  /// ### Parameters:
  /// [collection] : collections name
  /// [ids] : an array of ids we want to delete
  /// ### Usage
  /// For example, to delete the entries with ID 123 and 124
  /// from visitor collection we do this
  /// ```dart
  /// await client.collections.deleteMany('visitor', ['123', '124']);
  /// ```
  /// API docs : [delete_many](https://getstream.io/activity-feeds/docs/flutter-dart/collections_batch/?language=dart#delete_many)
  @override
  Future<void> deleteMany(String collection, Iterable<String> ids) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.delete);
    return collections.deleteMany(token, collection, ids);
  }

  /// Get item from collection and sync data
  ///
  /// ### Parameters
  /// [collection] : collections name
  /// [entryId] : the id of the collection entry we want to get
  ///
  /// ### Usage
  /// ```dart
  /// final collection = await client.collections.get('food', 'cheese-burger');
  /// ```
  @override
  Future<CollectionEntry> get(String collection, String entryId) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.read);
    return collections.get(token, collection, entryId);
  }

  /// Select all objects with ids from the collection.
  ///
  /// ### Parameters
  /// [collection] : collection name
  /// [ids] : an array of ids
  /// ### Usage
  /// To select the entries with ID 123 and 124 from items collection
  ///  we do this:
  /// ```dart
  /// final objects = await client.collections.select('items', ['123', '124']);
  /// ```
  ///
  /// API docs: [select](https://getstream.io/activity-feeds/docs/flutter-dart/collections_batch/?language=dart#select)
  @override
  Future<List<CollectionEntry>> select(
      String collection, Iterable<String> ids) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.read);
    return collections.select(token, collection, ids);
  }

  /// Update item in the object storage
  /// ### Parameters
  ///  - [collection] :  collection name
  ///  - [data] :  ObjectStore data
  ///  - [entryId] : Collection entry id
  ///
  /// ### Usage
  /// Let's update our cheeseburger
  /// ```dart
  ///   await client.collections.update('food', 'cheese-burger', {
  ///   'name': 'Cheese Burger',
  ///   'rating': '1 Star',
  /// });
  /// ```
  ///
  /// API docs : [updating-collections](https://getstream.io/activity-feeds/docs/flutter-dart/collections_introduction/?language=dart#updating-collections)
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

  /// Upsert one or more items within a collection.
  ///
  /// ### Parameters
  /// - [collection] : collection name
  /// - [entries] : an array of collection entries
  ///
  /// ### Usage
  ///
  /// ```dart
  /// await client.collections.upsert('visitor', <CollectionEntry>[
  ///   const CollectionEntry(id: '123', data: {
  ///     'name': 'john',
  ///     'favorite_color': 'blue',
  ///   }),
  ///   const CollectionEntry(id: '124', data: {
  ///     'name': 'jane',
  ///     'favorite_color': 'purple',
  ///     'interests': ['fashion', 'jazz'],
  ///   }),
  /// ]);
  /// ```
  /// API docs : [upsert](https://getstream.io/activity-feeds/docs/flutter-dart/collections_batch/?language=dart#upsert)
  @override
  Future<void> upsert(String collection, Iterable<CollectionEntry> entries) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.write);
    return collections.upsert(token, collection, entries);
  }
}
