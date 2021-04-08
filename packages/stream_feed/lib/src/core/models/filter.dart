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

class Filter {
  final Map<_Filter, String> _filters = {};

  Map<String, String> get params =>
      _filters.map((key, value) => MapEntry(key.name, value));

  ///Filter the reactions on ids greater than or equal to the given value
  Filter idGreaterThanOrEqual(String id) {
    _filters[_Filter.idGreaterThanOrEqual] = id;
    return this;
  }

  ///	Filter the reactions on ids greater than the given value
  Filter idGreaterThan(String id) {
    _filters[_Filter.idGreaterThan] = id;
    return this;
  }

  ///Filter the reactions on ids smaller than or equal to the given value
  Filter idLessThanOrEqual(String id) {
    _filters[_Filter.idLessThanOrEqual] = id;
    return this;
  }

  ///Filter the reactions on ids smaller than the given value
  Filter idLessThan(String id) {
    _filters[_Filter.idLessThan] = id;
    return this;
  }
}
