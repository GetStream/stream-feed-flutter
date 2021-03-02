import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';

part 'enriched_activity.g.dart';

///
class EnrichableField extends Equatable {
  ///
  const EnrichableField(this.data);

  ///
  final Object data;

  ///
  static EnrichableField deserialize(Object obj) {
    if (obj is String) {
      return EnrichableField(obj);
    }
    return EnrichableField(obj as Map<String, Object>);
  }

  static Object serialize(EnrichableField field) => field.data;

  @override
  List<Object> get props => [data];
}

///
@JsonSerializable()
class EnrichedActivity extends Equatable {
  ///
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
  factory EnrichedActivity.fromJson(Map<String, dynamic> json) =>
      _$EnrichedActivityFromJson(
          Serializer.moveKeysToRoot(json, topLevelFields));

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String id;

  ///
  @JsonKey(
    fromJson: EnrichableField.deserialize,
    toJson: EnrichableField.serialize,
  )
  final EnrichableField actor;

  ///
  final String verb;

  ///
  @JsonKey(
    fromJson: EnrichableField.deserialize,
    toJson: EnrichableField.serialize,
  )
  final EnrichableField object;

  ///
  @JsonKey(includeIfNull: false)
  final String foreignId;

  ///
  @JsonKey(
    includeIfNull: false,
    fromJson: EnrichableField.deserialize,
    toJson: Serializer.readOnly,
  )
  final EnrichableField target;

  ///
  @JsonKey(includeIfNull: false)
  final DateTime time;

  ///
  @JsonKey(
    includeIfNull: false,
    fromJson: EnrichableField.deserialize,
    toJson: Serializer.readOnly,
  )
  final EnrichableField origin;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final List<String> to;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final double score;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, Object> analytics;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, Object> extraContext;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, Object> reactionCounts;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>> ownReactions;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>> latestReactions;

  /// Map of custom user extraData
  @JsonKey(includeIfNull: false)
  final Map<String, Object> extraData;

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
  List<Object> get props => [
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
