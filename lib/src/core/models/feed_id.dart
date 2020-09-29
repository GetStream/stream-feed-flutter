import 'package:equatable/equatable.dart';

///
class FeedId extends Equatable {
  ///
  final String slug;

  ///
  final String userId;

  ///
  const FeedId(this.slug, this.userId);

  ///
  factory FeedId.id(String id) {
    final parts = id.split(':');
    if (parts.length != 2) throw 'Invalid feed ID';
    return FeedId(parts[0], parts[1]);
  }

  ///
  String get claim => '$slug$userId';

  ///
  static List<FeedId> fromIds(List<String> ids) =>
      ids?.map((e) => FeedId.id(e))?.toList(growable: false);

  ///
  static List<String> toIds(List<FeedId> feeds) =>
      feeds?.map((e) => e.toString())?.toList(growable: false);

  @override
  List<Object> get props => [slug, userId];

  @override
  String toString() => '$slug:$userId';
}
