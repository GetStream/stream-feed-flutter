/// Convenient class to mark feed as seen / read
class ActivityMarker {
  bool _allRead = false;
  bool _allSeen = false;

  Set<String> _readIds = {};
  Set<String> _seenIds = {};

  /// Mark everything as read
  ActivityMarker allRead() {
    _allRead = true;
    return this;
  }

  /// Mark everything as seen
  ActivityMarker allSeen() {
    _allSeen = true;
    return this;
  }

  /// Mark all activities with ids [activityIds] as read
  ActivityMarker read(Iterable<String> activityIds) {
    if (!_allRead) {
      _readIds = {..._readIds, ...activityIds};
    }
    return this;
  }

  /// Mark all activities with ids [activityIds] as seen
  ActivityMarker seen(Iterable<String> activityIds) {
    if (!_allSeen) {
      _seenIds = {..._seenIds, ...activityIds};
    }
    return this;
  }

  /// Serialize ActivityMarker params
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
