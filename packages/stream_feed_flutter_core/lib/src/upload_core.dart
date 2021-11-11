import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/bloc/provider.dart';
import 'package:stream_feed_flutter_core/src/bloc/upload_controller.dart';
import 'package:stream_feed_flutter_core/src/widgets/file_upload.dart';

import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class GenericUploadCore<A, Ob, T, Or> extends StatefulWidget {
  const GenericUploadCore({
    Key? key,
    required this.files,
    required this.uploadsBuilder,
    this.onUploadSuccess,
    this.onUploadProgress,
    this.onUploadFailed,
    this.onErrorWidget = const ErrorStateWidget(),
    this.onProgressWidget = const ProgressStateWidget(),
    this.onEmptyWidget = const EmptyStateWidget(message: 'No uploads'),
  }) : super(key: key);

  /// An error widget to show when an error occurs
  final Widget onErrorWidget;

  /// A progress widget to show when a request is in progress
  final Widget onProgressWidget;

  /// A widget to show when the feed is empty
  final Widget onEmptyWidget;

  final List<AttachmentFile> files;
  final UploadsBuilder? uploadsBuilder;
  final OnUploadSuccess? onUploadSuccess;
  final OnUploadProgress? onUploadProgress;
  final OnUploadFailed? onUploadFailed;

  @override
  _GenericUploadCoreState<A, Ob, T, Or> createState() =>
      _GenericUploadCoreState<A, Ob, T, Or>();
}

class _GenericUploadCoreState<A, Ob, T, Or>
    extends State<GenericUploadCore<A, Ob, T, Or>> {
  late GenericFeedBloc<A, Ob, T, Or> bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = GenericFeedProvider<A, Ob, T, Or>.of(context).bloc;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MapEntry<AttachmentFile, UploadState>>>(
        stream: bloc
            .uploadsStream, //stream get "mutated" with  blocFromContext.uploadFiles(files)
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget
                .onErrorWidget; //TODO: snapshot.error / do we really want backend error here?
          }
          if (!snapshot.hasData) {
            return widget.onProgressWidget;
          }
          final uploads = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: uploads.length,
            itemBuilder: (context, idx) =>
                widget.uploadsBuilder?.call(
                  context,
                  uploads,
                  idx,
                ) ??
                FileUploadState(
                  fileState: uploads[idx],
                  onUploadSuccess: widget.onUploadSuccess,
                  onUploadProgress: widget.onUploadProgress,
                  onUploadFailed: widget.onUploadFailed,
                ),
          );
        });
  }
}
