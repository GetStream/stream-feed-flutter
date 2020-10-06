import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';

import 'activity.dart';

part 'paginated.g.dart';

///
class _Paginated<T> extends Equatable {
  ///
  final String next;

  ///
  final List<T> results;

  ///
  final String duration;

  ///
  const _Paginated(this.next, this.results, this.duration);

  @override
  List<Object> get props => [next, results, duration];
}

///
@JsonSerializable(createToJson: false)
class PaginatedReactions extends _Paginated<Reaction> {
  ///
  const PaginatedReactions(
      String next, List<Reaction> results, this.activity, String duration)
      : super(next, results, duration);

  ///
  final EnrichedActivity activity;

  ///
  factory PaginatedReactions.fromJson(Map<String, dynamic> json) =>
      _$PaginatedReactionsFromJson(json);
}
