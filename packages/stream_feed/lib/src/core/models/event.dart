import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stream_feed/src/core/models/feed_id.dart';

part 'event.g.dart';

/// Data about a user
@JsonSerializable()
class UserData extends Equatable {
  /// Builds a [UserData].
  const UserData(this.id, this.alias);

  /// Create a new instance from a JSON object.
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// The id of the user.
  final String id;

  /// An alternative name that can be used to identify the user.
  final String alias;

  @override
  List<Object?> get props => [id, alias];

  /// Serialize to JSON.
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

/// Custom meta-data for your event.
///
/// Examples: the event's name, description, etc.
@JsonSerializable()
class Feature extends Equatable {
  /// Create a new [Feature] with the given group and value.
  const Feature(this.group, this.value);

  /// Create a new instance from a json
  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);

  /// The group of the feature.
  final String group;

  /// The value of the feature.
  final String value;

  @override
  List<Object?> get props => [group, value];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FeatureToJson(this);
}

/// An Event can be an Engagement or an Impression.
@JsonSerializable()
class Event extends Equatable {
  /// Builds an [Event].
  const Event({
    this.userData,
    this.features,
    this.feedId,
    this.location,
    this.position,
  });

  /// Create a new instance from a JSON object.
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// The user data of the event.
  ///
  /// Examples: the user's id, alias, etc.
  final UserData? userData;

  /// The feature that is being tracked.
  ///
  /// Examples: the group and value of the feature.
  @JsonKey(includeIfNull: false)
  final List<Feature>? features;

  /// The feed the user is looking at
  ///
  /// This value is optional.
  @JsonKey(includeIfNull: false, toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? feedId;

  /// The location of the content in your app.
  ///
  /// Examples: email, profile page, etc.
  ///
  /// This value is optional.
  @JsonKey(includeIfNull: false)
  final String? location;

  /// The position in a list of activities.
  ///
  /// When tracking interactions with content, it might be useful to provide
  /// the ordinal position (eg. 2)
  ///
  /// This value is optional.
  @JsonKey(includeIfNull: false)
  final int? position;

  @override
  List<Object?> get props => [userData, features, feedId, location, position];

  /// Copies this [Event] to a new instance.
  Event copyWith({
    UserData? userData,
    List<Feature>? features,
    FeedId? feedId,
    String? location,
    int? position,
  }) =>
      Event(
        userData: userData ?? this.userData,
        features: features ?? this.features,
        feedId: feedId ?? this.feedId,
        location: location ?? this.location,
        position: position ?? this.position,
      );

  /// Serialize to JSON.
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

/// A type of event that contains details about a user's interactions with
/// an Activity.
@JsonSerializable()
class Engagement extends Event {
  /// Builds an [Engagement].
  const Engagement({
    required this.content,
    required this.label,
    this.score,
    this.boost,
    List<Feature>? features,
    FeedId? feedId,
    String? location,
    int? position,
    this.trackedAt,
    UserData? userData,
  }) : super(
          features: features,
          feedId: feedId,
          location: location,
          position: position,
          userData: userData,
        );

  /// Create a new instance from a json
  factory Engagement.fromJson(Map<String, dynamic> json) =>
      _$EngagementFromJson(json);

  /// The ID of the content that the user clicked
  /// Activity ID
  final Content content; //TODO: content

  /// The type of event (i.e. click, share, search, etc.)
  final String label;

  /// Score between 0 and 100 indicating the importance of this event.
  ///
  /// For example, a like is typically a more significant indicator than a
  /// click.
  final int? score;

  /// An integer that multiplies the score of the interaction (eg. 2 or -1)
  @JsonKey(includeIfNull: false)
  final int? boost;

  /// The time at which this event as been tracked.
  @JsonKey(includeIfNull: false)
  final String? trackedAt;

  @override
  List<Object?> get props => [...super.props, content, label, score, trackedAt];

  /// Copies this [Engagement] to a new instance.
  @override
  Engagement copyWith({
    Content? content,
    String? label,
    int? score,
    int? boost,
    List<Feature>? features,
    FeedId? feedId,
    String? location,
    int? position,
    String? trackedAt,
    UserData? userData,
  }) =>
      Engagement(
        content: content ?? this.content,
        label: label ?? this.label,
        score: score ?? this.score,
        boost: boost ?? this.boost,
        features: features ?? this.features,
        feedId: feedId ?? this.feedId,
        location: location ?? this.location,
        position: position ?? this.position,
        trackedAt: trackedAt ?? this.trackedAt,
        userData: userData ?? this.userData,
      );

  /// Serialize to JSON.
  @override
  Map<String, dynamic> toJson() => _$EngagementToJson(this);
}

/// A type of event that contains details about activities a user has viewed.
///
/// Tracking impressions allows you to know what activities have been shown to
/// a user and learn what specific users are or are not not interested in.
///
/// For example, if an app often shows posts about football and the user never
/// engages with those posts, we can conclude that we're displaying the wrong
/// content to that user.
@JsonSerializable()
class Impression extends Event {
  /// Builds an [Impression].
  const Impression({
    required this.contentList,
    List<Feature>? features,
    FeedId? feedId,
    String? location,
    int? position,
    this.trackedAt,
    UserData? userData,
  }) : super(
          userData: userData,
          features: features,
          feedId: feedId,
          location: location,
          position: position,
        );

  /// Create a new instance from a JSON object.
  factory Impression.fromJson(Map<String, dynamic> json) =>
      _$ImpressionFromJson(json);

  /// The list of content the user is looking at.
  ///
  /// Either a list of IDs or objects.
  final List<Content> contentList; //TODO:List<Content>

  /// The time at which this event as been tracked
  @JsonKey(includeIfNull: false)
  final String? trackedAt;

  @override
  List<Object?> get props => [...super.props, contentList, trackedAt];

  /// Copies this [Impression] to a new instance.
  @override
  Impression copyWith({
    List<Content>? contentList,
    List<Feature>? features,
    FeedId? feedId,
    String? location,
    int? position,
    String? trackedAt,
    UserData? userData,
  }) =>
      Impression(
        contentList: contentList ?? this.contentList,
        features: features ?? this.features,
        feedId: feedId ?? this.feedId,
        location: location ?? this.location,
        position: position ?? this.position,
        trackedAt: trackedAt ?? this.trackedAt,
        userData: userData ?? this.userData,
      );

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => _$ImpressionToJson(this);
}

/// Represents custom data related to the content you want to track using
/// Stream Analytics.
///
/// ForeignId is a mandatory field. If it is not set you will get a
/// `RuntimeException`.
@JsonSerializable()
class Content extends Equatable {
  //TODO: attribute: https://github.com/GetStream/stream-analytics-android/blob/62f624f6da5ded03bd4d10d9b169c8c6ddd59984/stream-analytics/src/main/java/io/getstream/analytics/beans/ContentAttribute.java#L39

  /// Builds a [Content].
  const Content({required this.foreignId, this.data});

  /// Create a new instance from a JSON object
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  /// Add a `foreign_id` to the Content.
  @JsonKey(toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? foreignId;

  @JsonKey(includeIfNull: false)

  /// Data related to the content.
  final Map<String, Object>? data;

  @override
  List<Object?> get props => [foreignId, data];

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
