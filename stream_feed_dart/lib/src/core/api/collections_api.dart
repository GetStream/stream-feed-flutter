import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';

abstract class CollectionsApi {
  Future<CollectionEntry> add(
      Token token, String userId, CollectionEntry entry);

  Future<CollectionEntry> update(
      Token token, String userId, CollectionEntry entry);

  Future<Response> upsert(
      Token token, String collection, Iterable<CollectionEntry> entries);

  Future<CollectionEntry> get(Token token, String collection, String entryId);

  Future<List<CollectionEntry>> select(
      Token token, String collection, Iterable<String> entryIds);

  Future<Response> delete(Token token, String collection, String entryId);

  Future<Response> deleteMany(
      Token token, String collection, Iterable<String> entryIds);

}
