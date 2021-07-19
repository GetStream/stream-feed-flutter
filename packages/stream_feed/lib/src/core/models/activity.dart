import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/util/serializer.dart';

part 'activity.g.dart';

/// "In its simplest form, an activity consists of
/// an actor, a verb, and an object.
/// It tells the story of a person performing an action on or with an object."
@JsonSerializable()
class Activity extends Equatable {
  /// Instantiate a new [Activity]
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

  /// Create a new instance from a json
  factory Activity.fromJson(Map<String, dynamic>? json) =>
      _$ActivityFromJson(Serializer.moveKeysToRoot(json, topLevelFields)!);

  /// Activity id: an unique identifier for the activity.
  @JsonKey(includeIfNull: false)
  final String? id;

  /// the thing or service that was the actor in the interaction.
  final String? actor;

  ///	The verb of the activity i.e. what the actor did.
  final String? verb;

  /// The object of the activity i.e the thing or service
  /// that was acted upon or with.
  final String? object;

  /// A unique ID from your application for this activity. i.e. : pin:1 or like:300
  @JsonKey(includeIfNull: false)
  final String? foreignId;

  /// The optional target of the activity i.e. meant for another thing or service.
  @JsonKey(includeIfNull: false)
  final String? target;

  /// The optional time of the activity
  @JsonKey(includeIfNull: false)
  final DateTime? time;

  /// The origin of the activity. i.e. where the actor came from.
  @JsonKey(includeIfNull: false)
  final String? origin;

  /// The recipients of the action.
  /// The TO field allows you to specify a list of feeds
  /// to which the activity should be copied.
  ///  One way to think about it is as the CC functionality of email.
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

  ///  This allows you to gain a better understanding of that user's interests.
  ///  Common examples include:
  ///     Clicking on a link
  ///     Liking or commenting
  ///     Sharing an activity
  ///     Viewing another user's profile page
  ///     Searching for a certain user/content/topic/etc.
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

  ///  allows us to copy an Activity
  ///and pass in arguments that overwrite settable values.
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
