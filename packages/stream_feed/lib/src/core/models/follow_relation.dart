import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow_relation.g.dart';

///{@template follow_relation}
/// Model for a follow relationship between two feeds.
/// {@endtemplate}
@JsonSerializable()
class FollowRelation extends Equatable {
  /// {@macro follow_relation}
  const FollowRelation({required this.source, required this.target});

  /// Create a new instance from a json
  factory FollowRelation.fromJson(Map<String, dynamic> json) =>
      _$FollowRelationFromJson(json);

  /// The combination of feed slug and user id separated by a colon
  ///
  /// For example: flat:1
  final String source;

  /// The id of the feed you want to follow
  final String target;

  @override
  List<Object?> get props => [source, target];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowRelationToJson(this);
}

/// Model for an unfollow relationship between two feeds.
@JsonSerializable()
class UnFollowRelation extends FollowRelation {
  /// Builds an [UnFollowRelation].
  const UnFollowRelation(
      {required String source, required String target, this.keepHistory})
      : super(source: source, target: target);

  /// Create a new instance from a json
  factory UnFollowRelation.fromJson(Map<String, dynamic> json) =>
      _$UnFollowRelationFromJson(json);

  /// Builds an [UnFollowRelation] from a Follow.
  factory UnFollowRelation.fromFollow(FollowRelation follow,
          {bool? keepHistory}) =>
      UnFollowRelation(
          source: follow.source,
          target: follow.target,
          keepHistory: keepHistory);

  /// Whether to keep activities from the target feed in this feed.
  final bool? keepHistory;

  @override
  List<Object?> get props => [...super.props, keepHistory];

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => _$UnFollowRelationToJson(this);
}
