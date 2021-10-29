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

/// {@template flatFeedCore}
///Convenient typedef for [GenericFlatFeedCore] with default parameters
/// ## Usage
///
/// ```dart
/// class FlatActivityListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: FlatFeedCore(
///         onErrorWidget: Center(
///             child: Text('An error has occurred'),
///         ),
///         onEmptyWidget: Center(
///             child: Text('Nothing here...'),
///         ),
///         onProgressWidget: Center(
///             child: CircularProgressIndicator(),
///         ),
///         feedBuilder: (context, activities, idx) {
///           return YourActivityWidget(activity: activities[idx]);
///         }
///       ),
///     );
///   }
/// }
/// ```
/// {@endtemplate}
typedef FlatFeedCore = GenericFlatFeedCore<User, String, String, String>;

///Convenient typedef for [GenericReactionListCore] with default parameters
typedef ReactionListCore
    = GenericReactionListCore<User, String, String, String>;

///Convenient typedef for [GenericFeedProvider] with default parameters
typedef FeedProvider = GenericFeedProvider<User, String, String, String>;

///Convenient typedef for [GenericFeedBloc] with default parameters
typedef FeedBloc = GenericFeedBloc<User, String, String, String>;
