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

  ///
  final String id;

  ///
  final String alias;

  @override
  List<Object?> get props => [id, alias];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

/// Custom meta-data for your event.
@JsonSerializable()
class Feature extends Equatable {
  /// Create a new [Feature] with the given group and value.
  const Feature(this.group, this.value);

  /// Create a new instance from a json
  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);

  ///
  final String group;

  ///
  final String value;

  @override
  List<Object?> get props => [group, value];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FeatureToJson(this);
}

///
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

  ///
  final UserData? userData;

  ///
  @JsonKey(includeIfNull: false)
  final List<Feature>? features;

  /// (optional) the feed the user is looking at
  @JsonKey(includeIfNull: false, toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? feedId;

  /// (optional) the location of the content in your app.
  /// ie email, profile page etc
  @JsonKey(includeIfNull: false)
  final String? location;

  /// (optional) the position in a list of activities
  /// When tracking interactions with content,
  /// it might be useful to provide the ordinal position (eg. 2)
  @JsonKey(includeIfNull: false)
  final int? position;

  @override
  List<Object?> get props => [userData, features, feedId, location, position];

  ///
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

///
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

  ///
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
/// The code below shows how to track that a user viewed 3 specific activities:
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

  ///
  @JsonKey(includeIfNull: false)
  final String? trackedAt;

  @override
  List<Object?> get props => [...super.props, contentList, trackedAt];

  ///
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

@JsonSerializable()
class Content extends Equatable {
  @JsonKey(toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? foreignId;
  @JsonKey(includeIfNull: false)
  final Map<String, Object>? data;
  Content({required this.foreignId, this.data});
  @override
  List<Object?> get props => [foreignId, data];

  /// Create a new instance from a json
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
