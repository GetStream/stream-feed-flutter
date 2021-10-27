import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

@visibleForTesting
class ActivitiesControllers<A, Ob, T, Or> {
  final Map<String,
          BehaviorSubject<List<GenericEnrichedActivity<A, Ob, T, Or>>>>
      _controller = {};

  List<GenericEnrichedActivity<A, Ob, T, Or>>? getActivities(
          String feedGroup) =>
      _getController(feedGroup)?.valueOrNull;

  Stream<List<GenericEnrichedActivity<A, Ob, T, Or>>>? getStream(
          String feedGroup) =>
      _getController(feedGroup)?.stream;

  void init(String feedGroup) => _controller[feedGroup] =
      BehaviorSubject<List<GenericEnrichedActivity<A, Ob, T, Or>>>();

  void clearActivities(String feedGroup) {
    _getController(feedGroup)!.value = [];
  }

  void clearAllActivities(List<String> feedGroups) {
    feedGroups.forEach(init);
  }

  void close() {
    _controller.forEach((key, value) {
      value.close();
    });
  }

  /// Check if controller is not empty.
  bool hasValue(String feedGroup) =>
      _getController(feedGroup)?.hasValue != null;

  void add(String feedGroup,
      List<GenericEnrichedActivity<A, Ob, T, Or>> activities) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.add(activities);
    }
  }

  BehaviorSubject<List<GenericEnrichedActivity<A, Ob, T, Or>>>? _getController(
          String feedGroup) =>
      _controller[feedGroup];

  void update(String feedGroup,
      List<GenericEnrichedActivity<A, Ob, T, Or>> activities) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.value = activities;
    }
  }

  void addError(String feedGroup, Object e, StackTrace stk) {
    if (hasValue(feedGroup)) {
      _getController(feedGroup)!.addError(e, stk);
    }
  }
}
