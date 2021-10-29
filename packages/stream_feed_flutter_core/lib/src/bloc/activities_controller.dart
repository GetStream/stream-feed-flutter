import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

@visibleForTesting
class ActivitiesController<A, Ob, T, Or> {
  final Map<String,
          BehaviorSubject<List<GenericEnrichedActivity<A, Ob, T, Or>>>>
      _controllers = {};

  /// Init controller for given feedGroup.
  void init(String feedGroup) => _controllers[feedGroup] =
      BehaviorSubject<List<GenericEnrichedActivity<A, Ob, T, Or>>>();

  /// Retrieve with feedGroup the corresponding StreamController from the map
  /// of controllers.
  BehaviorSubject<List<GenericEnrichedActivity<A, Ob, T, Or>>>? _getController(
          String feedGroup) =>
      _controllers[feedGroup];

  /// Convert the Stream of activities to a List of activities.
  List<GenericEnrichedActivity<A, Ob, T, Or>>? getActivities(
          String feedGroup) =>
      _getController(feedGroup)?.valueOrNull;

  ///Retrieve Stream of activities with feedGroup
  Stream<List<GenericEnrichedActivity<A, Ob, T, Or>>>? getStream(
          String feedGroup) =>
      _getController(feedGroup)?.stream;

  /// Clear activities for a given feedGroup
  void clearActivities(String feedGroup) {
    _getController(feedGroup)!.value = [];
  }

  /// Clear all controllers
  void clearAllActivities(List<String> feedGroups) {
    feedGroups.forEach(init);
  }

  /// Close all the controllers
  void close() {
    _controllers.forEach((key, value) {
      value.close();
    });
  }

  /// Check if controller is not empty for given feedGroup
  bool hasValue(String feedGroup) =>
      _getController(feedGroup)?.hasValue != null;

  /// Add a list of activities to the correct controller based on feedGroup
  void add(String feedGroup,
      List<GenericEnrichedActivity<A, Ob, T, Or>> activities) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.add(activities);
    }
  }

  /// Update the correct controller with given activities based on feedGroup
  void update(String feedGroup,
      List<GenericEnrichedActivity<A, Ob, T, Or>> activities) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.value = activities;
    }
  }

  /// Add an error event to the Stream based on feedGroup
  void addError(String feedGroup, Object e, StackTrace stk) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.addError(e, stk);
    }
  }
}
