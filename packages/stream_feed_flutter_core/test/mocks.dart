import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class MockLogger extends Mock implements Logger {}

class MockStreamFeedClient extends Mock implements StreamFeedClient {}

class MockReactions extends Mock implements ReactionsClient {}

class MockFiles extends Mock implements FileStorageClient {}

class MockImages extends Mock implements ImageStorageClient {}

class MockCancelToken extends Mock implements CancelToken {}

class MockStreamAnalytics extends Mock implements StreamAnalytics {}

class MockFlatFeed extends Mock implements FlatFeed {}

class MockAggregatedFeed extends Mock implements AggregatedFeed {}

class MockReactionsManager extends Mock implements ReactionsManager {}

class MockActivitiesManager extends Mock implements ActivitiesManager {}

class MockGroupedActivitiesManager extends Mock
    implements GroupedActivitiesManager {}

class MockClient extends Mock implements StreamFeedClient {
  final Logger logger = MockLogger();
}

class MockStreamUser extends Mock implements StreamUser {}

class MockUploadController extends Mock implements UploadController {}
