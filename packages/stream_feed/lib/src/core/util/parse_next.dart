import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/models/next_params.dart';

NextParams parseNext(String next) {
  final uri = Uri.parse(next);
  final queryParameters = uri.queryParameters;
  final nextParams = NextParams(
      idLT: Filter().idLessThan(queryParameters['id_lt']!),
      limit: int.parse(queryParameters['limit']!),
      ranking: queryParameters['ranking'],
      withOwnReactions: queryParameters['withOwnReactions'] as bool?,
      withRecentReactions: queryParameters['withRecentReactions'] as bool?,
      withReactionCounts: queryParameters['withReactionCounts'] as bool?,
      withOwnChildren: queryParameters['withOwnChildren'] as bool?,
      recentReactionsLimit: queryParameters['recentReactionsLimit'] != null
          ? int.tryParse(queryParameters['recentReactionsLimit']!)
          : null,
      reactionKindsFilter: queryParameters['reactionKindsFilter'],
      offset: queryParameters['offset'] != null
          ? int.tryParse(queryParameters['offset']!)
          : null);
  return nextParams;
}
