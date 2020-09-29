import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';

part 'activity.g.dart';

///
@JsonSerializable()
class Activity extends Equatable {
  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
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
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String target;

  ///
  @JsonKey(includeIfNull: false)
  final DateTime time;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String origin;

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

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serializer.moveKeysToMapInPlace(_$ActivityToJson(this), topLevelFields);

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
