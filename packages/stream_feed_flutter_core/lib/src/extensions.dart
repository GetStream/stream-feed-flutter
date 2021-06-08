import 'package:stream_feed/stream_feed.dart';

extension ReactionX on List<Reaction> {
  List<Reaction?> filterByKind(String kind) =>
      where((reaction) => reaction.kind == kind).toList();
}
