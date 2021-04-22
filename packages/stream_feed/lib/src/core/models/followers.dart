import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';

part 'followers.g.dart';

@JsonSerializable()
class Followers extends Equatable {
  @JsonKey(fromJson: _fromId, toJson: FeedId.toId)
  final FeedId feed;
  final int count;
  Followers({required this.feed, required this.count});

  factory Followers.fromJson(Map<String, dynamic> json) =>
      _$FollowersFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowersToJson(this);

  static FeedId _fromId(String id) => FeedId.id(id);
  List<Object?> get props => [feed, count];
}
