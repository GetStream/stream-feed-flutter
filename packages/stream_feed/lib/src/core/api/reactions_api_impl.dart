import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/lookup_attribute.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

import 'package:stream_feed_dart/src/core/api/reactions_api.dart';

class ReactionsApiImpl implements ReactionsApi {
  const ReactionsApiImpl(this.client);

  final HttpClient client;

  @override
  Future<Reaction> add(Token token, Reaction reaction) async {
    checkNotNull(reaction, "Reaction can't be null");
    checkArgument(reaction.activityId != null || reaction.parent != null,
        'Reaction has to either have and activity ID or parent');
    checkArgument(reaction.activityId == null || reaction.parent == null,
        "Reaction can't have both activity ID and parent");
    if (reaction.activityId != null) {
      checkArgument(reaction.activityId!.isNotEmpty,
          "Reaction activity ID can't be empty");
    }
    if (reaction.parent != null) {
      checkArgument(
          reaction.parent!.isNotEmpty, "Reaction parent can't be empty");
    }
    checkNotNull(reaction.kind, "Reaction kind can't be null");
    checkArgument(reaction.kind!.isNotEmpty, "Reaction kind can't be empty");
    final result = await client.post<Map>(
      Routes.buildReactionsUrl(),
      headers: {'Authorization': '$token'},
      data: reaction,
    );
    return Reaction.fromJson(result.data as Map<String, dynamic>);
  }

  @override
  Future<Reaction> get(Token token, String id) async {
    checkNotNull(id, "Reaction id can't be null");
    checkArgument(id.isNotEmpty, "Reaction id can't be empty");
    final result = await client.get<Map>(
      Routes.buildReactionsUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
    return Reaction.fromJson(result.data as Map<String, dynamic>);
  }

  @override
  Future<Response> delete(Token token, String? id) async {
    checkNotNull(id, "Reaction id can't be null");
    checkArgument(id!.isNotEmpty, "Reaction id can't be empty");
    return client.delete(
      Routes.buildReactionsUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
  }

  @override
  Future<List<Reaction>> filter(
    Token token,
    LookupAttribute lookupAttr,
    String lookupValue,
    Filter filter,
    int limit,
    String kind,
  ) async {
    checkNotNull(lookupAttr, "Lookup attr can't be null");
    checkNotNull(lookupValue, "Lookup value can't be null");
    checkArgument(lookupValue.isNotEmpty, "Lookup value can't be empty");
    checkNotNull(filter, "Filter can't be null");
    checkNotNull(kind, "Kind can't be null");
    final result = await client.get<Map>(
      Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit.toString(),
        ...filter.params,
        'with_activity_data': lookupAttr == LookupAttribute.activityId,
      },
    );
    final data = (result.data!['results'] as List)
        .map((e) => Reaction.fromJson(e))
        .toList(growable: false);
    return data;
  }

  @override
  Future<PaginatedReactions> paginatedFilter(
    Token token,
    LookupAttribute lookupAttr,
    String lookupValue,
    Filter filter,
    int limit,
    String kind,
  ) async {
    checkNotNull(lookupAttr, "Lookup attr can't be null");
    checkNotNull(lookupValue, "Lookup value can't be null");
    checkArgument(lookupValue.isNotEmpty, "Lookup value can't be empty");
    checkNotNull(filter, "Filter can't be null");
    checkNotNull(kind, "Kind can't be null");
    final result = await client.get(
      Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit.toString(),
        ...filter.params,
        'with_activity_data': lookupAttr == LookupAttribute.activityId,
      },
    );
    return PaginatedReactions.fromJson(result.data);
  }

  @override
  Future<PaginatedReactions> nextPaginatedFilter(
      Token token, String next) async {
    checkNotNull(next, "Next url can't be null");
    checkArgument(next.isNotEmpty, "Next url can't be empty");
    final result = await client.get(
      next,
      headers: {'Authorization': '$token'},
    );
    return PaginatedReactions.fromJson(result.data);
  }

  @override
  Future<Response> update(Token token, Reaction updatedReaction) async {
    checkNotNull(updatedReaction, "Reaction can't be null");
    checkNotNull(updatedReaction.id, "Reaction id can't be null");
    checkArgument(updatedReaction.id!.isNotEmpty, "Reaction id can't be empty");
    final targetFeedIds = updatedReaction.targetFeeds!
        .map((e) => e.toString())
        .toList(growable: false);
    final reactionId = updatedReaction.id;
    final data = updatedReaction.data;
    return client.put(
      Routes.buildReactionsUrl('$reactionId/'),
      headers: {'Authorization': '$token'},
      data: {
        if (data != null && data.isNotEmpty) 'data': data,
        if (targetFeedIds.isNotEmpty) 'target_feeds': targetFeedIds,
      },
    );
  }
}
