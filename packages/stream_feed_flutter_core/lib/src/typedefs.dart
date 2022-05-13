import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/flat_feed_core.dart';
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/reactions_list_core.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';

/* BUILDERS */

/// {@template aggregatedFeedBuilder}
/// A builder that allows building from a list of Group<EnrichedActivity>.
/// {@endtemplate}
typedef AggregatedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<Group<GenericEnrichedActivity<A, Ob, T, Or>>> activities,
);

/// {@template enrichedFeedBuilder}
/// A builder that allows building from a list of EnrichedActivity.
/// {@endtemplate}
typedef EnrichedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<GenericEnrichedActivity<A, Ob, T, Or>> activities,
);

/// A signature for a callback which exposes an error and returns a function.
/// This Callback can be used in cases where an API failure occurs and the
/// widget is unable to render data.
typedef ErrorBuilder = Widget Function(BuildContext context, Object error);

typedef UploadsBuilder = Widget Function(
    BuildContext context, List<FileUploadState> uploads);

typedef UploadsErrorBuilder = Widget Function(Object error);

typedef UploadSuccessBuilder = Widget Function(
    AttachmentFile file, UploadSuccess success);

typedef UploadProgressBuilder = Widget Function(
    AttachmentFile file, UploadProgress progress);

typedef UploadFailedBuilder = Widget Function(
    AttachmentFile file, UploadFailed progress);

/// {@template reactionsBuilder}
/// A builder that allows building a ListView of Reaction based Widgets
/// {@endtemplate}
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions);

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
///         errorBuilder: (context, error) => Center(
///             child: Text('An error has occurred'),
///         ),
///         emptyBuilder: (context) => Center(
///             child: Text('Nothing here...'),
///         ),
///         loadingBuilder: (context) => Center(
///             child: CircularProgressIndicator(),
///         ),
///         feedBuilder: (context, activities) {
///           return Text('Your ListView/GridView of activities');
///         }
///       ),
///     );
///   }
/// }
/// ```
/// {@endtemplate}
typedef FlatFeedCore = GenericFlatFeedCore<User, String, String, String>;

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
///         errorBuilder: (context, error) => Center(
///             child: Text('An error has occurred'),
///         ),
///         emptyBuilder: (context) => Center(
///             child: Text('Nothing here...'),
///         ),
///         loadingBuilder: (context) => Center(
///             child: CircularProgressIndicator(),
///         ),
///         feedBuilder: (context, reactions) {
///           return Text('Your ListView/GridView of reactions');
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
/// A class dedicated to the state management of an app's Stream feed.
///
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

/// {@template mediaPreviewBuilder}
/// Based on the [MediaPreview] type, this builder will return a
/// [Widget] that will be used to display the media preview
///
/// For example:
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
/// {@endtemplate}
typedef MediaPreviewBuilder = Widget Function(
    AttachmentFile file, MediaType mediaType);

/// {@template enrichedActivity}
///
/// A simplified version of [GenericEnrichedActivity], with preset types of:
/// - [User], [String], [String], [String]
///
/// Enrichment is a concept in Stream that enables our API to work quickly
/// and efficiently.
///
/// It is the concept that most data is stored as references to an original
/// data. For example, if I add an activity to my feed and it fans out to 50
/// followers, the activity is not copied 50 times, but the activity is stored
/// in a single table only once, and references are stored in 51 feeds.
///
/// The same rule applies to users and reactions. They are stored only once,
/// but references are used elsewhere.
///
/// An Enriched Activity is an Activity with additional fields
/// that are derived from the Activity's
///
/// This class makes use of generics in order to have a more flexible API
/// surface. Here is a legend of what each generic is for:
/// * A = [actor]
/// * Ob = [object]
/// * T = [target]
/// * Or = [origin]
///
/// {@endtemplate}
typedef EnrichedActivity
    = GenericEnrichedActivity<User, String, String, String>;
