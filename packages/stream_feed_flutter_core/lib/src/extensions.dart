import 'package:stream_feed/stream_feed.dart';

/// Extensions methods on [List<Reaction>].
extension ReactionX on List<Reaction> {
  ///Filter reactions by reaction kind.
  List<Reaction?> filterByKind(String kind) =>
      where((reaction) => reaction.kind == kind).toList();
}
