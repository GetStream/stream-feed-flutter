import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';
import 'package:stream_feed_flutter_core/src/upload/widgets.dart';

import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class UploadListCore extends StatefulWidget {
  const UploadListCore({
    Key? key,
    required this.files,
    required this.uploadController,
    this.uploadsBuilder,
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
  final UploadController uploadController;

  @override
  _UploadListCoreState createState() => _UploadListCoreState();
}

class _UploadListCoreState extends State<UploadListCore> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FileUploadState>>(
        stream: widget.uploadController.uploadsStream,
        // bloc.uploadFiles(files) or bloc.uploadFile(file)
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget.onErrorWidget;
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
                FileUploadStateWidget(
                  fileState: uploads[idx],
                  onUploadSuccess: widget.onUploadSuccess,
                  onUploadProgress: widget.onUploadProgress,
                  onUploadFailed: widget.onUploadFailed,
                  onCancelUpload: (AttachmentFile file) {
                    widget.uploadController.cancelUpload(file);
                  },
                  onRemoveUpload: (AttachmentFile file) {
                    widget.uploadController.removeUpload(file);
                  },
                  onRetryUpload: (AttachmentFile file) async {
                    await widget.uploadController.uploadFile(file);
                  },
                ),
          );
        });
  }
}
