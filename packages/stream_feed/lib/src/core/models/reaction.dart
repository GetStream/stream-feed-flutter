import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';

import 'package:stream_feed_dart/src/core/models/feed_id.dart';

part 'reaction.g.dart';

///
@JsonSerializable()
class Reaction extends Equatable {
  ///
  const Reaction({
    this.id,
    this.kind,
    this.activityId,
    this.userId,
    this.parent,
    this.createdAt,
    this.updatedAt,
    this.targetFeeds,
    this.user,
    this.targetFeedsExtraData,
    this.data,
    this.latestChildren,
    this.childrenCounts,
  });

  /// Create a new instance from a json
  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String id;

  ///
  final String kind;

  ///
  final String activityId;

  ///
  final String userId;

  ///
  @JsonKey(includeIfNull: false)
  final String parent;

  ///
  @JsonKey(includeIfNull: false)
  final DateTime createdAt;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime updatedAt;

  ///
  @JsonKey(includeIfNull: false, fromJson: FeedId.fromIds, toJson: FeedId.toIds)
  final List<FeedId> targetFeeds;

  ///
  @JsonKey(includeIfNull: false)
  final Map<String, Object> user;

  ///
  @JsonKey(includeIfNull: false)
  final Map<String, Object> targetFeedsExtraData;

  ///
  @JsonKey(includeIfNull: false)
  final Map<String, Object> data;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>> latestChildren;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, int> childrenCounts;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'kind',
    'activity_id',
    'user_id',
    'user',
    'data',
    'created_at',
    'updated_at',
    'parent',
    'latest_children',
    'children_counts',
  ];

  ///
  Reaction copyWith({
    String id,
    String kind,
    String activityId,
    String userId,
    String parent,
    DateTime createdAt,
    DateTime updatedAt,
    List<FeedId> targetFeeds,
    Map<String, Object> user,
    Map<String, Object> targetFeedsExtraData,
    Map<String, Object> data,
    Map<String, List<Reaction>> latestChildren,
    Map<String, int> childrenCounts,
  }) {
    return Reaction(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      activityId: activityId ?? this.activityId,
      userId: userId ?? this.userId,
      parent: parent ?? this.parent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      targetFeeds: targetFeeds ?? this.targetFeeds,
      user: user ?? this.user,
      targetFeedsExtraData: targetFeedsExtraData ?? this.targetFeedsExtraData,
      data: data ?? this.data,
      latestChildren: latestChildren ?? this.latestChildren,
      childrenCounts: childrenCounts ?? this.childrenCounts,
    );
  }

  @override
  List<Object> get props => [
        id,
        kind,
        activityId,
        userId,
        parent,
        createdAt,
        updatedAt,
        targetFeeds,
        user,
        targetFeedsExtraData,
        data,
        latestChildren,
        childrenCounts,
      ];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
