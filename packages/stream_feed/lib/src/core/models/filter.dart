import 'package:equatable/equatable.dart';

enum _Filter {
  idGreaterThanOrEqual,

  idGreaterThan,

  idLessThanOrEqual,

  idLessThan,
}

extension _FilterX on _Filter {
  String get name => {
        _Filter.idGreaterThanOrEqual: 'id_gte',
        _Filter.idGreaterThan: 'id_gt',
        _Filter.idLessThanOrEqual: 'id_lte',
        _Filter.idLessThan: 'id_lt',
      }[this]!;
}

/// {@template filter}
/// Note: passing both id_lt[e]andid_gt[e] is not supported.
///
/// Note: when using id_lt[e] the reactions are ordered by the created_at field,
///  in descending order.
///
/// Note: when using id_gt[e] the reactions are ordered by the created_at field,
///  in ascending order.
/// {@endtemplate}
class Filter extends Equatable {
  final Map<_Filter, String> _filters = {};

  /// Serialize [Filter] parameters
  Map<String, String> get params =>
      _filters.map((key, value) => MapEntry(key.name, value));

  /// Retrieve reactions created after the on with ID
  /// equal to the parameter (inclusive)
  Filter idGreaterThanOrEqual(String id) {
    _filters[_Filter.idGreaterThanOrEqual] = id;
    return this;
  }

  /// Retrieve reactions created after the one with ID equal to the parameter.
  Filter idGreaterThan(String id) {
    _filters[_Filter.idGreaterThan] = id;
    return this;
  }

  ///	Retrieve reactions created before the one with ID
  /// equal to the parameter (inclusive)
  Filter idLessThanOrEqual(String id) {
    _filters[_Filter.idLessThanOrEqual] = id;
    return this;
  }

  /// Retrieve reactions before the one with ID equal to the parameter
  Filter idLessThan(String id) {
    _filters[_Filter.idLessThan] = id;
    return this;
  }

  @override
  String toString() => _filters.toString();

  @override
  List<Object?> get props => [_filters];
}
