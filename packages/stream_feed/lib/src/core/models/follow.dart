import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow.g.dart';

///
@JsonSerializable()
class Follow extends Equatable {
  ///
  const Follow(this.feedId, this.targetId);

  /// Create a new instance from a json
  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);

  /// The combination of feed slug and user id separated by a colon
  ///For example: flat:1
  final String? feedId;

  /// the id of the feed you want to follow
  final String? targetId;

  @override
  List<Object?> get props => [feedId, targetId];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowToJson(this);
}

///
@JsonSerializable()
class UnFollow extends Follow {
  ///
  const UnFollow(String? feedId, String? targetId, this.keepHistory)
      : super(feedId, targetId);

  /// Create a new instance from a json
  factory UnFollow.fromJson(Map<String, dynamic> json) =>
      _$UnFollowFromJson(json);

  ///
  factory UnFollow.fromFollow(Follow follow, bool? keepHistory) =>
      UnFollow(follow.feedId, follow.targetId, keepHistory);

  /// when provided the activities from target feed
  /// will not be kept in the feed.
  final bool? keepHistory;

  @override
  List<Object?> get props => [...super.props, keepHistory];

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => _$UnFollowToJson(this);
}
