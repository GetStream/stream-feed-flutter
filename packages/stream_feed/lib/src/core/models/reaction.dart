import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/user.dart';
import 'package:stream_feed/src/core/util/serializer.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';
import 'package:stream_feed/stream_feed.dart';

part 'reaction.g.dart';

/// Reactions are a special kind of data that can be used to capture user
/// interaction with specific activities.
///
/// Common examples of reactions are likes, comments, and upvotes.
///
/// Reactions are automatically returned to feeds' activities at read time
/// when the reactions parameters are used.
@JsonSerializable()
@DateTimeUTCConverter()
class Reaction extends Equatable {
  /// Builds a [Reaction].
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
    this.ownChildren,
    this.childrenCounts,
  });

  /// Create a new instance from a JSON object
  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  /// Reaction ID
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? id;

  /// The type of reaction (eg. like, comment, ...).
  ///
  /// Must not be empty or longer than 255 characters.
  final String? kind;

  /// The ID of the activity the reaction refers to.
  ///
  /// Must be a valid activity ID.
  final String? activityId;

  ///	`user_id` of the reaction.
  ///
  /// Must not be empty or longer than 255 characters.
  final String? userId;

  /// ID of the parent reaction.
  ///
  /// If provided, it must be the ID of a reaction that has no parents.
  @JsonKey(includeIfNull: false)
  final String? parent;

  /// When the reaction was created.
  @JsonKey(includeIfNull: false)
  final DateTime? createdAt;

  ///	When the reaction was last updated.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? updatedAt;

  /// The feeds that should receive a notification activity
  ///
  /// List of feed ids (e.g.: timeline:bob)
  @JsonKey(includeIfNull: false, fromJson: FeedId.fromIds, toJson: FeedId.toIds)
  final List<FeedId>? targetFeeds;

  /// User of the reaction
  @JsonKey(includeIfNull: false)
  final User? user;

  /// Additional data to attach to the notification activities
  @JsonKey(includeIfNull: false)
  final Map<String, Object>? targetFeedsExtraData;

  /// Additional data to attach to the reaction
  @JsonKey(includeIfNull: false)
  final Map<String, Object>? data;

  /// Children reactions, grouped by reaction type.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>>? latestChildren;

  /// Children reactions, grouped by reaction type.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, List<Reaction>>? ownChildren;

  /// Child reaction count, grouped by reaction kind
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, int>? childrenCounts;

  /// Known top level fields.
  ///
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

  /// Copies this [Reaction] to a new instance.
  Reaction copyWith(
          {String? id,
          String? kind,
          String? activityId,
          String? userId,
          String? parent,
          DateTime? createdAt,
          DateTime? updatedAt,
          List<FeedId>? targetFeeds,
          User? user,
          Map<String, Object>? targetFeedsExtraData,
          Map<String, Object>? data,
          Map<String, List<Reaction>>? latestChildren,
          Map<String, int>? childrenCounts,
          Map<String, List<Reaction>>? ownChildren}) =>
      Reaction(
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
        ownChildren: ownChildren ?? this.ownChildren,
      );

  @override
  List<Object?> get props => [
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
        ownChildren
      ];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
