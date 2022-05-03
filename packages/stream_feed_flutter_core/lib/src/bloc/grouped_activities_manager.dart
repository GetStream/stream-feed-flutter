import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

@visibleForTesting

/// Class to manage activities.
///
/// This is only used internally within `GenericFeedBloc`.
class GroupedActivitiesManager<A, Ob, T, Or> {
  final Map<String,
          BehaviorSubject<List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>>>
      _controllers = {};

  /// A map of paginated results
  final Map<String, NextParams?> paginatedParams = {};

  /// Init controller for given feedGroup.
  void init(String feedGroup) {
    _controllers[feedGroup] =
        BehaviorSubject<List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>>();
    paginatedParams[feedGroup] = null;
  }

  /// Retrieve with feedGroup the corresponding StreamController from the map
  /// of controllers.
  BehaviorSubject<List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>>?
      _getController(String feedGroup) => _controllers[feedGroup];

  /// Convert the Stream of activities to a List of activities.
  List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>? getActivities(
          String feedGroup) =>
      _getController(feedGroup)?.valueOrNull;

  /// Retrieve Stream of activities with feedGroup.
  Stream<List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>>? getStream(
          String feedGroup) =>
      _getController(feedGroup)?.stream;

  /// Clear activities for a given feedGroup.
  void clearGroupedActivities(String feedGroup) {
    paginatedParams[feedGroup] = null;
    _getController(feedGroup)!.value = [];
  }

  /// Clear all controllers.
  void clearAllGroupedActivities(List<String> feedGroups) {
    feedGroups.forEach(init);
  }

  /// Close all controllers.
  void close() {
    _controllers.forEach((key, value) {
      value.close();
    });
  }

  /// Check if controller is not empty for given feedGroup.
  bool hasValue(String feedGroup) =>
      _getController(feedGroup)?.hasValue != null;

  /// Add a list of activities to the correct controller based on feedGroup.
  void add(String feedGroup,
      List<Group<GenericEnrichedActivity<A, Ob, T, Or>>> activities) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.add(activities);
    }
  }

  /// Update the correct controller with given activities based on feedGroup.
  void update(String feedGroup,
      List<Group<GenericEnrichedActivity<A, Ob, T, Or>>> activities) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.value = activities;
    }
  }

  /// Add an error event to the Stream based on feedGroup.
  void addError(String feedGroup, Object e, StackTrace stk) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.addError(e, stk);
    }
  }
}
