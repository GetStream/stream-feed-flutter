import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/flat_feed_core.dart';
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/reactions_list_core.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';

/* BUILDERS */
/// {@template enrichedFeedBuilder}
/// A builder that allows building a ListView of EnrichedActivity based Widgets
/// {@endtemplate}
typedef EnrichedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<GenericEnrichedActivity<A, Ob, T, Or>> activities,
  int idx,
);

typedef UploadsBuilder = Widget Function(
    BuildContext context, List<FileUploadState> uploads);

typedef UploadsErrorBuilder = Widget Function(Object error);

typedef OnUploadSuccess = Widget Function(
    AttachmentFile file, UploadSuccess success);

typedef OnUploadProgress = Widget Function(
    AttachmentFile file, UploadProgress progress);

typedef OnUploadFailed = Widget Function(
    AttachmentFile file, UploadFailed progress);

/// {@template reactionsBuilder}
/// A builder that allows building a ListView of Reaction based Widgets
/// {@endtemplate}
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions, int idx);

/*  CONVENIENT TYPEDEFS
 for defining default type parameters. 
 Dart doesn't allow a type parameter to have a default value
 so this is a hack until it is supported
*/

///Convenient typedef for [GenericFlatFeedCore] with default parameters
///
/// {@template flatFeedCore}
/// [FlatFeedCore] is a core class that allows fetching a list of
/// enriched activities (flat) while exposing UI builders.
/// Make sure to have a [FeedProvider] ancestor in order to provide the
/// information about the activities.
/// Usually what you want is the convenient [FlatFeedCore] that already
/// has the default parameters defined for you
/// suitable to most use cases. But if you need a
/// more advanced use case use [GenericFlatFeedCore] instead
///
/// ## Usage
///
/// ```dart
/// class ActivityListView extends StatelessWidget {
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

// typedef UploadCore = GenericUploadCore<User, String, String, String>;

///Convenient typedef for [GenericReactionListCore] with default parameters
///
/// {@template reactionListCore}
/// [ReactionListCore] is a core class that allows fetching a list of
/// reactions while exposing UI builders.
///
/// ## Usage
///
/// ```dart
/// class ReactionListView extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ReactionListCore(
///         onErrorWidget: Center(
///             child: Text('An error has occurred'),
///         ),
///         onEmptyWidget: Center(
///             child: Text('Nothing here...'),
///         ),
///         onProgressWidget: Center(
///             child: CircularProgressIndicator(),
///         ),
///         feedBuilder: (context, reactions, idx) {
///           return YourReactionWidget(reaction: reactions[idx]);
///         }
///       ),
///     );
///   }
/// }
/// ```
///
/// Make sure to have a [FeedProvider] ancestor in order to provide the
/// information about the reactions.
///
/// Usually what you want is the convenient [ReactionListCore] that already
/// has the default parameters defined for you
/// suitable to most use cases. But if you need a
/// more advanced use case use [GenericReactionListCore] instead
/// {@endtemplate}
typedef ReactionListCore
    = GenericReactionListCore<User, String, String, String>;

/// Convenient typedef for [GenericFeedProvider] with default parameters
///
/// {@template feedProvider}
/// Inherited widget providing the [FeedBloc] to the widget tree
/// Usually what you need is the convenient [FeedProvider] that already
/// has the default parameters defined for you
/// suitable to most usecases. But if you need a
/// more advanced use case use [GenericFeedProvider] instead
/// {@endtemplate}
typedef FeedProvider = GenericFeedProvider<User, String, String, String>;

/// Convenient typedef for [GenericFeedBloc] with default parameters
///
/// {@template feedBloc}
/// Widget dedicated to the state management of an app's Stream feed
/// [FeedBloc] is used to manage a set of operations
/// associated with [EnrichedActivity]s and [Reaction]s.
///
/// [FeedBloc] can be access at anytime by using the factory [of] method
/// using Flutter's [BuildContext].
///
/// Usually what you want is the convenient [FeedBloc] that already
/// has the default parameters defined for you
/// suitable to most use cases. But if you need a
/// more advanced use case use [GenericFeedBloc] instead
///
/// ## Usage
/// - {@macro queryEnrichedActivities}
/// - {@macro queryReactions}
/// - {@macro onAddActivity}
/// - {@macro deleteActivity}
/// - {@macro onAddReaction}
/// - {@macro onRemoveReaction}
/// - {@macro onAddChildReaction}
/// - {@macro onRemoveChildReaction}
/// {@endtemplate}
///
/// {@template genericParameters}
/// The generic parameters can be of the following type:
/// - A : [actor] can be an User, or a String
/// - Ob : [object] can a String, or a CollectionEntry
/// - T : [target] can be a String or an Activity
/// - Or : [origin] can be a String or a Reaction or an User
///
/// To avoid potential runtime errors
/// make sure they are the same across the app if
/// you go the route of using Generic* classes
///
/// {@endtemplate}
typedef FeedBloc = GenericFeedBloc<User, String, String, String>;

typedef OnRemoveUpload = void Function(AttachmentFile file);
typedef OnCancelUpload = void Function(AttachmentFile file);
typedef OnRetryUpload = void Function(AttachmentFile file);

///
/// ```dart
/// if(mediaType == MediaType.image){
//   return  ImagePreview(
///             file:file,
///             mediaType: mediaType,
///           );
/// }  else if (mediaType == MediaType.video) {
///   return YourVideoPlayer(
///             file:file,
///             mediaType: mediaType,
///           );
///
/// } else if (mediaType == MediaType.pdf) {
///   return YourPdfViewer(
///             file:file,
///             mediaType: mediaType,
///           );
///
/// } else if (mediaType == MediaType.audio) {
///   return YourAudioPlayer(
///             file:file,
///             mediaType: mediaType,
///           );
///
/// }
/// ```
typedef OnMediaPreview = Widget Function(
    {required AttachmentFile file, required MediaType mediaType});
