import 'dart:io';

import 'package:stream_feed/src/client/stream_feed_client.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/realtime_message.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

void main() async {
  test('FayeClient', () async {
    final env = Platform.environment;
    final secret = env['secret'];
    final appId = env['appId'];
    final apiKey = env['apiKey'];

    final client = StreamFeedClient.connect(
      apiKey!,
      secret: secret,
      appId: appId,
      runner: Runner.server,
    );

    const userId = '1';
    const slug = 'reward';
    final userFeed = client.flatFeed(slug, userId);

    RealtimeMessage? realTimeMessage;
    final subscription =
        await userFeed.subscribe((message) => realTimeMessage = message);

    var activity = Activity(
      actor: '$slug:$userId',
      verb: 'tweet',
      object: 'tweet:id',
      to: <FeedId>[FeedId.id('notification:jessica')],
      extraData: const {
        'message': "@Jessica check out getstream.io it's so dang awesome.",
      },
    );
    activity = await userFeed.addActivity(activity);

    await Future.delayed(const Duration(seconds: 3));

    expect(realTimeMessage, isNotNull);
    expect(realTimeMessage!.newActivities.first.id,
        activity.id); //TODO: this test is flaky

    addTearDown(subscription.cancel);
  });
}
