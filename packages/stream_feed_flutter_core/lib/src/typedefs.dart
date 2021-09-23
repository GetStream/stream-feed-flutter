import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// TODO: document me
typedef EnrichedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<EnrichedActivity<A, Ob, T, Or>> activities,
  int idx,
);

/// TODO: document me
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions, int idx);

typedef DefaultFlatFeedCore = FlatFeedCore<User, String, String, String>;

typedef DefaultFeedBlocProvider
    = FeedBlocProvider<User, String, String, String>;

typedef DefaultFeedBloc = FeedBloc<User, String, String, String>;
