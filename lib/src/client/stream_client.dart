//public interface IStreamClient
//     {
//         IBatchOperations Batch { get; }
//         Collections Collections { get; }
//         Reactions Reactions { get; }
//         Users Users { get; }
//
//         Task ActivityPartialUpdate(string id = null, ForeignIDTime foreignIDTime = null, GenericData set = null, IEnumerable<string> unset = null);
//         IStreamFeed Feed(string feedSlug, string userId);
//
//         string CreateUserSessionToken(string userId, IDictionary<string, object> extraData = null);

import 'package:stream_feed_dart/src/client/batch_operations_client.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/client/users_client.dart';

import 'feed/index.dart';

abstract class StreamClient {

  BatchOperationsClient get batch;

  CollectionsClient get collections;

  ReactionsClient get reactions;

  UsersClient get users;

  FlatFeet flatFeed(String slug, String userId);

  AggregatedFeed aggregatedFeed(String slug, String userId);

  NotificationFeed notificationFeed(String slug, String userId);
}
