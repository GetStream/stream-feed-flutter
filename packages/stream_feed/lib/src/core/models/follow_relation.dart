import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow_relation.g.dart';

///
@JsonSerializable()
class FollowRelation extends Equatable {
  ///
  const FollowRelation({required this.source, required this.target});

  /// Create a new instance from a json
  factory FollowRelation.fromJson(Map<String, dynamic> json) =>
      _$FollowRelationFromJson(json);

  /// The combination of feed slug and user id separated by a colon
  ///For example: flat:1
  final String? source;

  /// the id of the feed you want to follow
  final String? target;

  @override
  List<Object?> get props => [source, target];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowRelationToJson(this);
}

///
@JsonSerializable()
class UnFollowRelation extends FollowRelation {
  ///
  const UnFollowRelation(String? source, String? target, this.keepHistory)
      : super(source: source, target: target);

  /// Create a new instance from a json
  factory UnFollowRelation.fromJson(Map<String, dynamic> json) =>
      _$UnFollowRelationFromJson(json);

  ///
  factory UnFollowRelation.fromFollow(
          FollowRelation follow, bool? keepHistory) =>
      UnFollowRelation(follow.source, follow.target, keepHistory);

  /// when provided the activities from target feed
  /// will not be kept in the feed.
  final bool? keepHistory;

  @override
  List<Object?> get props => [...super.props, keepHistory];

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => _$UnFollowRelationToJson(this);
}
