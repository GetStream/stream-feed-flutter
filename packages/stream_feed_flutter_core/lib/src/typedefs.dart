import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// TODO: document me
typedef EnrichedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<GenericEnrichedActivity<A, Ob, T, Or>> activities,
  int idx,
);

/// TODO: document me
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions, int idx);

typedef FlatFeedCore = GenericFlatFeedCore<User, String, String, String>;

typedef FeedBlocProvider
    = GenericFeedBlocProvider<User, String, String, String>;

typedef FeedBloc = GenericFeedBloc<User, String, String, String>;

/// TODO: document me
typedef EnrichedActivity
    = GenericEnrichedActivity<User, String, String, String>;
