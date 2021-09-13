import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

//TODO: find a better than shift

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
  Map<String, List<Reaction>> unshiftByKind(String kind, Reaction reaction,
      [ShiftType type = ShiftType.increment]) {
    Map<String, List<Reaction>>? result;
    result = this;
    final latestReactionsByKind = this?[kind] ?? [];
    if (result != null) {
      result[kind] = latestReactionsByKind.unshift(reaction, type);
    } else {
      result = {
        //TODO: handle decrement
        kind: [reaction]
      };
    }
    return result;
  }
}

extension UnshiftMapController
    on Map<String, BehaviorSubject<List<Reaction>>>? {
  Map<String, BehaviorSubject<List<Reaction>>> unshiftById(
      String activityId, Reaction reaction,
      [ShiftType type = ShiftType.increment]) {
    Map<String, BehaviorSubject<List<Reaction>>>? result;
    result = this;
    final latestReactionsById = this?[activityId]?.valueOrNull ?? [];
    if (result != null) {
      result[activityId] =
          BehaviorSubject.seeded(latestReactionsById.unshift(reaction, type));
    } else {
      result = {
        //TODO: handle decrement
        activityId: BehaviorSubject.seeded([reaction])
      };
    }
    return result;
  }
}

//TODO: find a better name
enum ShiftType { increment, decrement }

extension UnshiftMapInt on Map<String, int>? {
  Map<String, int> unshiftByKind(String kind,
      [ShiftType type = ShiftType.increment]) {
    Map<String, int>? result;
    result = this;
    final reactionCountsByKind = result?[kind] ?? 0;
    if (result != null) {
      result[kind] =
          reactionCountsByKind.unshift(type); //+1 if increment else -1
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

extension Unshift<T> on List<T> {
  List<T> unshift(T item, [ShiftType type = ShiftType.increment]) {
    if (type == ShiftType.increment) {
      return [item, ...this];
    } else {
      var result = this;
      result.remove(item);
      return result;
    }
  }
}

extension UnshiftInt on int {
  int unshift([ShiftType type = ShiftType.increment]) {
    if (type == ShiftType.increment) {
      return this + 1;
    } else {
      return this - 1;
    }
  }
}
