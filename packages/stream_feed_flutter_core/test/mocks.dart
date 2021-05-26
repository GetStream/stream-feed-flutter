import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';

class MockLogger extends Mock implements Logger {}

class MockClient extends Mock implements StreamFeedClient {
  final Logger logger = MockLogger();

  // ClientState _state;

  // @override
  // ClientState get state => _state ??= MockClientState();
}
