import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/paginated.dart';
import 'package:stream_feed/src/core/models/reaction.dart';

part 'paginated_reactions.g.dart';

/// Paginated [Reaction]
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
class PaginatedReactions<A, Ob> extends Paginated<Reaction> {
  /// Builds a [PaginatedReactions].
  const PaginatedReactions(
      String? next, List<Reaction>? results, this.activity, String? duration)
      : super(next, results, duration);

  /// Deserialize json to [PaginatedReactions]
  factory PaginatedReactions.fromJson(
    Map<String, dynamic> json,
    A Function(Object? json) fromJsonA,
    Ob Function(Object? json) fromJsonOb,
  ) =>
      _$PaginatedReactionsFromJson<A, Ob>(json, fromJsonA, fromJsonOb);

  @override
  List<Object?> get props => [...super.props, activity];

  /// The activity data.
  ///
  /// This field is returned only when with_activity_data is sent.
  final EnrichedActivity<A, Ob>? activity;

  /// Serialize to json
  Map<String, dynamic> toJson(
    Object? Function(A value) toJsonA,
    Object? Function(Ob value) toJsonOb,
  ) =>
      _$PaginatedReactionsToJson(this, toJsonA, toJsonOb);
}
