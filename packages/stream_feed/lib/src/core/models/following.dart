import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';

part 'following.g.dart';

@JsonSerializable()
class Following extends Equatable {
  @JsonKey(fromJson: _fromId, toJson: FeedId.toId)
  final FeedId feed;
  final int count;
  Following({required this.feed, required this.count});

  factory Following.fromJson(Map<String, dynamic> json) =>
      _$FollowingFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowingToJson(this);

  static FeedId _fromId(String id) => FeedId.id(id);
  List<Object?> get props => [feed, count];
}
