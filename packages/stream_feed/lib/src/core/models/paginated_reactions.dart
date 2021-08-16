import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/paginated.dart';
import 'package:stream_feed/src/core/models/reaction.dart';

part 'paginated_reactions.g.dart';

/// Paginated [Reaction]
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
class PaginatedReactions<A> extends Paginated<Reaction> {
  /// Builds a [PaginatedReactions].
  const PaginatedReactions(
      String? next, List<Reaction>? results, this.activity, String? duration)
      : super(next, results, duration);

  /// Deserialize json to [PaginatedReactions]
  factory PaginatedReactions.fromJson(
    Map<String, dynamic> json,
    A Function(Object? json) fromJsonA,
  ) =>
      _$PaginatedReactionsFromJson<A>(json, fromJsonA);

  @override
  List<Object?> get props => [...super.props, activity];

  /// The activity data.
  ///
  /// This field is returned only when with_activity_data is sent.
  final EnrichedActivity<A>? activity;

  /// Serialize to json
  Map<String, dynamic> toJson(Object? Function(A value) toJsonA) =>
      _$PaginatedReactionsToJson(this, toJsonA);
}
