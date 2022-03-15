import 'package:equatable/equatable.dart';
import 'package:test/test.dart';

void main() {
  test('parse_next', () {
    const next =
        '/api/v1.0/feed/user/1/?api_key=8rxdnw8pjmvb&id_lt=b253bfa1-83b3-11ec-8dc7-0a5c4613b2ff&limit=25';

    expect(parseNext(next),
        NextParams(limit: 25, idLT: 'b253bfa1-83b3-11ec-8dc7-0a5c4613b2ff'));
  });
}

NextParams parseNext(String next) {
  final uri = Uri.parse(next);
  final queryParameters = uri.queryParameters;
  final nextParams = NextParams(
      idLT: queryParameters['id_lt']!,
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

// List<String> parseNext(String next) {
//   //NextParams
//   final params = next.split('&');
//   // remove url
//   params.removeAt(0);

//   return params;
// }

class NextParams extends Equatable {
  final int limit;
  final String idLT;
  final int? offset;
  final String? ranking;
  final bool? withOwnReactions;
  final bool? withRecentReactions;
  final bool? withReactionCounts;
  final bool? withOwnChildren;
  final int? recentReactionsLimit;
  final String? reactionKindsFilter;

  NextParams(
      {required this.limit,
      required this.idLT,
      this.ranking,
      this.withOwnReactions,
      this.withRecentReactions,
      this.withReactionCounts,
      this.withOwnChildren,
      this.recentReactionsLimit,
      this.reactionKindsFilter,
      this.offset});

  @override
  List<Object?> get props => [limit, idLT];
}
