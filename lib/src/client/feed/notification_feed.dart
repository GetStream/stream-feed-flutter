import 'package:stream_feed_dart/src/client/feed/aggregated_feed.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';

class NotificationFeed extends AggregatedFeed {
  const NotificationFeed(String secret, FeedId id, FeedApi feed)
      : super(secret, id, feed);
}
