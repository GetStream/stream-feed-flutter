import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';

import 'package:stream_feed/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed/stream_feed.dart';

part 'realtime_message.g.dart';

///
@JsonSerializable()
class RealtimeMessage extends Equatable {
  /// Instantiates a new realtime message object
  const RealtimeMessage({
    required this.feed,
    this.deleted = const <String>[],
    this.deletedForeignIds = const <ForeignIdTimePair>[],
    this.newActivities = const <EnrichedActivity>[],
    this.appId,
    this.publishedAt,
    this.unread,
    this.unseen,
  });

  /// Create a new instance from a json
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
  @JsonKey(name: 'new')
  final List<EnrichedActivity> newActivities;

  /// Time of the update in ISO format
  @JsonKey(includeIfNull: false)
  final DateTime? publishedAt;

  // Notification Feed only
  final int? unread;
  final int? unseen;

  @override
  List<Object?> get props => [
        feed,
        appId,
        deleted,
        deletedForeignIds,
        newActivities,
        publishedAt,
        unread,
        unseen
      ];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$RealtimeMessageToJson(this);
}
