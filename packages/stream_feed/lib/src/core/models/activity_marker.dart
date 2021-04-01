class ActivityMarker {
  bool _allRead = false;
  bool _allSeen = false;

  Set<String> _readIds = {};
  Set<String> _seenIds = {};

  ActivityMarker allRead() {
    _allRead = true;
    return this;
  }

  ActivityMarker allSeen() {
    _allSeen = true;
    return this;
  }

  ActivityMarker read(Iterable<String> activityIds) {
    if (!_allRead) {
      _readIds = {..._readIds, ...activityIds};
    }
    return this;
  }

  ActivityMarker seen(Iterable<String> activityIds) {
    if (!_allSeen) {
      _seenIds = {..._seenIds, ...activityIds};
    }
    return this;
  }

  Map<String, Object> get params {
    final params = <String, Object>{};
    if (_allRead) {
      params['mark_read'] = 'true';
    } else if (_readIds.isNotEmpty) {
      params['mark_read'] = _readIds.join(',');
    }

    if (_allSeen) {
      params['mark_seen'] = 'true';
    } else if (_seenIds.isNotEmpty) {
      params['mark_seen'] = _seenIds.join(',');
    }
    return params;
  }
}
