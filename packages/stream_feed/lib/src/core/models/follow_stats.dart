import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/followers.dart';
import 'package:stream_feed/src/core/models/following.dart';

part 'follow_stats.g.dart';

/// {@template follow_stats}
/// Following stats for a feed
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class FollowStats extends Equatable {
  /// Builds a [FollowStats].
  const FollowStats({
    required this.following,
    required this.followers,
  });

  /// Create a new instance from a JSON object
  factory FollowStats.fromJson(Map<String, dynamic> json) =>
      _$FollowStatsFromJson(json);

  final Following following;
  final Followers followers;

  /// Serialize to json
  Map<String, Object> toJson() => {
        'followers': followers.feed.toString(),
        'following': following.feed.toString(),
        if (followers.slugs?.isNotEmpty == true)
          'followers_slugs': followers.slugs!.join(','),
        if (following.slugs?.isNotEmpty == true)
          'following_slugs': following.slugs!.join(','),
      };

  @override
  List<Object?> get props => [followers, following];
}
