import 'package:stream_feed/stream_feed.dart';

/// Follow Stats Options
class FollowStatsOptions {
  /// [FollowStatsOptions] constructor
  const FollowStatsOptions(this._feedId,
      {this.followingSlugs, this.followerSlugs});
  final List<String>? followingSlugs;
  final List<String>? followerSlugs;
  final FeedId _feedId;

  /// Serialize params
  Map<String, Object?> get params => <String, Object?>{
        'followers': _feedId,
        'following': _feedId,
        if (followerSlugs != null && followerSlugs!.isNotEmpty)
          'followers_slugs': followerSlugs!.join(','),
        if (followerSlugs != null && followerSlugs!.isNotEmpty)
          'following_slugs': followingSlugs!.join(','),
      };
}
