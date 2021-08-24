import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/paginated.dart';
import 'package:stream_feed/stream_feed.dart';

part 'personalized_feed.g.dart';

/// A personalized feed for a single user.
///
/// In other words, a feed of based on user's activities.
@JsonSerializable(createToJson: true)
class PersonalizedFeed extends Paginated<EnrichedActivity> {
  /// Builds a [PaginatedReactions].
  const PersonalizedFeed({
    required this.version,
    required this.offset,
    required this.limit,
    String? next,
    List<EnrichedActivity>? results,
    String? duration,
  }) : super(next, results, duration);

  /// Deserialize json to [PaginatedReactions]
  factory PersonalizedFeed.fromJson(Map<String, dynamic> json) =>
      _$PersonalizedFeedFromJson(json);

  @override
  List<Object?> get props => [...super.props, version, offset, limit];

  final String version;

  /// The offset of the first result in the current page.
  final int offset;

  /// The maximum number of results to return.
  final int limit;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$PersonalizedFeedToJson(this);
}
