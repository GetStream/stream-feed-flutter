import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/enrichment_flags.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

import 'feed.dart';

class FlatFeet extends Feed {
  const FlatFeet(String secret, FeedId id, FeedApi feed)
      : super(secret, id, feed);

  Future<List<Activity>> getActivities(
      int limit, int offset, Filter filter, String ranking) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
    return feed.getActivities(token, feedId, limit, offset, filter, ranking);
  }

  Future<List<EnrichedActivity>> getEnrichedActivities(int limit, int offset,
      Filter filter, EnrichmentFlags flags, String ranking) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
    return feed.getEnrichedActivities(
        token, feedId, limit, offset, filter, flags, ranking);
  }

  //CompletableFuture<? extends List<? extends Group<EnrichedActivity>>> getEnrichedActivities(
//       Limit limit, Offset offset, Filter filter, ActivityMarker marker, EnrichmentFlags flags)
//       throws StreamException {
//     return getClient()
//         .getEnrichedActivities(getID(), limit, offset, filter, marker, flags)
//         .thenApply(
//             response -> {
//               try {
//                 return deserializeContainer(response, Group.class, EnrichedActivity.class);
//               } catch (StreamException | IOException e) {
//                 throw new CompletionException(e);
//               }
//             });
//   }
}
