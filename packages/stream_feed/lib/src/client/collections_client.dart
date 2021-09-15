import 'package:stream_feed/src/core/api/collections_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/collection_entry.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template collections}
/// Collections enable you to store information to Stream.
///
/// This allows you to use it inside your feeds,
/// and to provide additional data for the personalized endpoints.
///
/// Examples include products and articles,
/// but any unstructured object (e.g. JSON)
/// is a good match for collections.
///
/// Collection entries can be embedded inside activities
/// and used to store nested data inside activities.
///
/// When doing so, Stream will automatically enrich your activities
/// with the current version of the data (see later section).
///
/// Collection endpoints can be used both client-side
/// and server-side except the batch methods that are only available server-side
/// {@endtemplate}
class CollectionsClient {
  /// Initialize a CollectionsClient object
  ///
  ///{@macro collections}
  const CollectionsClient(this._collections, {this.userToken, this.secret})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  /// Your user token obtain via the dashboard.
  /// Required if you are using the sdk client side
  final Token? userToken;

  /// Your API secret obtained via the dashboard.
  /// Required if you are using the sdk server side
  final String? secret;
  final CollectionsAPI _collections;

  CollectionEntry entry(String collection, String entryId) =>
      CollectionEntry(collection: collection, id: entryId);

  /// Add item to collection
  ///
  /// # Usage:
  ///
  /// For example let's add our CheeseBurger object to the food collection
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
  Future<CollectionEntry> add(
    String collection,
    Map<String, Object> data, {
    String? entryId,
    String? userId,
  }) {
    //TODO: infer userID or put it in class constructor
    final entry = CollectionEntry(
      id: entryId,
      collection: collection,
      data: data,
    );
    final token = userToken ??
        TokenHelper.buildCollectionsToken(secret!, TokenAction.write);
    return _collections.add(token, userId, entry);
  }

  /// Delete entry from collection
  ///
  /// ## Parameters
  /// [entryId] : Collection entry id
  /// [collection] : Collection name
  ///
  /// ## Usage:
  ///
  /// Let's delete the burger we created in the [add] example, like this:
  /// ```dart
  /// await client.collections.delete('food', 'cheese-burger');
  /// ```
  /// API docs: [removing-collections](https://getstream.io/activity-feeds/docs/flutter-dart/collections_introduction/?language=dart#removing-collections)
  Future<void> delete(String collection, String entryId) {
    final token = userToken ??
        TokenHelper.buildCollectionsToken(secret!, TokenAction.delete);
    return _collections.delete(token, collection, entryId);
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
  Future<CollectionEntry> get(String collection, String entryId) {
    final token = userToken ??
        TokenHelper.buildCollectionsToken(secret!, TokenAction.read);
    return _collections.get(token, collection, entryId);
  }

  /// Update item in the object storage
  ///
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
  Future<CollectionEntry> update(
    CollectionEntry entryCopy, {
    String? userId,
  }) {
    final token = userToken ??
        TokenHelper.buildCollectionsToken(secret!, TokenAction.write);
    return _collections.update(token, userId, entryCopy);
  }

  //------------------------- Server side methods ----------------------------//

  /// Remove all objects by id from the collection.
  ///
  /// ### Parameters:
  /// [collection] : collections name
  /// [ids] : an array of ids we want to delete
  ///
  /// ### Usage
  /// For example, to delete the entries with ID 123 and 124
  /// from visitor collection we do this
  /// ```dart
  /// await client.collections.deleteMany('visitor', ['123', '124']);
  /// ```
  /// API docs : [delete_many](https://getstream.io/activity-feeds/docs/flutter-dart/collections_batch/?language=dart#delete_many)
  Future<void> deleteMany(String collection, Iterable<String> ids) {
    //TODO: assert that secret is not null since it is a serverside method
    final token =
        TokenHelper.buildCollectionsToken(secret!, TokenAction.delete);
    return _collections.deleteMany(token, collection, ids);
  }

  /// Select all objects with ids from the collection.
  ///
  /// ### Parameters
  /// [collection] : collection name
  /// [ids] : an array of ids
  ///
  /// ### Usage
  /// To select the entries with ID 123 and 124 from items collection
  ///  we do this:
  /// ```dart
  /// final objects = await client.collections.select('items', ['123', '124']);
  /// ```
  ///
  /// API docs: [select](https://getstream.io/activity-feeds/docs/flutter-dart/collections_batch/?language=dart#select)
  Future<List<CollectionEntry>> select(
      String collection, Iterable<String> ids) {
    final token = TokenHelper.buildCollectionsToken(secret!, TokenAction.read);
    return _collections.select(token, collection, ids);
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
  Future<List<CollectionEntry>> upsert(
      String collection, Iterable<CollectionEntry> entries) {
    final token = TokenHelper.buildCollectionsToken(secret!, TokenAction.write);
    return _collections.upsert(token, collection, entries);
  }
}
