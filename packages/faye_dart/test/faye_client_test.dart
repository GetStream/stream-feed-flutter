import 'package:faye_dart/src/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class Functions {
  WebSocketChannel? connectFunc(
    String url, {
    Iterable<String>? protocols,
    Duration? connectionTimeout,
  }) =>
      null;

  // void handleFunc(formatt event) => null;
}

class MockFunctions extends Mock implements Functions {}

class MockWSChannel extends Mock implements WebSocketChannel {}

class MockWSSink extends Mock implements WebSocketSink {}

main() {
  test('FayeClient', () {
    final computedUrl = 'wss://faye-us-east.stream-io-api.com/faye';
    final ConnectWebSocket connectFunc = MockFunctions().connectFunc;
    final faye = FayeClient(computedUrl);
    final StreamController<String> streamController =
        StreamController<String>.broadcast();
    final mockWSChannel = MockWSChannel();

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.sink).thenAnswer((_) => MockWSSink());
    when(() => mockWSChannel.stream).thenAnswer((_) {
      return streamController.stream;
    });

    faye.connect().then((_) {
      streamController.sink.add('{}');
      return Future.delayed(Duration(milliseconds: 200));
    }).then((value) {
      verify(() => connectFunc(computedUrl)).called(1);
      // verify(() => handleFunc(any)).called(greaterThan(0));

      return streamController.close();
    });
  });
}
