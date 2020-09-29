import '../filter.dart';

class ReactionFilter {
  final String id;
  final Filter filter;

  const ReactionFilter._(this.filter, this.id);

  factory ReactionFilter.idGreaterThanOrEqual(String id) =>
      ReactionFilter._(Filter.id_greater_than_or_equal, id);

  factory ReactionFilter.idGreaterThan(String id) =>
      ReactionFilter._(Filter.id_greater_than, id);

  factory ReactionFilter.idLessThanOrEqual(String id) =>
      ReactionFilter._(Filter.id_less_than_or_equal, id);

  factory ReactionFilter.idLessThan(String id) =>
      ReactionFilter._(Filter.id_less_than, id);
}
