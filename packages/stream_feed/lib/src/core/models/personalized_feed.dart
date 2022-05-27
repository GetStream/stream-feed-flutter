import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/paginated.dart';
import 'package:stream_feed/stream_feed.dart';

part 'personalized_feed.g.dart';

/// A personalized feed for a single user.
///
/// In other words, a feed of based on user's activities.
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
class PersonalizedFeed<A, Ob, T, Or>
    extends Paginated<GenericEnrichedActivity<A, Ob, T, Or>> {
  /// Builds a [PaginatedReactions].
  const PersonalizedFeed({
    required this.version,
    required this.offset,
    required this.limit,
    String? next,
    List<GenericEnrichedActivity<A, Ob, T, Or>>? results,
    String? duration,
  }) : super(next, results, duration);

  /// Deserialize json to [PaginatedReactions]
  factory PersonalizedFeed.fromJson(
    Map<String, dynamic> json, [
    A Function(Object? json)? fromJsonA,
    Ob Function(Object? json)? fromJsonOb,
    T Function(Object? json)? fromJsonT,
    Or Function(Object? json)? fromJsonOr,
  ]) =>
      _$PersonalizedFeedFromJson<A, Ob, T, Or>(
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
  List<Object?> get props => [...super.props, version, offset, limit];

  final String version;

  /// The offset of the first result in the current page.
  final int offset;

  /// The maximum number of results to return.
  final int limit;

  /// Serialize to json
  Map<String, dynamic> toJson(
    Object? Function(A value) toJsonA,
    Object? Function(Ob value) toJsonOb,
    Object? Function(T value) toJsonT,
    Object? Function(Or value) toJsonOr,
  ) =>
      _$PersonalizedFeedToJson(this, toJsonA, toJsonOb, toJsonT, toJsonOr);
}
