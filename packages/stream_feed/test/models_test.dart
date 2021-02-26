import 'dart:convert';
import 'dart:math';

import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
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
  test('Activity', () {
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

  test("CollectionEntry", () {
    final entry = CollectionEntry(
        id: "test",
        collection: "test",
        foreignId: "test",
        data: {"test": "test"},
        createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
        updatedAt: DateTime.parse("2001-09-11T00:01:02.000"));
    final entryJson = json.decode(
        '{"id": "test", "collection": "test", "foreign_id": "test", "data": {"test": "test"}, "created_at": "2001-09-11T00:01:02.000", "updated_at": "2001-09-11T00:01:02.000"}');
    final expectedEntryJson = {
      "id": "test",
      "collection": "test",
      "foreign_id": "test",
      "data": {"test": "test"},
      "created_at": "2001-09-11T00:01:02.000",
      "updated_at": "2001-09-11T00:01:02.000"
    };
    expect(entryJson, expectedEntryJson);
    final entryFromJson = CollectionEntry.fromJson(expectedEntryJson);
    expect("test", entryFromJson.collection);
    expect(DateTime.parse("2001-09-11T00:01:02.000"), entryFromJson.createdAt);
    expect(DateTime.parse("2001-09-11T00:01:02.000"), entryFromJson.updatedAt);
    expect({'test': 'test'}, entryFromJson.data);
    expect("test", entryFromJson.foreignId);
    expect("test", entryFromJson.id);
  });
}
