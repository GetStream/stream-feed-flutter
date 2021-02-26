import 'dart:convert';

import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  prepareTest();

//TODOs
// - [ ] Group
// - [x] Activity
// - [ ] ActivityUpdate
// - [ ] EnrichedActivity
// - [ ] NotificationGroup
// - [ ] CollectionEntry
// - [ ] Follow
// - [ ] Reaction
// - [ ] PaginatedReactions
// - [ ] User
// - [ ] ActivityUpdate
// - [ ] Unfollow
// - [ ] Follow
// - [ ] OpenGraphData
// - [ ] Video
// - [ ] Audio
// - [ ] Image
// - [ ] User
  test('description', () {
    // final result = Activity(
    //     actor: "test",
    //     verb: "test",
    //     object: "test",
    //     to: <FeedId>[FeedId("slug", "id")],
    //     time: DateTime.parse("2001-09-11T00:01:02.000"));
    final r = json.decode(
        '{"actor": "test", "verb": "test", "object": "test", "time": "2001-09-11T00:01:02.000", "to": ["slug:id"]}');
    final matcher = {
      "actor": "test",
      "verb": "test",
      "object": "test",
      "time": "2001-09-11T00:01:02.000",
      "to": <String>["slug:id"]
    };
    expect(r, matcher);
    final activity = Activity.fromJson(matcher);
    expect("test", activity.actor);
    expect("test", activity.verb);
    expect("test", activity.object);
    expect(DateTime.parse("2001-09-11T00:01:02.000"), activity.time);
    expect(<FeedId>[FeedId("slug", "id")], activity.to);
    // expect(result, activity);//TODO: there is something wrong with equatable or json_serializable
  });
}
