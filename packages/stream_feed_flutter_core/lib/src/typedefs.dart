import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/flat_feed_core.dart';
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/reactions_list_core.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/* BUILDERS */
/// {@template enrichedFeedBuilder}
/// A builder that allows building a ListView of EnrichedActivity based Widgets
/// {@endtemplate}
typedef EnrichedFeedBuilder<A, Ob, T, Or> = Widget Function(
  BuildContext context,
  List<GenericEnrichedActivity<A, Ob, T, Or>> activities,
  int idx,
);

/// A builder that allows building a widget given a List<[FileUploadState]>
typedef UploadsBuilder = Widget Function(
    BuildContext context, List<FileUploadState> uploads);

/// A builder that allows to build a widget given the error state of the
/// upload and the file being uploaded
typedef UploadsErrorBuilder = Widget Function(Object error);

/// A builder that allows to build a widget given the state of the successful
///  upload and the file being uploaded
typedef UploadSuccessBuilder = Widget Function(
    AttachmentFile file, UploadSuccess success);

/// A builder that allows to build a widget given the state of the in progress
/// upload and the file being uploaded
typedef UploadProgressBuilder = Widget Function(
    AttachmentFile file, UploadProgress progress);

/// A builder that allows to build a widget given the state of the failed upload
/// and the file being uploaded
typedef UploadFailedBuilder = Widget Function(
    AttachmentFile file, UploadFailed progress);

/// {@template reactionsBuilder}
/// A builder that allows building a ListView of Reaction based Widgets
/// {@endtemplate}
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions, int idx);

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
typedef MediaPreviewBuilder = Widget Function(
    {required AttachmentFile file, required MediaType mediaType});

/// TODO: document me
typedef EnrichedActivity
    = GenericEnrichedActivity<User, String, String, String>;
