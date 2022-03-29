import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/collection_entry.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/paginated.dart';
import 'package:stream_feed/src/core/models/reaction.dart';
import 'package:stream_feed/src/core/models/user.dart';

part 'paginated_activities.g.dart';

/// Paginated activities feed
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
class PaginatedActivities<A, Ob, T, Or>
    extends Paginated<GenericEnrichedActivity<A, Ob, T, Or>> {
  /// Builds a [PaginatedActivities].
  const PaginatedActivities({
    String? next,
    List<GenericEnrichedActivity<A, Ob, T, Or>>? results,
    String? duration,
  }) : super(next, results, duration);

  /// Deserialize json to [PaginatedReactions]
  factory PaginatedActivities.fromJson(
    Map<String, dynamic> json, [
    A Function(Object? json)? fromJsonA,
    Ob Function(Object? json)? fromJsonOb,
    T Function(Object? json)? fromJsonT,
    Or Function(Object? json)? fromJsonOr,
  ]) =>
      _$PaginatedActivitiesFromJson<A, Ob, T, Or>(
        json,
        fromJsonA ??
            (jsonA) => (A == User)
                ? User.fromJson(jsonA! as Map<String, dynamic>) as A
                : jsonA as A,
        fromJsonOb ??
            (jsonOb) => (Ob == CollectionEntry)
                ? CollectionEntry.fromJson(jsonOb! as Map<String, dynamic>)
                    as Ob
                : jsonOb as Ob,
        fromJsonT ??
            (jsonT) => (T == Activity)
                ? Activity.fromJson(jsonT! as Map<String, dynamic>) as T
                : jsonT as T,
        fromJsonOr ??
            (jsonOr) {
              if (Or == User) {
                return User.fromJson(jsonOr! as Map<String, dynamic>) as Or;
              } else if (Or == Reaction) {
                return Reaction.fromJson(jsonOr! as Map<String, dynamic>) as Or;
              } else {
                return jsonOr as Or;
              }
            },
      );

  @override
  List<Object?> get props => [...super.props];

  /// Serialize to json
  Map<String, dynamic> toJson(
    Object? Function(A value) toJsonA,
    Object? Function(Ob value) toJsonOb,
    Object? Function(T value) toJsonT,
    Object? Function(Or value) toJsonOr,
  ) =>
      _$PaginatedActivitiesToJson(this, toJsonA, toJsonOb, toJsonT, toJsonOr);
}
