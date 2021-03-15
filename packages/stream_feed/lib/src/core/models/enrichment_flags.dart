enum _EnrichmentType {
  ownChildren,
  ownReactions,
  reactionCounts,
  reactionKinds,
  recentReactions,
  recentReactionsLimit,
}

extension _EnrichmentTypeX on _EnrichmentType {
  String? get type => {
        _EnrichmentType.ownChildren: 'with_own_children',
        _EnrichmentType.ownReactions: 'with_own_reactions',
        _EnrichmentType.reactionCounts: 'with_reaction_counts',
        _EnrichmentType.reactionKinds: 'reaction_kinds_filter',
        _EnrichmentType.recentReactions: 'with_recent_reactions',
        _EnrichmentType.recentReactionsLimit: 'recent_reactions_limit',
      }[this];
}

class EnrichmentFlags {
  String? _userId;
  final Map<_EnrichmentType, Object> _flags = {};

  Map<String?, Object?> get params {
    final params = _flags.map((key, value) => MapEntry(key.type, value));
    if (_userId != null) params['user_id'] = _userId!;
    return params;
  }

  EnrichmentFlags withOwnChildren() {
    _flags[_EnrichmentType.ownChildren] = true;
    return this;
  }

  EnrichmentFlags withOwnReactions() {
    _flags[_EnrichmentType.ownReactions] = true;
    return this;
  }

  EnrichmentFlags withUserReactions(String userId) {
    _flags[_EnrichmentType.ownReactions] = true;
    _userId = userId;
    return this;
  }

  EnrichmentFlags withRecentReactions([int? limit]) {
    if (limit == null) {
      _flags[_EnrichmentType.recentReactions] = true;
    } else {
      _flags[_EnrichmentType.recentReactionsLimit] = limit;
    }
    return this;
  }

  EnrichmentFlags reactionKindFilter(Iterable<String> kinds) {
    _flags[_EnrichmentType.reactionKinds] = kinds.join(',');
    return this;
  }

  EnrichmentFlags withReactionCounts() {
    _flags[_EnrichmentType.reactionCounts] = true;
    return this;
  }

  EnrichmentFlags withUserChildren(String userId) {
    _flags[_EnrichmentType.ownChildren] = true;
    _userId = userId;
    return this;
  }
}
