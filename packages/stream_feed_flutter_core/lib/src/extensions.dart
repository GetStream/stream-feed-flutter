import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

@visibleForTesting
extension ReactionX on List<Reaction> {
  ///Filter reactions by reaction kind
  List<Reaction?> filterByKind(String kind) =>
      where((reaction) => reaction.kind == kind).toList();

  Reaction getReactionPath(Reaction reaction) =>
      firstWhere((r) => r.id! == reaction.id!); //TODO; handle doesn't exist
}

@visibleForTesting
extension EnrichedActivityX<A, Ob, T, Or>
    on List<GenericEnrichedActivity<A, Ob, T, Or>> {
  GenericEnrichedActivity<A, Ob, T, Or> getEnrichedActivityPath(
          GenericEnrichedActivity<A, Ob, T, Or> enrichedActivity) =>
      firstWhere(
          (e) => e.id! == enrichedActivity.id!); //TODO; handle doesn't exist

}

@visibleForTesting
extension UpdateIn<A, Ob, T, Or>
    on List<GenericEnrichedActivity<A, Ob, T, Or>> {
  List<GenericEnrichedActivity<A, Ob, T, Or>> updateIn(
      GenericEnrichedActivity<A, Ob, T, Or> enrichedActivity, int indexPath) {
    final result = List<GenericEnrichedActivity<A, Ob, T, Or>>.from(this);
    if (result.isNotEmpty) {
      result.removeAt(indexPath);
    } //removes the item at index 1
    result.insert(indexPath, enrichedActivity);
    return result;
  }
}

@visibleForTesting
extension UpdateInReaction on List<Reaction> {
  List<Reaction> updateIn(Reaction enrichedActivity, int indexPath) {
    final result = List<Reaction>.from(this);
    if (result.isNotEmpty) {
      result.removeAt(indexPath);
    } //removes the item at index 1
    result.insert(indexPath, enrichedActivity);
    return result;
  }
}

@visibleForTesting
extension UnshiftMapList on Map<String, List<Reaction>>? {
  //TODO: maybe refactor to an operator maybe [Reaction] + Reaction
  Map<String, List<Reaction>> unshiftByKind(String kind, Reaction reaction,
      [ShiftType type = ShiftType.increment]) {
    Map<String, List<Reaction>>? result;
    result = this;
    final latestReactionsByKind = this?[kind] ?? [];
    if (result != null) {
      result = {...result, kind: latestReactionsByKind.unshift(reaction, type)};
    } else {
      result = {
        //TODO: handle decrement: should we throw?
        kind: [reaction]
      };
    }
    return result;
  }
}

@visibleForTesting
extension UnshiftMapController
    on Map<String, BehaviorSubject<List<Reaction>>>? {
  ///Lookup latest Reactions by Id and inserts the given reaction to the
  /// beginning of the list
  Map<String, BehaviorSubject<List<Reaction>>> unshiftById(
      String lookupValue, Reaction reaction,
      [ShiftType type = ShiftType.increment]) {
    Map<String, BehaviorSubject<List<Reaction>>>? result;
    result = this;
    final latestReactionsById = this?[lookupValue]?.valueOrNull ?? [];
    if (result != null && result[lookupValue] != null) {
      final reactions = latestReactionsById.unshift(reaction, type);
      result[lookupValue]!.add(reactions);
    } else {
      result = {
        //TODO: handle decrement
        lookupValue: BehaviorSubject.seeded([reaction])
      };
    }
    return result;
  }
}

//TODO: find a better name
enum ShiftType { increment, decrement }

@visibleForTesting
extension UnshiftMapInt on Map<String, int>? {
  Map<String, int> unshiftByKind(String kind,
      [ShiftType type = ShiftType.increment]) {
    Map<String, int>? result;
    result = this;
    final reactionCountsByKind = result?[kind] ?? 0;
    if (result != null) {
      result = {
        ...result,
        kind: reactionCountsByKind.unshift(type)
      }; //+1 if increment else -1
    } else {
      if (type == ShiftType.increment) {
        result = {kind: 1};
      } else {
        result = {kind: 0};
      }
    }
    return result;
  }
}

@visibleForTesting
extension Unshift<T> on List<T> {
  List<T> unshift(T item, [ShiftType type = ShiftType.increment]) {
    final result = List<T>.from(this);
    if (type == ShiftType.increment) {
      return [item, ...result];
    } else {
      return result..remove(item);
    }
  }
}

@visibleForTesting
extension UnshiftInt on int {
  int unshift([ShiftType type = ShiftType.increment]) {
    if (type == ShiftType.increment) {
      return this + 1;
    } else {
      return this - 1;
    }
  }
}

/// Convenient extensions on build context to access common Stream Feed
/// components.
extension FeedContext on BuildContext {
  /// Access the underlying [StreamFeedClient] instance exposed by
  /// [FeedProvider].
  ///
  /// Requires a [FeedProvider] to be above this call in the widget tree.
  ///
  /// {@macro stream_feed_client}
  StreamFeedClient get feedClient => FeedProvider.of(this).bloc.client;

  /// Access the underlying [UploadController] exposed by [FeedProvider].
  ///
  /// Requires a [FeedProvider] to be above this call in the widget tree.
  ///
  /// {@macro uploadController}
  UploadController get feedUploadController =>
      FeedProvider.of(this).bloc.uploadController;

  /// Access [FeedBloc] exposed by [FeedProvider].
  ///
  /// Requires a [FeedProvider] to be above this call in the widget tree.
  ///
  /// {@macro feedBloc}
  FeedBloc get feedBloc => FeedProvider.of(this).bloc;
}
