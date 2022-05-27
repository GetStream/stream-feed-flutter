import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/extensions.dart';

@visibleForTesting

/// Class to manage reactions.
///
/// This is only used internally within `GenericFeedBloc`.
class ReactionsManager {
  final Map<String, BehaviorSubject<List<Reaction>>> _controller = {};

  /// A map of paginated results
  final Map<String, NextParams?> paginatedParams = {};

  /// Init controller for given lookupValue.
  void init(String lookupValue) {
    _controller[lookupValue] = BehaviorSubject<List<Reaction>>();
    paginatedParams[lookupValue] = null;
  }

  /// Retrieve with lookupValue the corresponding StreamController from the map
  /// of controllers.
  BehaviorSubject<List<Reaction>>? _getController(String lookupValue) =>
      _controller[lookupValue]; //TODO: handle null safety

  ///Retrieve Stream of reactions with activityId and filter it if necessary
  Stream<List<Reaction>>? getStream(String lookupValue, [String? kind]) {
    final isFiltered = kind != null;
    final reactionStream = _getController(lookupValue)?.stream;
    return isFiltered
        ? reactionStream?.map((reactions) =>
            reactions.where((reaction) => reaction.kind == kind).toList())
        : reactionStream; //TODO: handle null safety
  }

  /// Convert the Stream of reactions to a List of reactions.
  List<Reaction> getReactions(String lookupValue, [Reaction? reaction]) =>
      _getController(lookupValue)?.valueOrNull ??
      (reaction != null ? [reaction] : <Reaction>[]);

  /// Check if controller is not empty.
  bool hasValue(String lookupValue) =>
      _getController(lookupValue)?.hasValue != null;

  /// Lookup latest Reactions by Id and inserts the given reaction to the
  /// beginning of the list.
  void unshiftById(String lookupValue, Reaction reaction,
          [ShiftType type = ShiftType.increment]) =>
      _controller.unshiftById(lookupValue, reaction, type);

  /// Close all stream controllers.
  void close() => _controller.forEach((key, value) {
        value.close();
      });

  /// Clear reactions for a given lookupValue.
  void clearReactions(String lookupValue) {
    paginatedParams[lookupValue] = null;
    _getController(lookupValue)!.value = [];
  }

  void clearAllReactions(List<String> lookupValues) {
    lookupValues.forEach(init);
  }

  /// Update controller value with given reactions.
  void update(String lookupValue, List<Reaction> reactions) {
    if (hasValue(lookupValue)) {
      _getController(lookupValue)!.value = reactions;
    }
  }

  /// Add given reactions to the correct controller.
  void add(String lookupValue, List<Reaction> temp) {
    if (hasValue(lookupValue)) {
      _getController(lookupValue)!.add(temp);
    } //TODO: handle null safety
  }

  /// Add error to the correct controller.
  void addError(String lookupValue, Object e, StackTrace stk) {
    if (hasValue(lookupValue)) {
      _getController(lookupValue)!.addError(e, stk);
    } //TODO: handle null safety
  }
}
