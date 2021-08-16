import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/reaction.dart';
import 'package:stream_feed/src/core/util/serializer.dart';

part 'enriched_activity.g.dart';

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
class EnrichableField extends Equatable {
  /// Builds a  [EnrichableField].
  const EnrichableField(this.data);

  /// Underlying [EnrichableField] data
  final Object? data;

  /// Deserializes an [EnrichableField].
  static EnrichableField deserialize(Object? obj) {
    if (obj is String) {
      return EnrichableField(obj);
    }
    return EnrichableField(obj as Map<String, dynamic>?);
  }

  /// Serializes an [EnrichableField].
  static Object? serialize(EnrichableField? field) => field?.data;

  @override
  List<Object?> get props => [data];
}

/// An Enriched Activity is an Activity with additional fields
/// that are derived from the Activity's
@JsonSerializable(genericArgumentFactories: true)
class EnrichedActivity<A> extends Equatable {
  /// [EnrichedActivity] constructor
  const EnrichedActivity({
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
  factory EnrichedActivity.fromJson(
    Map<String, dynamic>? json,
    A Function(Object? json) fromJsonA,
  ) =>
      _$EnrichedActivityFromJson<A>(json!, fromJsonA);

  /// The Stream id of the activity.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? id;

  /// The actor performing the activity.
  /*@JsonKey(
    fromJson: EnrichableField.deserialize,
    toJson: EnrichableField.serialize,
  )*/
  final A? actor;

  /// The verb of the activity.
  final String? verb;

  /// object of the activity.
  @JsonKey(
    fromJson: EnrichableField.deserialize,
    toJson: EnrichableField.serialize,
  )
  final EnrichableField? object;

  /// A unique ID from your application for this activity.
  ///
  /// Examples: "pin:1" or "like:300".
  @JsonKey(includeIfNull: false)
  final String? foreignId;

  ///
  @JsonKey(
    includeIfNull: false,
    fromJson: EnrichableField.deserialize,
    toJson: Serializer.readOnly,
  )
  final EnrichableField? target;

  /// The optional time of the activity in iso format.
  ///
  /// Defaults to the current time.
  @JsonKey(includeIfNull: false)
  final DateTime? time;

  /// The feed id where the activity was posted.
  @JsonKey(
    includeIfNull: false,
    fromJson: EnrichableField.deserialize,
    toJson: Serializer.readOnly,
  )
  final EnrichableField? origin;

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
  final Map<String, Object>? extraData;

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
  Map<String, dynamic> toJson(Object? Function(A value) toJsonA) =>
      Serializer.moveKeysToMapInPlace(
          _$EnrichedActivityToJson(this, toJsonA), topLevelFields);
}
