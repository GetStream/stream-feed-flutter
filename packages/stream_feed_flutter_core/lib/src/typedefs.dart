import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Type definition for a builder that let you build a ListView of
/// EnrichedActivity based Widgets.
typedef EnrichedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<EnrichedActivity<A, Ob, T, Or>> activities,
  int idx,
);

/// Type definition for a builder that allows building a ListView of Reaction
/// based Widgets.
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions, int idx);
