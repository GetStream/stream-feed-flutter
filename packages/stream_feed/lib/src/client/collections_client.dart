import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class CollectionsClient {
  const CollectionsClient(this.collections, {this.userToken, this.secret});
  final Token? userToken;
  final String? secret;
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
    final token = userToken ??
        TokenHelper.buildCollectionsToken(secret, TokenAction.write);
    return collections.add(token, userId, entry);
  }

  Future<void> delete(String collection, String entryId) {
    final token = userToken ??
        TokenHelper.buildCollectionsToken(secret, TokenAction.delete);
    return collections.delete(token, collection, entryId);
  }

  Future<CollectionEntry> get(String collection, String entryId) {
    final token = userToken ??
        TokenHelper.buildCollectionsToken(secret, TokenAction.read);
    return collections.get(token, collection, entryId);
  }

  Future<CollectionEntry> update(
    String? collection,
    String? entryId,
    Map<String, Object> data, {
    String? userId,
  }) {
    final entry = CollectionEntry(
      id: entryId,
      collection: collection,
      data: data,
    );
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.write);
    return collections.update(token, userId, entry);
  }

  //Serverside methods

  Future<void> deleteMany(String collection, Iterable<String> ids) {
    //TODO: assert that secret is not null since it is a serverside method
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.delete);
    return collections.deleteMany(token, collection, ids);
  }

  Future<List<CollectionEntry>> select(
      String collection, Iterable<String> ids) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.read);
    return collections.select(token, collection, ids);
  }

  Future<void> upsert(String collection, Iterable<CollectionEntry> entries) {
    final token = TokenHelper.buildCollectionsToken(secret, TokenAction.write);
    return collections.upsert(token, collection, entries);
  }
}
