import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stream_feed_dart/src/core/models/feed_id.dart';

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

///
@JsonSerializable()
class Feature extends Equatable {
  ///
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

  ///
  @JsonKey(toJson: FeedId.toId, fromJson: FeedId.fromId)
  final FeedId? feedId;

  ///
  @JsonKey(includeIfNull: false)
  final String? location;

  ///
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
    required this.score,
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

  ///
  final Map<String, Object> content;

  ///
  final String label;

  ///
  final int score;

  ///
  @JsonKey(includeIfNull: false)
  final int? boost;

  ///
  @JsonKey(includeIfNull: false)
  final String? trackedAt;

  @override
  List<Object?> get props => [...super.props, content, label, score, trackedAt];

  ///
  @override
  Engagement copyWith({
    Map<String, Object>? content,
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

///
@JsonSerializable()
class Impression extends Event {
  ///
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

  ///
  final List<Map<String, Object>> contentList;

  ///
  @JsonKey(includeIfNull: false)
  final String? trackedAt;

  @override
  List<Object?> get props => [...super.props, contentList, trackedAt];

  ///
  @override
  Impression copyWith({
    List<Map<String, Object>>? contentList,
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
