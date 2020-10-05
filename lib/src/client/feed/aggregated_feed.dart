import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';

import 'feed.dart';

class AggregatedFeed extends Feed {
  const AggregatedFeed(String secret, FeedId id, FeedApi feed)
      : super(secret, id, feed);
}
