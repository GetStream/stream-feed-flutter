import 'package:stream_feed/stream_feed.dart';

extension ReactionX on List<Reaction> {
  ///Filter reactions by reaction kind
  List<Reaction?> filterByKind(String kind) =>
      where((reaction) => reaction.kind == kind).toList();

  Reaction getReactionPath(Reaction reaction) =>
      this.firstWhere((r) => r.id! == reaction.id!);
}

extension EnrichedActivityX on List<EnrichedActivity> {
  EnrichedActivity getEnrichedActivityPath(EnrichedActivity enrichedActivity) =>
      this.firstWhere((e) => e.id! == enrichedActivity.id!);

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

extension UnshiftMap on Map<String, List<Reaction>>? {
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
    return result!;
  }
}


extension Unshift<T> on List<T> {
  List<T> unshift(T item) => [item, ...this];
}
