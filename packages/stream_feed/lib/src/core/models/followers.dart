import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';

part 'followers.g.dart';

@JsonSerializable()
class Followers extends Equatable {
  const Followers({required this.feed, this.count, this.slugs});

  factory Followers.fromJson(Map<String, dynamic> json) =>
      _$FollowersFromJson(json);

  @JsonKey(fromJson: _fromId, toJson: FeedId.toId)
  final FeedId feed;
  final List<String>? slugs;
  final int? count;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowersToJson(this);

  static FeedId _fromId(String id) => FeedId.id(id);

  @override
  List<Object?> get props => [feed, count];
}
