import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:test/test.dart';

import 'mock.dart';

main() {
  group('ReactionsClient', () {
    final api = MockReactionsApi();

    const secret = 'secret';
    const token = Token('dummyToken');
    final client = ReactionsClient(api, userToken: token);
    test('add', () async {
      const kind = 'like';
      const activityId = 'activityId';
      const userId = 'john-doe';
      // const reaction = Reaction(kind: kind);
      const targetFeeds = <FeedId>[];
      const data = {'text': 'awesome post!'};
      const reaction = Reaction(
        kind: kind,
        activityId: activityId,
        userId: userId,
        data: data,
        targetFeeds: targetFeeds,
      );
      when(() => api.add(token, reaction)).thenAnswer((_) async => reaction);

      expect(
          await client.add(kind, activityId, userId,
              data: data, targetFeeds: targetFeeds),
          reaction);
      verify(() => api.add(token, reaction)).called(1);
    });
  });
}
