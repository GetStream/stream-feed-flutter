import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

extension ReactionX on List<Reaction> {
  ///Filter reactions by reaction kind
  List<Reaction?> filterByKind(String kind) =>
      where((reaction) => reaction.kind == kind).toList();

  Reaction getReactionPath(Reaction reaction) => this
      .firstWhere((r) => r.id! == reaction.id!); //TODO; handle doesn't exist
}

extension EnrichedActivityX on List<EnrichedActivity> {
  EnrichedActivity getEnrichedActivityPath(EnrichedActivity enrichedActivity) =>
      this.firstWhere(
          (e) => e.id! == enrichedActivity.id!); //TODO; handle doesn't exist

  List<EnrichedActivity> updateIn(
      EnrichedActivity enrichedActivity, int indexPath) {
    var result = List<EnrichedActivity>.from(this);
    result.isNotEmpty
        ? result.removeAt(indexPath) //removes the item at index 1
        : null;
    result.insert(indexPath, enrichedActivity);
    return result;
  }
}

extension UnshiftMapList on Map<String, List<Reaction>>? {
  Map<String, List<Reaction>> unshiftByKind(String kind, Reaction reaction) {
    Map<String, List<Reaction>>? result;
    result = this;
    final latestReactionsByKind = this?[kind] ?? [];
    if (result != null) {
      //TODO: extract this logic to a convenient method
      result[kind] = latestReactionsByKind.unshift(reaction);
    } else {
      result = {
        kind: [reaction]
      };
    }
    return result;
  }
}

extension UnshiftMapController
    on Map<String, BehaviorSubject<List<Reaction>>>? {
  Map<String, BehaviorSubject<List<Reaction>>> unshiftById(
      String activityId, Reaction reaction) {
    Map<String, BehaviorSubject<List<Reaction>>>? result;
    result = this;
    final latestReactionsById = this?[activityId]?.valueOrNull ?? [];
    if (result != null) {
      //TODO: extract this logic to a convenient method
      result[activityId] =
          BehaviorSubject.seeded(latestReactionsById.unshift(reaction));
    } else {
      result = {
        activityId: BehaviorSubject.seeded([reaction])
      };
    }
    return result;
  }
}

// BehaviorSubject<List<Reaction>>

extension UnshiftMapInt on Map<String, int>? {
  Map<String, int> unshiftByKind(String kind) {
    Map<String, int>? result;
    result = this;
    final reactionCountsByKind = result?[kind] ?? 0;
    if (result != null) {
      result[kind] =
          reactionCountsByKind + 1; //TODO: handle delete reaction / decrement
    } else {
      result = {kind: 1};
    }
    return result;
  }
}

extension Unshift<T> on List<T> {
  List<T> unshift(T item) => [item, ...this];
}
