import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stream_feed/src/core/models/feed_id.dart';

import 'package:stream_feed/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed/stream_feed.dart';

part 'realtime_message.g.dart';

/// A realtime message for changes to one or many feeds.
///
/// Each time a new activity is added or removed, an update will be received
/// directly.
///
/// Note that new activities coming from subscription will only contain
/// enrichment for these fields:
///   - Activity SA
///   - Reaction SR
///   - Object SO
///   - User SU
///
/// The only thing you don’t get is the enriched reactions like `own_reaction`
/// or `latest_reactions`
@JsonSerializable()
class RealtimeMessage extends Equatable {
  /// Builds a [RealtimeMessage].
  const RealtimeMessage({
    required this.feed,
    this.deleted = const <String>[],
    this.deletedForeignIds = const <ForeignIdTimePair>[],
    this.newActivities = const <EnrichedActivity>[],
    this.appId,
    this.publishedAt,
  });

  /// Create a new instance from a JSON object
  factory RealtimeMessage.fromJson(Map<String, dynamic> json) =>
      _$RealtimeMessageFromJson(json);

  /// Name of the feed this update was published on
  @JsonKey(toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? feed;

  /// AppId to which this app is connected to
  @JsonKey(includeIfNull: false)
  final String? appId;

  /// All activities deleted by this update
  final List<String> deleted;

  /// A pair of foreign_id and time of the deleted activities
  @JsonKey(
    toJson: ForeignIdTimePair.toList,
    fromJson: ForeignIdTimePair.fromList,
  )
  final List<ForeignIdTimePair> deletedForeignIds;

  /// All activities created by this update
  /// Do note that new activities coming from subscription
  /// will only contain enrichment for these fields:
  ///
  /// 1. Activity `SA`
  /// 2. Reaction `SR`
  /// 3. Object `SO`
  /// 4. User `SU`
  ///
  /// the only thing you don’t get is the enriched reactions like `own_reaction`
  /// or `latest_reactions`
  @JsonKey(name: 'new')
  final List<EnrichedActivity> newActivities;

  /// Time of the update in ISO format
  @JsonKey(includeIfNull: false)
  final DateTime? publishedAt;

  @override
  List<Object?> get props => [
        feed,
        appId,
        deleted,
        deletedForeignIds,
        newActivities,
        publishedAt,
      ];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RealtimeMessageToJson(this);
}
