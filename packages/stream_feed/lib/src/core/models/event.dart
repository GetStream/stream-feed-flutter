import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stream_feed/src/core/models/feed_id.dart';

part 'event.g.dart';

///
@JsonSerializable()
class UserData extends Equatable {
  ///
  const UserData(this.id, this.alias);

  /// Create a new instance from a json
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  /// Tiis is the id of the user
  final String id;

  /// This is the alias of the user
  /// an alias is an alternative name that can be used to identify the user
  final String alias;

  @override
  List<Object?> get props => [id, alias];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

/// Custom meta-data for your event.
/// i.e. the event's name, description, etc.
///
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
  ///
  const Event({
    this.userData,
    this.features,
    this.feedId,
    this.location,
    this.position,
  });

  /// Create a new instance from a json
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// The user data of the event.
  /// i.e. the user's id, alias, etc.
  final UserData? userData;

  /// The feature that is being tracked.
  /// i.e. the group and value of the feature.
  @JsonKey(includeIfNull: false)
  final List<Feature>? features;

  /// (optional) the feed the user is looking at
  @JsonKey(includeIfNull: false, toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? feedId;

  /// (optional) the location of the content in your app.
  /// i.e. email, profile page etc
  @JsonKey(includeIfNull: false)
  final String? location;

  /// (optional) the position in a list of activities
  /// When tracking interactions with content,
  /// it might be useful to provide the ordinal position (eg. 2)
  @JsonKey(includeIfNull: false)
  final int? position;

  @override
  List<Object?> get props => [userData, features, feedId, location, position];

  /// Allows us to copy an Event and pass in arguments that overwrite settable
  ///  values (e.g. userData, features, feedId, location, position)
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

  /// Serialize to json
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

/// An Engagement is when a user performs an action on your app.
@JsonSerializable()
class Engagement extends Event {
  ///
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

  /// the ID of the content that the user clicked
  /// Activity ID
  final Content content; //TODO: content

  /// The type of event (i.e. click, share, search, etc.)
  final String label;

  /// score between 0 and 100 indicating the importance of this event
  /// IE. a like is typically a more significant indicator than a click
  final int? score;

  /// An integer that multiplies the score of the interaction (eg. 2 or -1)
  @JsonKey(includeIfNull: false)
  final int? boost;

  /// time at which this event as been tracked
  @JsonKey(includeIfNull: false)
  final String? trackedAt;

  @override
  List<Object?> get props => [...super.props, content, label, score, trackedAt];

 /// Allows us to copy an Engagement and pass in arguments that overwrite 
 /// settable values (e.g. content, label, score, boost, features, feedId, location, 
 /// position, userData)
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

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => _$EngagementToJson(this);
}

/// By using Impression you can track which activities are shown to the user.
/// Tracking impressions allows you to learn what specific users
/// are not interested in. If the app often shows posts about football,
/// and the user never engages with those posts,
/// we can conclude that we're displaying the wrong content.
@JsonSerializable()
class Impression extends Event {
  /// [Impression] constructor
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

  /// Create a new instance from a json
  factory Impression.fromJson(Map<String, dynamic> json) =>
      _$ImpressionFromJson(json);

  /// The list of content the user is looking at.
  /// Either a list of IDs or objects.
  final List<Content> contentList; //TODO:List<Content>

  /// time at which this event as been tracked
  @JsonKey(includeIfNull: false)
  final String? trackedAt;

  @override
  List<Object?> get props => [...super.props, contentList, trackedAt];

  /// Allows us to copy an Impression and pass in arguments that overwrite 
  /// settable values (e.g. contentList, features, feedId, location, position, 
  /// userData)
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

/// The purpose of Stream Analytics is to track every event which you think is a good
///  indicator of a user being interested in a certain bit of content.
///  The Content  object is designed to collect custom data related to the
///  content you want to track using Stream Analytics.<br/>

/// ForeignId is a mandatory field. If not set you will get a RuntimeException.
@JsonSerializable()
class Content extends Equatable {
  /// Add a "foreign_id" to the Content.
  @JsonKey(toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? foreignId;
  
  @JsonKey(includeIfNull: false)
  /// Data related to the content.
  final Map<String, Object>? data;

//TODO: attribute: https://github.com/GetStream/stream-analytics-android/blob/62f624f6da5ded03bd4d10d9b169c8c6ddd59984/stream-analytics/src/main/java/io/getstream/analytics/beans/ContentAttribute.java#L39
  Content({required this.foreignId, this.data});

  @override
  List<Object?> get props => [foreignId, data];

  /// Create a new instance from a json
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
