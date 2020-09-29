enum Filter {
  id_greater_than_or_equal,
  id_greater_than,
  id_less_than_or_equal,
  id_less_than,
}

extension FilterX on Filter {
  String get name => {
        Filter.id_greater_than_or_equal: 'id_gte',
        Filter.id_greater_than: 'id_gt',
        Filter.id_less_than_or_equal: 'id_lte',
        Filter.id_less_than: 'id_lt',
      }[this];
}
