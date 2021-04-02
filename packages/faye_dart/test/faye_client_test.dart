import 'package:faye_dart/src/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Functions {
  WebSocketChannel? connectFunc(
    String url, {
    Iterable<String>? protocols,
    Duration? connectionTimeout,
  }) =>
      null;

  // void handleFunc(Event event) => null;
}

class MockFunctions extends Mock implements Functions {}

class MockWSChannel extends Mock implements WebSocketChannel {}

class MockWSSink extends Mock implements WebSocketSink {}

main() {
  test('FayeClient', () async {
    final computedUrl = 'wss://faye-us-east.stream-io-api.com/faye';
    final faye = FayeClient(computedUrl);
    // final logs = [];
    await expectLater(
        faye.stateStream, emitsInOrder([FayeClientState.unconnected]));

    await faye.connect();
    await expectLater(
        faye.stateStream, emitsInOrder([FayeClientState.connected]));

  });
}
