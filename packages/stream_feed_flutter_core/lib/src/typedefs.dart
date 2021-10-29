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

/*  Convenient typedefs for defining default type parameters 
 Dart doesn't allow a type parameter to have a default value
 so this is hack until it is supported
*/

///Convenient typedef for [GenericFlatFeedCore] with default parameters
typedef FlatFeedCore = GenericFlatFeedCore<User, String, String, String>;

///Convenient typedef for [GenericReactionListCore] with default parameters
typedef ReactionListCore
    = GenericReactionListCore<User, String, String, String>;

///Convenient typedef for [GenericFeedProvider] with default parameters
typedef FeedProvider = GenericFeedProvider<User, String, String, String>;

///Convenient typedef for [GenericFeedBloc] with default parameters
typedef FeedBloc = GenericFeedBloc<User, String, String, String>;

///Convenient typedef for [EnrichedActivity] with default parameters
typedef EnrichedActivity
    = GenericEnrichedActivity<User, String, String, String>;
