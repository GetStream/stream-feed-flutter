import 'package:stream_feed/stream_feed.dart';

/// TODO: Document me
extension ReactionX on List<Reaction> {
  ///Filter reactions by reaction kind
  List<Reaction?> filterByKind(String kind) =>
      where((reaction) => reaction.kind == kind).toList();
}
