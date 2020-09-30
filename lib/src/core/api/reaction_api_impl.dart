import 'package:stream_feed_dart/src/core/api/reaction_api.dart';
import 'package:stream_feed_dart/src/core/filter.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/lookup_attribute.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:stream_feed_dart/src/core/models/reaction_filter.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class ReactionsApiImpl implements ReactionsApi {
  final HttpClient client;

  const ReactionsApiImpl(this.client);

  @override
  Future<Reaction> add(Token token, Reaction reaction) async {
    final result = await client.post(
      Routes.buildReactionsUrl(),
      headers: {'Authorization': '$token'},
      data: reaction,
    );
    print(result);
  }

  @override
  Future<Reaction> get(Token token, String id) async {
    final result = await client.get(
      Routes.buildReactionsUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  Future<void> delete(Token token, String id) async {
    final result = await client.delete(
      Routes.buildReactionsUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  Future<List<Reaction>> filter(Token token, LookupAttribute lookupAttr,
      String lookupValue, ReactionFilter filter, int limit, String kind) async {
    final result = await client.get(
      Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit.toString(),
        if (filter != null) filter.filter.name: filter.id,
        'with_activity_data': lookupAttr == LookupAttribute.activity_id,
      },
    );
    print(result);
  }

  @override
  Future<PaginatedReactions> paginatedFilter(
    Token token,
    LookupAttribute lookupAttr,
    String lookupValue,
    ReactionFilter filter,
    int limit,
    String kind,
  ) async {
    final result = await client.get(
      Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit.toString(),
        if (filter != null) filter.filter.name: filter.id,
        'with_activity_data': lookupAttr == LookupAttribute.activity_id,
      },
    );
    final data = PaginatedReactions.fromJson(result.data);
    print(result);
  }

  @override
  Future<PaginatedReactions> nextPaginatedFilter(
      Token token, String next) async {
    final result = await client.get(
      next,
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  Future<void> update(Token token, Reaction updatedReaction) async {
    final targetFeedIds = updatedReaction.targetFeeds?.map((e) => e.toString());
    final reactionId = updatedReaction.id;
    final data = updatedReaction.data;
    final result = await client.put(
      Routes.buildReactionsUrl('$reactionId/'),
      headers: {'Authorization': '$token'},
      data: {
        if (data != null && data.isNotEmpty) 'data': data,
        if (targetFeedIds != null && targetFeedIds.isNotEmpty)
          'target_feeds': targetFeedIds,
      },
    );
    print(result);
  }
}
