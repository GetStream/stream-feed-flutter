import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

class MockLogger extends Mock implements Logger {}

class MockStreamFeedClient extends Mock implements StreamFeedClient {}

class MockReactions extends Mock implements ReactionsClient {}

class MockStreamAnalytics extends Mock implements StreamAnalytics {}

class MockFeedAPI extends Mock implements FlatFeed {}

class MockReactionControllers extends Mock
    implements Map<String, BehaviorSubject<List<Reaction>>> {}

class MockClient extends Mock implements StreamFeedClient {
  final Logger logger = MockLogger();

  // ClientState _state;

  // @override
  // ClientState get state => _state ??= MockClientState();
}
