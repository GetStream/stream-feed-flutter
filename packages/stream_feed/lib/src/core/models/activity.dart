import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';

import 'package:stream_feed_dart/src/core/models/feed_id.dart';

part 'activity.g.dart';

///
@JsonSerializable()
class Activity extends Equatable {
  ///
  const Activity({
    @required this.actor,
    @required this.verb,
    @required this.object,
    this.id,
    this.foreignId,
    this.target,
    this.time,
    this.to,
    this.analytics,
    this.extraContext,
    this.origin,
    this.score,
    this.extraData,
  });

  /// Create a new instance from a json
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(Serializer.moveKeysToRoot(json, topLevelFields));

  ///
  @JsonKey(includeIfNull: false)
  final String id;

  ///
  final String actor;

  ///
  final String verb;

  ///
  final String object;

  ///
  @JsonKey(includeIfNull: false)
  final String foreignId;

  ///
  @JsonKey(includeIfNull: false)
  final String target;

  ///
  @JsonKey(includeIfNull: false)
  final DateTime time;

  ///
  @JsonKey(includeIfNull: false)
  final String origin;

  ///
  @JsonKey(
    includeIfNull: false,
    fromJson: FeedId.fromIds,
    toJson: FeedId.toIds,
  )
  final List<FeedId> to;

  ///
  @JsonKey(includeIfNull: false)
  final double score;

  ///
  @JsonKey(includeIfNull: false)
  final Map<String, Object> analytics;

  ///
  @JsonKey(includeIfNull: false)
  final Map<String, Object> extraContext;

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
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serializer.moveKeysToMapInPlace(_$ActivityToJson(this), topLevelFields);

  ///
  Activity copyWith({
    String id,
    String actor,
    String verb,
    String object,
    String foreignId,
    String target,
    DateTime time,
    String origin,
    List<FeedId> to,
    double score,
    Map<String, Object> analytics,
    Map<String, Object> extraContext,
    Map<String, Object> extraData,
  }) {
    return Activity(
      id: id ?? this.id,
      actor: actor ?? this.actor,
      verb: verb ?? this.verb,
      object: object ?? this.object,
      foreignId: foreignId ?? this.foreignId,
      target: target ?? this.target,
      time: time ?? this.time,
      origin: origin ?? this.origin,
      to: to ?? this.to,
      score: score ?? this.score,
      analytics: analytics ?? this.analytics,
      extraContext: extraContext ?? this.extraContext,
      extraData: extraData ?? this.extraData,
    );
  }

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
      ];
}
