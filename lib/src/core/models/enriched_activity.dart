import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';

import 'activity.dart';
import 'reaction.dart';

part 'enriched_activity.g.dart';

///
@JsonSerializable()
class EnrichedActivity extends Activity {
  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, Object> reactionCounts;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>> ownReactions;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>> latestReactions;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    ...Activity.topLevelFields,
    'reaction_counts',
    'own_reactions',
    'latest_reactions',
  ];

  ///
  const EnrichedActivity(
    String id,
    String actor,
    String verb,
    String object,
    String foreignId,
    String target,
    DateTime time,
    String origin,
    List<String> to,
    double score,
    Map<String, Object> analytics,
    Map<String, Object> extraContext,
    this.reactionCounts,
    this.ownReactions,
    this.latestReactions,
  ) : super(
          actor: actor,
          verb: verb,
          object: object,
          id: id,
          foreignId: foreignId,
          target: target,
          time: time,
          to: to,
          analytics: analytics,
          extraContext: extraContext,
          origin: origin,
          score: score,
        );

  @override
  List<Object> get props => [
        ...super.props,
        reactionCounts,
        ownReactions,
        latestReactions,
      ];

  /// Create a new instance from a json
  factory EnrichedActivity.fromJson(Map<String, dynamic> json) =>
      _$EnrichedActivityFromJson(
          Serializer.moveKeysToRoot(json, topLevelFields));

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveKeysToMapInPlace(
      _$EnrichedActivityToJson(this), topLevelFields);
}
