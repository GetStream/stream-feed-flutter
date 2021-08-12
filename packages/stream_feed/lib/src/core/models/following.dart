import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';

part 'following.g.dart';

/// {@template following}
/// Following of a feed used in [FollowStats] as field
/// {@endtemplate}
@JsonSerializable()
class Following extends Equatable {
  /// Builds a [Following].
  const Following({required this.feed, this.count, this.slugs});

  /// Builds a [Following] from a JSON object.
  factory Following.fromJson(Map<String, dynamic> json) =>
      _$FollowingFromJson(json);

  @JsonKey(fromJson: _fromId, toJson: FeedId.toId)
  final FeedId feed;
  final List<String>? slugs;
  final int? count;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FollowingToJson(this);

  static FeedId _fromId(String id) => FeedId.id(id);

  @override
  List<Object?> get props => [feed, count];
}
