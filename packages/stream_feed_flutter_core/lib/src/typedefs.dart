import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template enrichedFeedBuilder}
/// A builder that allows building a ListView of EnrichedActivity based Widgets
/// {@endtemplate}
typedef EnrichedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<GenericEnrichedActivity<A, Ob, T, Or>> activities,
  int idx,
);

/// {@template reactionsBuilder}
/// A builder that allows building a ListView of Reaction based Widgets
/// {@endtemplate}
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions, int idx);

typedef FlatFeedCore = GenericFlatFeedCore<User, String, String, String>;
typedef ReactionListCore
    = GenericReactionListCore<User, String, String, String>;

typedef FeedProvider = GenericFeedProvider<User, String, String, String>;

typedef FeedBloc = GenericFeedBloc<User, String, String, String>;

/// TODO: document me
typedef EnrichedActivity
    = GenericEnrichedActivity<User, String, String, String>;
