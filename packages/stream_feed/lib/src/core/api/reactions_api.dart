import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/lookup_attribute.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';

abstract class ReactionsApi {
  Future<Reaction> add(Token token, Reaction reaction);

  Future<Reaction> get(Token token, String id);

  Future<Response> update(Token token, Reaction updatedReaction);

  Future<Response> delete(Token token, String? id);

  Future<List<Reaction>> filter(Token token, LookupAttribute lookupAttr,
      String lookupValue, Filter filter, int limit, String kind);

  Future<PaginatedReactions> paginatedFilter(
      Token token,
      LookupAttribute lookupAttr,
      String lookupValue,
      Filter filter,
      int limit,
      String kind);

  Future<PaginatedReactions> nextPaginatedFilter(Token token, String next);
}
