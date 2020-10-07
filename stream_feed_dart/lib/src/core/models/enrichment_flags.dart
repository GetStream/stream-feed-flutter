enum _EnrichmentType {
  own_children,
  own_reactions,
  reaction_counts,
  reaction_kinds,
  recent_reactions,
  recent_reactions_limit,
}

extension _EnrichmentTypeX on _EnrichmentType {
  String get type => {
        _EnrichmentType.own_children: 'with_own_children',
        _EnrichmentType.own_reactions: 'with_own_reactions',
        _EnrichmentType.reaction_counts: 'with_reaction_counts',
        _EnrichmentType.reaction_kinds: 'reaction_kinds_filter',
        _EnrichmentType.recent_reactions: 'with_recent_reactions',
        _EnrichmentType.recent_reactions_limit: 'recent_reactions_limit',
      }[this];
}

class EnrichmentFlags {
  String _userId;
  final Map<_EnrichmentType, Object> _flags = {};

  Map<String, Object> get params {
    final params = _flags.map((key, value) => MapEntry(key.type, value));
    if (_userId != null) params['user_id'] = _userId;
    return params;
  }

  EnrichmentFlags withOwnChildren() {
    _flags[_EnrichmentType.own_children] = true;
    return this;
  }

  EnrichmentFlags withOwnReactions() {
    _flags[_EnrichmentType.own_reactions] = true;
    return this;
  }

  EnrichmentFlags withUserReactions(String userId) {
    _flags[_EnrichmentType.own_reactions] = true;
    _userId = userId;
    return this;
  }

  EnrichmentFlags withRecentReactions([int limit]) {
    if (limit == null) {
      _flags[_EnrichmentType.recent_reactions] = true;
    } else {
      _flags[_EnrichmentType.recent_reactions_limit] = limit;
    }
    return this;
  }

  EnrichmentFlags reactionKindFilter(Iterable<String> kinds) {
    _flags[_EnrichmentType.reaction_kinds] = kinds.join(',');
    return this;
  }

  EnrichmentFlags withReactionCounts() {
    _flags[_EnrichmentType.reaction_counts] = true;
    return this;
  }

  EnrichmentFlags withUserChildren(String userId) {
    _flags[_EnrichmentType.own_children] = true;
    _userId = userId;
    return this;
  }
}
