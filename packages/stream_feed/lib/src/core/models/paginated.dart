import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';

import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';

part 'paginated.g.dart';

/// A general paginated response object.
class _Paginated<T> extends Equatable {
  /// [_Paginated] constructor
  const _Paginated(this.next, this.results, this.duration);

  /// A url string that can be used to fetch the next page of reactions.
  final String? next;

  /// Response results of generic objects.
  final List<T>? results;

  /// A duration of the response.
  final String? duration;

  @override
  List<Object?> get props => [next, results, duration];
}

/// Paginated [Reaction]
@JsonSerializable(createToJson: true)
class PaginatedReactions extends _Paginated<Reaction> {
  /// [PaginatedReactions] constructor
  const PaginatedReactions(
      String? next, List<Reaction>? results, this.activity, String? duration)
      : super(next, results, duration);

  /// Deserilize json to [PaginatedReactions]
  factory PaginatedReactions.fromJson(Map<String, dynamic> json) =>
      _$PaginatedReactionsFromJson(json);

  @override
  List<Object?> get props => [...super.props, activity];

  /// The activity data,
  /// this field is returned only when with_activity_data is sent.
  final EnrichedActivity? activity;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$PaginatedReactionsToJson(this);
}
