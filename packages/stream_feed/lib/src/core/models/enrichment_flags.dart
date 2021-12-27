enum _EnrichmentType {
  ///"ownChildren" attribute
  ownChildren,

  /// "ownReactions" attribute
  ownReactions,

  /// "reactionCounts" attribute
  reactionCounts,

  /// "reaction_kinds_filter" attribute
  reactionKinds,

  /// "with_recent_reactions" attribute
  recentReactions,

  /// "latest_reactions" attribute
  recentReactionsLimit,
}

extension _EnrichmentTypeX on _EnrichmentType {
  String get type => {
        _EnrichmentType.ownChildren: 'with_own_children',
        _EnrichmentType.ownReactions: 'with_own_reactions',
        _EnrichmentType.reactionCounts: 'with_reaction_counts',
        _EnrichmentType.reactionKinds: 'reaction_kinds_filter',
        _EnrichmentType.recentReactions: 'with_recent_reactions',
        _EnrichmentType.recentReactionsLimit: 'recent_reactions_limit',
      }[this]!;
}

/// {@template enrichmentFlags}
/// Flags to indicate the API to enrich activities with additional info like
/// user reactions and count
/// {@endtemplate}
class EnrichmentFlags {
  String? _userId;
  final Map<_EnrichmentType, Object> _flags = {};

  /// Serialize enrichment flags to a dictionary
  Map<String, Object?> get params {
    final params = _flags.map((key, value) => MapEntry(key.type, value));
    if (_userId != null) params['user_id'] = _userId!;
    return params;
  }

  ///	If called activity object will have attribute "own_children"
  /// that contains children reactions of the user
  EnrichmentFlags withOwnChildren() {
    _flags[_EnrichmentType.ownChildren] = true;
    return this;
  }

  ///	If called activity object will have attribute "own_reactions"
  /// that contains list of reactions created by the user himself.
  EnrichmentFlags withOwnReactions() {
    _flags[_EnrichmentType.ownReactions] = true;
    return this;
  }

  ///	If called activity object will have attribute "own_reactions"
  /// that contains list of reactions of other users.
  EnrichmentFlags withUserReactions(String userId) {
    _flags[_EnrichmentType.ownReactions] = true;
    _userId = userId;
    return this;
  }

  /// If called activity object will have attribute "latest_reactions"
  /// that contains list of recently created reactions
  EnrichmentFlags withRecentReactions([int? limit]) {
    if (limit == null) {
      _flags[_EnrichmentType.recentReactions] = true;
    } else {
      _flags[_EnrichmentType.recentReactionsLimit] = limit;
    }
    return this;
  }

  ///	Filter reactions by kinds
  EnrichmentFlags reactionKindFilter(Iterable<String> kinds) {
    _flags[_EnrichmentType.reactionKinds] = kinds.join(',');
    return this;
  }

  ///	If called activity object will have attribute "reaction_counts"
  EnrichmentFlags withReactionCounts() {
    _flags[_EnrichmentType.reactionCounts] = true;
    return this;
  }

  ///	If called activity object will have attribute "with_own_children"
  EnrichmentFlags withUserChildren(String userId) {
    _flags[_EnrichmentType.ownChildren] = true;
    _userId = userId;
    return this;
  }
}
