import 'package:stream_feed_dart/src/core/filter.dart';

class FeedFilter {
  final String id;
  final Filter filter;

  const FeedFilter._(this.filter, this.id);

  factory FeedFilter.idGreaterThanOrEqual(String id) =>
      FeedFilter._(Filter.id_greater_than_or_equal, id);

  factory FeedFilter.idGreaterThan(String id) =>
      FeedFilter._(Filter.id_greater_than, id);

  factory FeedFilter.idLessThanOrEqual(String id) =>
      FeedFilter._(Filter.id_less_than_or_equal, id);

  factory FeedFilter.idLessThan(String id) =>
      FeedFilter._(Filter.id_less_than, id);
}
