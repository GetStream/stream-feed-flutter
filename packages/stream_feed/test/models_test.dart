import 'dart:convert';

import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  prepareTest();

//TODOs: setup model tests for the following models
// - [ ] Group
// - [x] Activity
// - [x] ActivityUpdate
// - [x] EnrichedActivity
// - [x] NotificationGroup
// - [x] CollectionEntry
// - [x] Follow
// - [x] Reaction
// - [x] PaginatedReactions
// - [x] User
// - [x] ActivityUpdate
// - [x] Unfollow
// - [x] OpenGraphData
// - [x] Video
// - [x] Audio
// - [x] Image
// - [x] User

  test("ActivityUpdate", () {
    final activityUpdate = ActivityUpdate(
      id: "test",
      foreignId: "test",
      time: DateTime.parse("2001-09-11T00:01:02.000"),
      set: {"test": "test"},
      unset: ["test"],
    );
    final activityUpdateJson = json.decode(
        '{"id": "test", "foreign_id": "test", "time": "2001-09-11T00:01:02.000", "set": {"test": "test"}, "unset": ["test"]}');
    final activityUpdateFromJson = ActivityUpdate.fromJson(activityUpdateJson);
    expect(activityUpdateFromJson, activityUpdate);
  });
  test("EnrichedActivity", () {
    final reaction1 = Reaction(
        id: "test",
        kind: "test",
        activityId: "test",
        userId: "test",
        parent: "test",
        createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
        updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
        targetFeeds: [FeedId("slug", "userId")],
        user: {"test": "test"},
        targetFeedsExtraData: {"test": "test"},
        data: {"test": "test"},
        // latestChildren: {
        //   "test": [reaction2]
        // },
        childrenCounts: {"test": 1});
    final enrichedActivity = EnrichedActivity(
      id: "test",
      actor: EnrichableField("test"),
      object: EnrichableField("test"),
      verb: "test",
      target: EnrichableField("test"),
      to: ["test"],
      foreignId: "test",
      time: DateTime.parse("2001-09-11T00:01:02.000"),
      analytics: {"test": "test"},
      extraContext: {"test": "test"},
      origin: EnrichableField("test"),
      score: 1.0,
      extraData: {"test": "test"},
      reactionCounts: {"test": 1},
      ownReactions: {
        "test": [reaction1]
      },
      latestReactions: {
        "test": [reaction1]
      },
    );
    final enrichedActivityJson = json.decode(
        '{"id":"test", "actor": "test","object": "test", "verb": "test","target": "test", "to":["test"], "foreign_id": "test", "time": "2001-09-11T00:01:02.000","analytics": {"test": "test"},"extra_context": {"test": "test"},"origin":"test","score":1.0,"reaction_counts": {"test": 1},"own_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]},"latest_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]}, "extra_data": {"test": "test"}}');
    final enrichedActivityFromJson =
        EnrichedActivity.fromJson(enrichedActivityJson);
    expect(enrichedActivityFromJson.id, "test");
    expect(enrichedActivityFromJson.actor, EnrichableField("test"));
    expect(enrichedActivityFromJson.object, EnrichableField("test"));
    expect(enrichedActivityFromJson.verb, "test");
    expect(enrichedActivityFromJson.target, EnrichableField("test"));
    expect(enrichedActivityFromJson.to, ["test"]);
    expect(enrichedActivityFromJson.foreignId, "test");
    expect(enrichedActivityFromJson.time,
        DateTime.parse("2001-09-11T00:01:02.000"));
    expect(enrichedActivityFromJson.analytics, {"test": "test"});
    expect(enrichedActivityFromJson.extraContext, {"test": "test"});
    expect(enrichedActivityFromJson.origin, EnrichableField("test"));
    expect(enrichedActivityFromJson.score, 1.0);
    expect(enrichedActivityFromJson.extraData, {"test": "test"});
    expect(enrichedActivityFromJson.reactionCounts, {"test": 1});

    expect(enrichedActivityFromJson.latestReactions, {
      "test": [
        Reaction(
            id: "test",
            kind: "test",
            activityId: "test",
            userId: "test",
            parent: "test",
            createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
            updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
            targetFeeds: [FeedId("slug", "userId")],
            user: {"test": "test"},
            targetFeedsExtraData: {"test": "test"},
            data: {"test": "test"},
            // latestChildren: {
            //   "test": [reaction2]
            // }
            childrenCounts: {"test": 1})
      ]
    });
    expect(enrichedActivityFromJson.ownReactions, {
      "test": [
        Reaction(
            id: "test",
            kind: "test",
            activityId: "test",
            userId: "test",
            parent: "test",
            createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
            updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
            targetFeeds: [FeedId("slug", "userId")],
            user: {"test": "test"},
            targetFeedsExtraData: {"test": "test"},
            data: {"test": "test"},
            // latestChildren: {
            //   "test": [reaction2]
            // },//TODO: test this
            childrenCounts: {"test": 1})
      ]
    });
    expect(enrichedActivityFromJson, enrichedActivity);
  });
  test('Activity', () {
    final activity = Activity(
        target: "test",
        foreignId: "test",
        id: "test",
        analytics: {"test": "test"},
        extraContext: {"test": "test"},
        origin: "test",
        score: 1.0,
        extraData: {"test": "test"},
        actor: "test",
        verb: "test",
        object: "test",
        to: <FeedId>[FeedId("slug", "id")],
        time: DateTime.parse("2001-09-11T00:01:02.000"));
    final r = json.decode(
        '{"id": "test", "actor": "test", "verb": "test", "object": "test", "foreign_id": "test", "target": "test", "time": "2001-09-11T00:01:02.000", "origin": "test", "to": ["slug:id"], "score": 1.0, "analytics": {"test": "test"}, "extra_context": {"test": "test"}, "test": "test"}');

    final activityJson = Activity.fromJson(r);
    expect(activityJson.actor, "test");
    expect(activityJson.verb, "test");
    expect(activityJson.object, "test");
    expect(activityJson.time, DateTime.parse("2001-09-11T00:01:02.000"));
    expect(activityJson.to, <FeedId>[FeedId("slug", "id")]);
    expect(activityJson, activity);
  });

  test("Group", () {
    final group = Group(
      id: "test",
      group: "test",
      activities: [
        Activity(
            target: "test",
            foreignId: "test",
            id: "test",
            analytics: {"test": "test"},
            extraContext: {"test": "test"},
            origin: "test",
            score: 1.0,
            extraData: {"test": "test"},
            actor: "test",
            verb: "test",
            object: "test",
            to: <FeedId>[FeedId("slug", "id")],
            time: DateTime.parse("2001-09-11T00:01:02.000"))
      ],
      actorCount: 1,
      createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
      updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
    );
    final groupJson = json.decode(
        '{"id": "test", "group": "test", "activities": [{"id": "test", "actor": "test", "verb": "test", "object": "test", "foreign_id": "test", "target": "test", "time": "2001-09-11T00:01:02.000", "origin": "test", "to": ["slug:id"], "score": 1.0, "analytics": {"test": "test"}, "extra_context": {"test": "test"}, "test": "test"}], "actor_count": 1, "created_at": "2001-09-11T00:01:02.000", "updated_at": "2001-09-11T00:01:02.000"}');

    // expect(groupJson, matcher)
    final groupFromJson =
        Group.fromJson(groupJson, (e) => Activity.fromJson(e));
    expect(groupFromJson, group);
  });

  test("NotificationGroup", () {
    final notificationGroup = NotificationGroup(
      id: "test",
      group: "test",
      activities: [
        Activity(
            target: "test",
            foreignId: "test",
            id: "test",
            analytics: {"test": "test"},
            extraContext: {"test": "test"},
            origin: "test",
            score: 1.0,
            extraData: {"test": "test"},
            actor: "test",
            verb: "test",
            object: "test",
            to: <FeedId>[FeedId("slug", "id")],
            time: DateTime.parse("2001-09-11T00:01:02.000"))
      ],
      actorCount: 1,
      createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
      updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
      isRead: true,
      isSeen: true,
    );
    final notificationGroupJson = json.decode(
        '{"id": "test", "group": "test", "activities": [{"id": "test", "actor": "test", "verb": "test", "object": "test", "foreign_id": "test", "target": "test", "time": "2001-09-11T00:01:02.000", "origin": "test", "to": ["slug:id"], "score": 1.0, "analytics": {"test": "test"}, "extra_context": {"test": "test"}, "test": "test"}], "actor_count": 1, "created_at": "2001-09-11T00:01:02.000", "updated_at": "2001-09-11T00:01:02.000","is_read":true,"is_seen":true}');

    final notificationGroupFromJson = NotificationGroup.fromJson(
        notificationGroupJson, (e) => Activity.fromJson(e));
    expect(notificationGroupFromJson, notificationGroup);
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

    final entryFromJson = CollectionEntry.fromJson(entryJson);
    expect(entry, entryFromJson);
  });

  test("PaginatedReactions", () {
    final reaction1 = Reaction(
        id: "test",
        kind: "test",
        activityId: "test",
        userId: "test",
        parent: "test",
        createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
        updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
        targetFeeds: [FeedId("slug", "userId")],
        user: {"test": "test"},
        targetFeedsExtraData: {"test": "test"},
        data: {"test": "test"},
        // latestChildren: {
        //   "test": [reaction2]
        // },//TODO: test this
        childrenCounts: {"test": 1});
    final enrichedActivity = EnrichedActivity(
      id: "test",
      actor: EnrichableField("test"),
      object: EnrichableField("test"),
      verb: "test",
      target: EnrichableField("test"),
      to: ["test"],
      foreignId: "test",
      time: DateTime.parse("2001-09-11T00:01:02.000"),
      analytics: {"test": "test"},
      extraContext: {"test": "test"},
      origin: EnrichableField("test"),
      score: 1.0,
      extraData: {"test": "test"},
      reactionCounts: {"test": 1},
      ownReactions: {
        "test": [reaction1]
      },
      latestReactions: {
        "test": [reaction1]
      },
    );
    final reaction = Reaction(
        id: "test",
        kind: "test",
        activityId: "test",
        userId: "test",
        parent: "test",
        createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
        updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
        targetFeeds: [FeedId("slug", "userId")],
        user: {"test": "test"},
        targetFeedsExtraData: {"test": "test"},
        data: {"test": "test"},
        // latestChildren: {
        //   "test": [reaction2]
        // },//TODO: test this
        childrenCounts: {"test": 1});
    final paginatedReactions =
        PaginatedReactions("test", [reaction], enrichedActivity, "duration");

    final paginatedReactionsJson = json.decode(
        '{"next": "test", "results": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}], "duration": "duration", "activity": {"id":"test", "actor": "test","object": "test", "verb": "test","target": "test", "to":["test"], "foreign_id": "test", "time": "2001-09-11T00:01:02.000","analytics": {"test": "test"},"extra_context": {"test": "test"},"origin":"test","score":1.0,"reaction_counts": {"test": 1},"own_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]},"latest_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]}, "extra_data": {"test": "test"}}}');
    // expect(paginatedReactionsJson, "matcher");
    final paginatedReactionsFromJson =
        PaginatedReactions.fromJson(paginatedReactionsJson);
    expect(paginatedReactionsFromJson.results, [reaction]);
    expect(paginatedReactionsFromJson.next, "test");
    expect(paginatedReactionsFromJson.activity, enrichedActivity);
    expect(paginatedReactionsFromJson, paginatedReactions);
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
        '{"id": "test", "data": {"test": "test"}, "created_at": "2001-09-11T00:01:02.000","updated_at": "2001-09-11T00:01:02.000","followers_count": 1, "following_count": 1}');
    final expectedUserJson = {
      "id": "test",
      "data": {"test": "test"},
      "created_at": "2001-09-11T00:01:02.000",
      "updated_at": "2001-09-11T00:01:02.000",
      "followers_count": 1,
      "following_count": 1
    };
    expect(userJson, expectedUserJson);
    final userFromJson = User.fromJson(expectedUserJson);
    expect(userFromJson, user); //doesnt work
    expect(DateTime.parse("2001-09-11T00:01:02.000"), userFromJson.createdAt);
    expect(DateTime.parse("2001-09-11T00:01:02.000"), userFromJson.updatedAt);
    expect(userFromJson.followersCount, 1);
    expect(userFromJson.followingCount, 1);
  });

  test("Follow", () {
    final follow = Follow("feedId", "targetId");
    final followJson =
        json.decode('{"feed_id": "feedId", "target_id": "targetId"}');

    expect(follow, Follow.fromJson(followJson));
  });
  test("Unfollow", () {
    final follow = UnFollow("feedId", "targetId", true);
    final followJson = json.decode(
        '{"feed_id": "feedId", "target_id": "targetId","keep_history":true}');

    expect(follow, UnFollow.fromJson(followJson));
  });

  test("ActivityUpdate", () {
    final activityUpdate = ActivityUpdate(
        id: "test",
        foreignId: "test",
        time: DateTime.parse("2001-09-11T00:01:02.000"),
        set: {"hey": "hey"},
        unset: ["test"]);
    final activityUpdateJson = json.decode(
        '{"id": "test", "foreign_id": "test", "time": "2001-09-11T00:01:02.000", "set": {"hey": "hey"}, "unset": ["test"]}');

    final activityUpdateFromJson = ActivityUpdate.fromJson(activityUpdateJson);
    expect(activityUpdateFromJson, activityUpdate);
  });

  test("Reaction", () {
    final reaction2 = Reaction(
        id: "test",
        kind: "test",
        activityId: "test",
        userId: "test",
        parent: "test",
        createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
        updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
        targetFeeds: [FeedId("slug", "userId")],
        user: {"test": "test"},
        targetFeedsExtraData: {"test": "test"},
        data: {"test": "test"},
        childrenCounts: {"test": 1});
    final reaction1 = Reaction(
        id: "test",
        kind: "test",
        activityId: "test",
        userId: "test",
        parent: "test",
        createdAt: DateTime.parse("2001-09-11T00:01:02.000"),
        updatedAt: DateTime.parse("2001-09-11T00:01:02.000"),
        targetFeeds: [FeedId("slug", "userId")],
        user: {"test": "test"},
        targetFeedsExtraData: {"test": "test"},
        data: {"test": "test"},
        // latestChildren: {
        //   "test": [reaction2]
        // },//TODO: test this
        childrenCounts: {"test": 1});

    final reaction2Json = json.decode(
        '{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}');
    expect(reaction2Json, {
      "id": "test",
      "kind": "test",
      "activity_id": "test",
      "user_id": "test",
      "parent": "test",
      "updated_at": "2001-09-11T00:01:02.000",
      "created_at": "2001-09-11T00:01:02.000",
      "target_feeds": <String>["slug:userId"],
      "user": {"test": "test"},
      "target_feeds_extra_data": {"test": "test"},
      "data": {"test": "test"},
      "children_counts": {"test": 1}
    });

    final reactionFromJson2 = Reaction.fromJson(reaction2Json);
    expect(reactionFromJson2.id, "test");
    expect(reactionFromJson2.kind, "test");
    expect(reactionFromJson2.activityId, "test");
    expect(reactionFromJson2.userId, "test");
    expect(reactionFromJson2.parent, "test");
    expect(
        reactionFromJson2.createdAt, DateTime.parse("2001-09-11T00:01:02.000"));
    expect(
        reactionFromJson2.updatedAt, DateTime.parse("2001-09-11T00:01:02.000"));
    expect(reactionFromJson2.targetFeeds, [FeedId("slug", "userId")]);
    expect(reactionFromJson2.user, {"test": "test"});
    expect(reactionFromJson2.targetFeedsExtraData, {"test": "test"});
    expect(reactionFromJson2.data, {"test": "test"});
    expect(reactionFromJson2.childrenCounts, {"test": 1});
    expect(reactionFromJson2, reaction2);
  });

  test("Image", () {
    final image = Image(
        image: "test",
        url: "test",
        secureUrl: "test",
        width: "test",
        height: "test",
        type: "test",
        alt: "test");
    final imageJson = json.decode(
        '{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}');

    final imageFromJson = Image.fromJson(imageJson);
    expect(imageFromJson, image);
  });

  test("Video", () {
    final video = Video(
      image: "test",
      url: "test",
      secureUrl: "test",
      width: "test",
      height: "test",
      type: "test",
      alt: "test",
    );

    final videoJson = json.decode(
        '{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}');

    final videoFromJson = Video.fromJson(videoJson);
    expect(videoFromJson, video);
  });
  test("Audio", () {
    final audio = Audio(
      audio: "test",
      url: "test",
      secureUrl: "test",
      type: "test",
    );
    final audioJson = json.decode(
        '{"audio": "test", "url": "test", "secure_url": "test", "type": "test"}');
    final audioFromJson = Audio.fromJson(audioJson);
    expect(audioFromJson, audio);
  });

  test("OpenGraphData", () {
    final openGraphData = OpenGraphData(
      title: "test",
      type: "test",
      url: "test",
      site: "test",
      siteName: "test",
      description: "test",
      determiner: "test",
      locale: "test",
      images: [
        Image(
            image: "test",
            url: "test",
            secureUrl: "test",
            width: "test",
            height: "test",
            type: "test",
            alt: "test")
      ],
      videos: [
        Video(
          image: "test",
          url: "test",
          secureUrl: "test",
          width: "test",
          height: "test",
          type: "test",
          alt: "test",
        )
      ],
      audios: [
        Audio(
          audio: "test",
          url: "test",
          secureUrl: "test",
          type: "test",
        )
      ],
    );
    final openGraphDataJson = json.decode(
        '{"title": "test", "type": "test", "url": "test", "site": "test", "site_name": "test", "description": "test", "determiner": "test", "locale": "test", "images": [{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}], "videos": [{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}], "audios": [{"audio": "test", "url": "test", "secure_url": "test", "type": "test"}]}');
    final openGraphDataFromJson = OpenGraphData.fromJson(openGraphDataJson);
    expect(openGraphDataFromJson, openGraphData);
  });
}
