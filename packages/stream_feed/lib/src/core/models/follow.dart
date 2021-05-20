import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow.g.dart';

///
@JsonSerializable()
class Follow extends Equatable {
  ///
  const Follow(this.source, this.target);

  /// Create a new instance from a json
  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);

  /// The combination of feed slug and user id separated by a colon
  ///For example: flat:1
  @JsonKey(name: 'feed_id')
  final String? source;

  /// the id of the feed you want to follow
  @JsonKey(name: 'target_id')
  final String? target;

  @override
  List<Object?> get props => [source, target];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowToJson(this);
}
