import 'package:equatable/equatable.dart';

/// A feed identifier based on [slug] and [userId].
class FeedId extends Equatable {
  /// Builds a [FeedId]
  FeedId(this.slug, this.userId)
      : assert(!slug.contains(':'), 'Invalid slug'), //TODO:
        // validate feed slug stream-python style using regex
        assert(!userId.contains(':'), 'Invalid userId');

  /// Builds a [FeedId] based on id
  factory FeedId.id(String id) {
    assert(id.contains(':'), 'Invalid FeedId');
    final parts = id.split(':');
    assert(parts.length == 2, 'Invalid FeedId');
    return FeedId(parts[0], parts[1]);
  }

  /// The name of the feed group.
  ///
  /// Examples include user, trending, flat etc.
  final String slug;

  /// The owner of the given feed
  final String userId;

  /// A claim to be used in a query
  String get claim => '$slug$userId';

  /// Takes a list of feed ids of type `List<String>`
  /// and returns a list of feed ids of type `List<FeedId>`
  static List<FeedId>? fromIds(List? ids) =>
      ids?.map((e) => FeedId.id(e)).toList(growable: false);

  /// Takes a list of feed ids of type `List<FeedId>`
  /// and returns a list of feed ids as `List<String>`
  static List<String>? toIds(List<FeedId>? feeds) =>
      feeds?.map((e) => e.toString()).toList(growable: false);

  /// FeedId from a string id
  static FeedId? fromId(String? id) {
    if (id == null) return null;
    return FeedId.id(id);
  }

  /// String id from a feed id
  static String? toId(FeedId? feedId) => feedId?.toString();

  @override
  List<Object> get props => [slug, userId];

  @override
  String toString() => '$slug:$userId';
}
