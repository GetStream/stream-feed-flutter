import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow.g.dart';

///
@JsonSerializable()
class Follow extends Equatable {
  ///
  final String feedId;

  ///
  final String targetId;

  ///
  const Follow(this.feedId, this.targetId);

  @override
  List<Object> get props => [feedId, targetId];

  /// Create a new instance from a json
  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowToJson(this);
}

///
@JsonSerializable()
class UnFollow extends Follow {
  ///
  final bool keepHistory;

  ///
  const UnFollow(String feedId, String targetId, this.keepHistory)
      : super(feedId, targetId);

  ///
  factory UnFollow.fromFollow(Follow follow, bool keepHistory) {
    return UnFollow(follow.feedId, follow.targetId, keepHistory);
  }

  @override
  List<Object> get props => [...super.props, keepHistory];

  /// Create a new instance from a json
  factory UnFollow.fromJson(Map<String, dynamic> json) =>
      _$UnFollowFromJson(json);

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => _$UnFollowToJson(this);
}
