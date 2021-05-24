import 'package:stream_feed/src/client/reactions_client.dart';
import 'package:stream_feed/src/client/personalization_client.dart';
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/src/client/image_storage_client.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/client/file_storage_client.dart';
import 'package:stream_feed/src/client/collections_client.dart';
import 'package:stream_feed/src/client/batch_operations_client.dart';
import 'package:stream_feed/src/client/aggregated_feed.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:mocktail/mocktail.dart';

class MockReactions extends Mock implements ReactionsClient {}

class MockStreamFeedClient extends Mock implements StreamFeedClient {
  @override
  AggregatedFeed aggregatedFeed(String slug, [String? userId]) {
    // TODO: implement aggregatedFeed
    throw UnimplementedError();
  }

  @override
  // TODO: implement batch
  BatchOperationsClient get batch => throw UnimplementedError();

  @override
  // TODO: implement collections
  CollectionsClient get collections => throw UnimplementedError();

  @override
  // TODO: implement currentUser
  UserClient? get currentUser => throw UnimplementedError();

  @override
  // TODO: implement files
  FileStorageClient get files => throw UnimplementedError();

  @override
  FlatFeed flatFeed(String slug, [String? userId]) {
    // TODO: implement flatFeed
    throw UnimplementedError();
  }

  @override
  Token frontendToken(String userId, {DateTime? expiresAt}) {
    // TODO: implement frontendToken
    throw UnimplementedError();
  }

  @override
  // TODO: implement images
  ImageStorageClient get images => throw UnimplementedError();

  @override
  NotificationFeed notificationFeed(String slug, [String? userId]) {
    // TODO: implement notificationFeed
    throw UnimplementedError();
  }

  @override
  Future<OpenGraphData> og(String targetUrl) {
    // TODO: implement og
    throw UnimplementedError();
  }

  @override
  // TODO: implement personalization
  PersonalizationClient get personalization => throw UnimplementedError();

  @override
  // TODO: implement reactions
  ReactionsClient get reactions => MockReactions();

  @override
  Future<User> setUser(Map<String, Object> data) {
    // TODO: implement setUser
    throw UnimplementedError();
  }

  @override
  UserClient user(String userId) {
    // TODO: implement user
    throw UnimplementedError();
  }
}
