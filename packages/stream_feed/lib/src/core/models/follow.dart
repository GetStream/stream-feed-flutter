import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';

part 'follow.g.dart';

/// {@template follow}
/// Model for the follower of a feed
/// {@endtemplate}
@JsonSerializable()
@DateTimeUTCConverter()
class Follow extends Equatable {
  /// Builds a [Follow]
  const Follow({
    required this.feedId,
    required this.targetId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new instance from a JSON object
  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);

  /// The combination of feed slug and user id separated by a colon
  ///
  /// For example: flat:1
  final String feedId;

  /// The id of the feed you want to follow
  final String targetId;

  /// Date at which the follow relationship was created
  final DateTime createdAt;

  /// Date at which the follow relationship was updated
  final DateTime updatedAt;

  @override
  List<Object?> get props => [feedId, targetId, createdAt, updatedAt];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowToJson(this);
}
