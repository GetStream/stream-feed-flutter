import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/collection_entry.dart';
import 'package:stream_feed/src/core/models/reaction.dart';
import 'package:stream_feed/src/core/models/user.dart';
import 'package:stream_feed/src/core/util/serializer.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';

part 'enriched_activity.g.dart';

//TODO: mark this as immutable maybe?
/// Enrichment is a concept in Stream that enables our API to work quickly
/// and efficiently.
///
/// It is the concept that most data is stored as references to an original
/// data. For example, if I add an activity to my feed and it fans out to 50
/// followers, the activity is not copied 50 times, but the activity is stored
/// in a single table only once, and references are stored in 51 feeds.
///
/// The same rule applies to users and reactions. They are stored only once,
/// but references are used elsewhere.
///
/// An Enriched Activity is an Activity with additional fields
/// that are derived from the Activity's
///
/// This class makes use of generics in order to have a more flexible API
/// surface. Here is a legend of what each generic is for:
/// * A = [actor]
/// * Ob = [object]
/// * T = [target]
/// * Or = [origin]
@JsonSerializable(genericArgumentFactories: true)
@DateTimeUTCConverter()
class GenericEnrichedActivity<A, Ob, T, Or> extends Equatable {
  //TODO: improve this
  // when type parameter can have a default type in Dart
  //i.e. https://github.com/dart-lang/language/issues/283#issuecomment-839603127
  /// Builds an [GenericEnrichedActivity].
  const GenericEnrichedActivity({
    this.id,
    this.actor,
    this.verb,
    this.object,
    this.foreignId,
    this.target,
    this.time,
    this.origin,
    this.to,
    this.score,
    this.analytics,
    this.extraContext,
    this.extraData,
    this.reactionCounts,
    this.ownReactions,
    this.latestReactions,
  });

  /// Create a new instance from a JSON object
  factory GenericEnrichedActivity.fromJson(
    Map<String, dynamic>? json, [
    A Function(Object? json)? fromJsonA,
    Ob Function(Object? json)? fromJsonOb,
    T Function(Object? json)? fromJsonT,
    Or Function(Object? json)? fromJsonOr,
  ]) =>
      _$GenericEnrichedActivityFromJson<A, Ob, T, Or>(
        Serializer.moveKeysToRoot(json, topLevelFields)!,
        fromJsonA ??
            (jsonA) => (A == User)
                ? User.fromJson(jsonA! as Map<String, dynamic>) as A
                : jsonA as A,
        fromJsonOb ??
            (jsonOb) => (Ob ==
                    CollectionEntry) //TODO: can be a list of collection entry and a list of activities
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

  /// The Stream id of the activity.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? id;

  /// The actor performing the activity.
  ///
  /// The type of this field can be either a `String` or a [User].
  @JsonKey(includeIfNull: false)
  final A? actor;

  /// The verb of the activity.
  final String? verb;

  /// The object of the activity.
  ///
  /// Can be a String or a [CollectionEntry].
  @JsonKey(includeIfNull: false)
  final Ob? object;

  /// A unique ID from your application for this activity.
  ///
  /// Examples: "pin:1" or "like:300".
  @JsonKey(includeIfNull: false)
  final String? foreignId;

  /// Describes the target of the activity.
  ///
  /// The precise meaning of the activity's target is dependent on the
  /// activities verb, but will often be the object the English preposition
  /// "to".
  ///
  /// For instance, in the activity, "John saved a movie to his wishlist",
  /// the target of the activity is "wishlist". The activity target MUST NOT
  /// be used to identity an indirect object that is not a target of the
  /// activity. An activity MAY contain a target property whose value is a
  /// single Object.
  ///
  /// The type of this field can be either [Activity] or `String`.
  @JsonKey(includeIfNull: false)
  final T? target;

  /// The optional time of the activity in iso format.
  ///
  /// Defaults to the current time.
  @JsonKey(includeIfNull: false)
  final DateTime? time;

  /// The feed id where the activity was posted.
  ///
  /// Can be of type User, Reaction, or String
  @JsonKey(includeIfNull: false)
  final Or? origin;

  /// An array allows you to specify a list of feeds to which the activity
  /// should be copied.
  ///
  /// One way to think about it is as the CC functionality of email.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final List<String>? to;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final double? score;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, Object>? analytics;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, Object>? extraContext;

  /// Include reaction counts to activities.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, int>? reactionCounts;

  /// Include reactions added by current user to all activities.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>>? ownReactions;

  /// Include recent reactions to activities.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>>? latestReactions;

  /// Map of custom user extraData
  @JsonKey(includeIfNull: false)
  final Map<String, Object?>? extraData;

  GenericEnrichedActivity<A, Ob, T, Or> copyWith({
    A? actor,
    Ob? object,
    String? verb,
    T? target,
    List<String>? to,
    String? foreignId,
    String? id,
    DateTime? time,
    Map<String, Object>? analytics,
    Map<String, Object>? extraContext,
    Or? origin,
    double? score,
    Map<String, Object>? extraData,
    Map<String, int>? reactionCounts,
    Map<String, List<Reaction>>? ownReactions,
    Map<String, List<Reaction>>? latestReactions,
  }) =>
      GenericEnrichedActivity<A, Ob, T, Or>(
        actor: actor ?? this.actor,
        object: object ?? this.object,
        verb: verb ?? this.verb,
        target: target ?? this.target,
        to: to ?? this.to,
        foreignId: foreignId ?? this.foreignId,
        id: id ?? this.id,
        time: time ?? this.time,
        analytics: analytics ?? this.analytics,
        extraContext: extraContext ?? this.extraContext,
        origin: origin ?? this.origin,
        score: score ?? this.score,
        extraData: extraData ?? this.extraData,
        reactionCounts: reactionCounts ?? this.reactionCounts,
        ownReactions: ownReactions ?? this.ownReactions,
        latestReactions: latestReactions ?? this.latestReactions,
      );

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'actor',
    'verb',
    'object',
    'id',
    'foreign_id',
    'target',
    'time',
    'to',
    'analytics',
    'extra_context',
    'origin',
    'score',
    'reaction_counts',
    'own_reactions',
    'latest_reactions',
  ];

  @override
  List<Object?> get props => [
        actor,
        object,
        verb,
        target,
        to,
        foreignId,
        id,
        time,
        analytics,
        extraContext,
        origin,
        score,
        extraData,
        reactionCounts,
        ownReactions,
        latestReactions,
      ];

  /// Serialize to JSON
  Map<String, dynamic> toJson(
    Object? Function(A value) toJsonA,
    Object? Function(Ob value) toJsonOb,
    Object? Function(T value) toJsonT,
    Object? Function(Or value) toJsonOr,
  ) =>
      Serializer.moveKeysToMapInPlace(
          _$GenericEnrichedActivityToJson(
              this, toJsonA, toJsonOb, toJsonT, toJsonOr),
          topLevelFields);
}
