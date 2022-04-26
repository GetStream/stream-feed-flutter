import 'package:equatable/equatable.dart';
import 'package:stream_feed/src/core/models/filter.dart';

class NextParams extends Equatable {
  const NextParams({
    required this.limit,
    required this.idLT,
    this.ranking,
    this.withOwnReactions,
    this.withRecentReactions,
    this.withReactionCounts,
    this.withOwnChildren,
    this.recentReactionsLimit,
    this.reactionKindsFilter,
    this.offset,
  });

  final int limit;
  final Filter idLT;
  final int? offset;
  final String? ranking;
  final bool? withOwnReactions;
  final bool? withRecentReactions;
  final bool? withReactionCounts;
  final bool? withOwnChildren;
  final int? recentReactionsLimit;
  final String? reactionKindsFilter;

  @override
  List<Object?> get props => [limit, idLT];
}
