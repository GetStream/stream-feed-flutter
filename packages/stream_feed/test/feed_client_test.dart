import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/feed.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('Feed Client', () {
    final api = MockFeedApi();
    final feedId = FeedId('slug', 'userId');
    const secret = 'secret';
    const token = Token('dummyToken');
    const targetToken = Token('dummyToken2');
    final client = Feed(feedId, api, userToken: token);

    test('addActivity', () async {
      const activity = Activity(
        actor: 'user:1',
        verb: 'tweet',
        object: 'tweet:1',
      );
      when(() => api.addActivity(token, feedId, activity))
          .thenAnswer((_) async => activity);
      await client.addActivity(activity);
      verify(() => api.addActivity(token, feedId, activity)).called(1);
    });

    test('addActivities', () async {
      const activities = [
        Activity(
          actor: 'user:1',
          verb: 'tweet',
          object: 'tweet:1',
        )
      ];
      when(() => api.addActivities(token, feedId, activities))
          .thenAnswer((_) async => activities);
      await client.addActivities(activities);
      verify(() => api.addActivities(token, feedId, activities)).called(1);
    });
  });
}
