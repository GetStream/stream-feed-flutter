import 'package:faye_dart/src/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/stream_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/stream_feed.dart';
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
    const apiKey = 'ay57s8swfnan';
    const appId = '110925';

    final client = StreamClient.connect(apiKey,
        secret:
            "ajencvb6gfrbzvt2975kk3563j3vg86fhrswjsbk32zzgjcgtfn3293er4tk9bf4",
        appId: appId);
    const userId = '1';
    final slug = "reward";
    final userFeed = client.flatFeed('$slug', userId);

    // expect(client.frontendToken(userId), "matcher");

    final activity = Activity(
      actor: '$slug:$userId',
      verb: 'tweet',
      object: 'tweet:id',
      to: <FeedId>[FeedId.id('notification:jessica')],
      extraData: const {
        'message': "@Jessica check out getstream.io it's so dang awesome.",
      },
    );
    await userFeed.addActivity(activity);

    final logs = [];
    await expectLater(
        faye.stateStream, emitsInOrder([FayeClientState.unconnected]));

    await faye.connect();
    await expectLater(
        faye.stateStream, emitsInOrder([FayeClientState.connected]));
    final notificationChannel = userFeed.notificationChannel;
    await faye.subscribe('/$notificationChannel', callback: logs.add);

    expect(logs, []);
  });
}
