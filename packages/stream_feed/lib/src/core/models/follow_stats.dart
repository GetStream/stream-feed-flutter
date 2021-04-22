import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/followers.dart';
import 'package:stream_feed/src/core/models/following.dart';

part 'follow_stats.g.dart';

@JsonSerializable()
class FollowStats extends Equatable {
  final Following following;
  final Followers followers;
  FollowStats({required this.following, required this.followers});

  /// Create a new instance from a json
  factory FollowStats.fromJson(Map<String, dynamic> json) =>
      _$FollowStatsFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => {
        'followers': followers.feed.toString(),
        'following': following.feed.toString(),
        if (followers.slugs != null && followers.slugs!.isNotEmpty)
          'followers_slugs': followers.slugs!.join(','),
        if (following.slugs != null && following.slugs!.isNotEmpty)
          'following_slugs': following.slugs!.join(','),
      };
  @override
  List<Object?> get props => [followers, following];
}
