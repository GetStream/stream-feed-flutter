enum _Filter {
  id_greater_than_or_equal,
  id_greater_than,
  id_less_than_or_equal,
  id_less_than,
}

extension _FilterX on _Filter {
  String get name => {
        _Filter.id_greater_than_or_equal: 'id_gte',
        _Filter.id_greater_than: 'id_gt',
        _Filter.id_less_than_or_equal: 'id_lte',
        _Filter.id_less_than: 'id_lt',
      }[this];
}

class Filter {
  final Map<_Filter, String> _filters = {};

  Map<String, String> get params =>
      _filters.map((key, value) => MapEntry(key.name, value));

  Filter idGreaterThanOrEqual(String id) {
    _filters[_Filter.id_greater_than_or_equal] = id;
    return this;
  }

  Filter idGreaterThan(String id) {
    _filters[_Filter.id_greater_than] = id;
    return this;
  }

  Filter idLessThanOrEqual(String id) {
    _filters[_Filter.id_less_than_or_equal] = id;
    return this;
  }

  Filter idLessThan(String id) {
    _filters[_Filter.id_less_than] = id;
    return this;
  }
}
