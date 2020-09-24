import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/models/feed_id.dart';
import 'package:stream_feed_dart/src/models/reaction.dart';

class ReactionsClientImpl implements ReactionsClient {
  @override
  Future<Reaction> add(String userId, String kind, String activity,
      {Map<String, Object> data, Iterable<FeedId> targetFeeds}) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Reaction> addChild(Reaction parent, String kind, String userId,
      {Map<String, Object> data, Iterable<String> targetFeeds}) {
    // TODO: implement addChild
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Reaction> get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> update(String id,
      {Map<String, Object> data, Iterable<String> targetFeeds}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
