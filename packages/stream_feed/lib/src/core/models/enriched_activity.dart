import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';

part 'enriched_activity.g.dart';

/// A field that can be Enrichabl Field
class EnrichableField extends Equatable {
  /// Constructor [EnrichableField]
  const EnrichableField(this.data);

  /// Underlying [EnrichableField] data
  final Object? data;

  /// Serialize [EnrichableField]
  static EnrichableField deserialize(Object? obj) {
    if (obj is String) {
      return EnrichableField(obj);
    }
    return EnrichableField(obj as Map<String, Object>?);
  }

  /// Serialize [EnrichableField]
  static Object? serialize(EnrichableField? field) => field?.data;

  @override
  List<Object?> get props => [data];
}

/// An enriched activity type with actor, object
/// and reaction customizable types.
@JsonSerializable()
class EnrichedActivity extends Equatable {
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

  /// Create a new instance from a json
  factory EnrichedActivity.fromJson(Map<String, dynamic>? json) =>
      _$EnrichedActivityFromJson(
          Serializer.moveKeysToRoot(json, topLevelFields)!);

  /// The Stream id of the activity.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? id;

  /// The actor performing the activity.
  @JsonKey(
    fromJson: EnrichableField.deserialize,
    toJson: EnrichableField.serialize,
  )
  final EnrichableField? actor;

  /// The verb of the activity.
  final String? verb;

  /// object of the activity.
  @JsonKey(
    fromJson: EnrichableField.deserialize,
    toJson: EnrichableField.serialize,
  )
  final EnrichableField? object;

  /// A unique ID from your application for this activity.
  /// IE: pin:1 or like:300.
  @JsonKey(includeIfNull: false)
  final String? foreignId;

  ///
  @JsonKey(
    includeIfNull: false,
    fromJson: EnrichableField.deserialize,
    toJson: Serializer.readOnly,
  )
  final EnrichableField? target;

  /// The optional time of the activity, isoformat. Default is the current time.
  @JsonKey(includeIfNull: false)
  final DateTime? time;

  /// The feed id where the activity was posted.
  @JsonKey(
    includeIfNull: false,
    fromJson: EnrichableField.deserialize,
    toJson: Serializer.readOnly,
  )
  final EnrichableField? origin;

  /// An array allows you to specify
  /// a list of feeds to which the activity should be copied.
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
  final Map<String, Object>? reactionCounts;

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

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveKeysToMapInPlace(
      _$EnrichedActivityToJson(this), topLevelFields);
}
