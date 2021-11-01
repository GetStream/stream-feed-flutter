import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/util/serializer.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';

part 'activity.g.dart';

/// In its simplest form, an activity consists of an `actor`, a `verb`,
/// an `object`, and a `target`.
///
/// It tells the story of a person performing an action on or with an object --
/// "Geraldine posted a photo to her album" or "John shared a video".
/// In most cases these components will be explicit, but they may also be
/// implied.
///
/// Read more about Activities [here](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart) and [here](https://activitystrea.ms/specs/json/1.0/).
@JsonSerializable()
@DateTimeUTCConverter()
class Activity extends Equatable {
  /// Builds an [Activity].
  const Activity({
    required this.actor,
    required this.verb,
    required this.object,
    this.id,
    this.foreignId,
    this.target,
    this.time,
    this.to,
    this.analytics,
    this.extraContext,
    this.origin,
    this.score,
    this.extraData,
  });

  /// Create a new [Activity] instance from a JSON object.
  factory Activity.fromJson(Map<String, dynamic>? json) =>
      _$ActivityFromJson(Serializer.moveKeysToRoot(json, topLevelFields)!);

  /// Provides a permanent, universally unique identifier for the activity in
  /// the form of an absolute IRI.
  ///
  /// An activity SHOULD contain a single id property. If an activity does not
  /// contain an id property, consumers MAY use the value of the url property
  /// as a less-reliable, non-unique identifier.
  @JsonKey(includeIfNull: false)
  final String? id;

  /// Describes the entity that performed the activity.
  ///
  /// An activity MUST contain one actor property whose value is a single
  /// Object.
  final String? actor;

  ///	Identifies the action that the activity describes.
  ///
  /// An activity SHOULD contain a verb property whose value is a JSON String
  /// that is non-empty and matches either the "isegment-nz-nc" or the "IRI"
  /// production in.. Note that the use of a relative reference other than a
  /// simple name is not allowed. If the verb is not specified, or if the
  /// value is null, the verb is assumed to be "post".
  final String? verb;

  /// Describes the primary object of the activity.
  ///
  /// For instance, in the activity, "John saved a movie to his wishlist",
  /// the object of the activity is "movie". An activity SHOULD contain an
  /// object property whose value is a single Object. If the object property
  /// is not contained, the primary object of the activity MAY be implied by
  /// context.
  final String? object;

  /// A unique ID from your application for this activity.
  ///
  /// Examples: "pin:1" or "like:300"
  @JsonKey(includeIfNull: false)
  final String? foreignId;

  /// Describes the target of the activity.
  ///
  /// The precise meaning of the activity's target is dependent on the
  /// activities verb, but will often be the object the English preposition
  /// "to".
  ///
  /// For instance, in the activity, "John saved a movie to his wishlist",
  /// the target of the activity is "wishlist". The activity target MUST NOT
  /// be used to identity an indirect object that is not a target of the
  /// activity. An activity MAY contain a target property whose value is a
  /// single Object.
  @JsonKey(includeIfNull: false)
  final String? target;

  /// The optional time of the activity
  @JsonKey(includeIfNull: false)
  final DateTime? time;

  /// The origin of the activity. i.e. where the actor came from.
  @JsonKey(includeIfNull: false)
  final String? origin;

  /// The recipients of the action.
  ///
  /// The TO field allows you to specify a list of feeds
  /// to which the activity should be copied.
  ///
  /// One way to think about it is as the CC functionality of email.
  ///
  /// # Use Cases
  /// - ## Mentions
  /// Targeting is useful
  /// when you want to support @mentions
  /// and notify users. An example is shown below:
  ///```dart
  ///  // Add the activity to Eric's feed and to Jessica's notification feed
  /// final activity = Activity(
  /// 	actor: 'user:Eric',
  /// 	message: "@Jessica check out getstream.io it's awesome!",
  /// 	verb: 'tweet',
  /// 	object: 'tweet:id',
  /// 	to: [FeedId.id('notification:Jessica')],
  /// );
  /// final response = await user_feed_1.addActivity(activity)
  /// ```
  /// - ## Organizations & Topics
  /// Another everyday use case is for teams, organizations or topics.
  ///
  /// For example, one of our customers runs a football community.
  ///
  /// Updates about a player should also be added to their team's feed.
  ///
  /// Stream supports this by adding the activity to the player's feed,
  /// and specifying the target feeds
  /// in the TO field:
  /// ```dart
  /// // The TO field ensures the activity is sent to the player, match and team feed
  /// final activity = Activity(
  /// 	actor: 'Player:Suarez',
  /// 	verb: 'foul',
  /// 	object: 'Player:Ramos',
  /// 	extraData: {"match": { "name": 'El Clasico', "id": 10 },}
  /// 	to: ['team:barcelona', 'match:1'],
  /// );
  /// const response = await playerFeed1.addActivity(activity);
  /// ```
  @JsonKey(
    includeIfNull: false,
    fromJson: FeedId.fromIds,
    toJson: FeedId.toIds,
  )
  final List<FeedId>? to;

  /// The score of the activity to indicate the importance of the activity.
  @JsonKey(includeIfNull: false)
  final double? score;

  /// This allows you to gain a better understanding of that user's interests.
  /// Common examples include:
  ///   - Clicking on a link
  ///   - Liking or commenting
  ///   - Sharing an activity
  ///   - Viewing another user's profile page
  ///   - Searching for a certain user/content/topic/etc.
  @JsonKey(includeIfNull: false)
  final Map<String, Object>? analytics;

  /// extra context data to be used by the application.
  @JsonKey(includeIfNull: false)
  final Map<String, Object>? extraContext;

  /// Map of custom user extraData
  @JsonKey(includeIfNull: false)
  final Map<String, Object>? extraData;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'actor',
    'verb',
    'object',
    'id',
    'foreign_id',
    'target',
    'time',
    'to',
    'analytics',
    'extra_context',
    'origin',
    'score',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serializer.moveKeysToMapInPlace(_$ActivityToJson(this), topLevelFields);

  /// Copies this [Activity] to a new instance.
  Activity copyWith({
    String? id,
    String? actor,
    String? verb,
    String? object,
    String? foreignId,
    String? target,
    DateTime? time,
    String? origin,
    List<FeedId>? to,
    double? score,
    Map<String, Object>? analytics,
    Map<String, Object>? extraContext,
    Map<String, Object>? extraData,
  }) =>
      Activity(
        id: id ?? this.id,
        actor: actor ?? this.actor,
        verb: verb ?? this.verb,
        object: object ?? this.object,
        foreignId: foreignId ?? this.foreignId,
        target: target ?? this.target,
        time: time ?? this.time,
        origin: origin ?? this.origin,
        to: to ?? this.to,
        score: score ?? this.score,
        analytics: analytics ?? this.analytics,
        extraContext: extraContext ?? this.extraContext,
        extraData: extraData ?? this.extraData,
      );

  @override
  List<Object?> get props => [
        actor,
        object,
        verb,
        target,
        to,
        foreignId,
        id,
        time,
        analytics,
        extraContext,
        origin,
        score,
        extraData,
      ];
}
