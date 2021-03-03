import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';

import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';

part 'paginated.g.dart';

///
class _Paginated<T> extends Equatable {
  ///
  const _Paginated(this.next, this.results, this.duration);

  ///
  final String next;

  ///
  final List<T> results;

  ///
  final String duration;

  @override
  List<Object> get props => [next, results, duration];
}

///
@JsonSerializable(createToJson: true)
class PaginatedReactions extends _Paginated<Reaction> {
  ///
  const PaginatedReactions(
      String next, List<Reaction> results, this.activity, String duration)
      : super(next, results, duration);

  ///
  factory PaginatedReactions.fromJson(Map<String, dynamic> json) =>
      _$PaginatedReactionsFromJson(json);

  @override
  List<Object> get props => [...super.props, activity];

  ///
  final EnrichedActivity activity;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$PaginatedReactionsToJson(this);
}
