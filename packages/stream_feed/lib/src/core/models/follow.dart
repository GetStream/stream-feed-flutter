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

  ///
  final String feedId;

  ///
  final String targetId;

  @override
  List<Object> get props => [feedId, targetId];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowToJson(this);
}

///
@JsonSerializable()
class UnFollow extends Follow {
  ///
  const UnFollow(String feedId, String targetId, this.keepHistory)
      : super(feedId, targetId);

  /// Create a new instance from a json
  factory UnFollow.fromJson(Map<String, dynamic> json) =>
      _$UnFollowFromJson(json);

  ///
  factory UnFollow.fromFollow(Follow follow, bool keepHistory) =>
      UnFollow(follow.feedId, follow.targetId, keepHistory);

  ///
  final bool keepHistory;

  @override
  List<Object> get props => [...super.props, keepHistory];

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => _$UnFollowToJson(this);
}
