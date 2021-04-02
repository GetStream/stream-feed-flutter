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

// class FayeAuth extends AuthExtension {
// @override
// Map<String, Object>? getAuth() => {
//       "user_id": 'site-110925-feed-reward1',
//       "api_key": "ay57s8swfnan",
//       "signature":
//           "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.9Xeyd2J2HadWi-FCwCDGGX2x62Ospe24zJcX-AJ6eHw",
//     };

// }

main() {
  test('FayeClient', () async {
    const apiKey = 'ay57s8swfnan';
    const appId = '110925';

    final client = StreamClient.connect(apiKey,
        secret:
            'ajencvb6gfrbzvt2975kk3563j3vg86fhrswjsbk32zzgjcgtfn3293er4tk9bf4',
        appId: appId);
    const userId = '1';
    const slug = 'reward';
    final userFeed = client.flatFeed(slug, userId);

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
    userFeed.subscribe(callback: logs.add);

    expect(logs, []);
  });
}
