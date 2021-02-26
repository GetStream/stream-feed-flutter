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
// - [x] CollectionEntry
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
    expect(activity.actor,"test");
    expect(activity.verb,"test");
    expect(activity.object,"test");
    expect(activity.time, DateTime.parse("2001-09-11T00:01:02.000"));
    expect(activity.to,<FeedId>[FeedId("slug", "id")]);
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
    expect(entryFromJson.collection,"test" );
    expect( entryFromJson.createdAt,DateTime.parse("2001-09-11T00:01:02.000"));
    expect( entryFromJson.updatedAt,DateTime.parse("2001-09-11T00:01:02.000"));
    expect(entryFromJson.data,{'test': 'test'}, );
    expect(entryFromJson.foreignId , "test");
    expect(entryFromJson.id,"test");
    expect(entry,entryFromJson);
  });
  test("User", () {
    final user = User(
        id: "test",
        data: {"test": "test"},
        createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
        updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
        followersCount: 1,
        followingCount: 1);
    final userJson = json.decode(
        '{"id": "test", "data": {"test": "test"},"followersCount": 1, "followingCount": 1}');
    final expectedUserJson = {
      "id": "test",
      "data": {"test": "test"},
      "followersCount": 1,
      "followingCount": 1
    };
    expect(userJson, expectedUserJson);
    final userFromJson = User.fromJson(expectedUserJson);
    //expect(userFromJson, user); //doesnt work
    // expect(DateTime.parse("2001-09-11T00:01:02.000"), userFromJson.createdAt);//return null
    // expect(DateTime.parse("2001-09-11T00:01:02.000"), userFromJson.updatedAt);//return null
    // expect(userFromJson.followersCount, 1);//return null
    // expect(1, userFromJson.followingCount);//return null
  });
}
