import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/following.dart';
import 'followers.dart';
part 'follow_stats.g.dart';

@JsonSerializable()
class FollowStats extends Equatable {
  @JsonKey(toJson: _followingToJson)
  final Following following;
  @JsonKey(toJson: _followerToJson)
  final Followers followers;
  FollowStats({required this.following, required this.followers});

  /// Create a new instance from a json
  factory FollowStats.fromJson(Map<String, dynamic> json) =>
      _$FollowStatsFromJson(json);
  static String _followingToJson(Following following) =>
      following.feed.toString();
  static String _followerToJson(Followers followers) =>
      followers.feed.toString();

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowStatsToJson(this);
  @override
  List<Object?> get props => [followers, following];
}
