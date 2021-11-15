import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';

class FileUploadStateWidget extends StatelessWidget {
  const FileUploadStateWidget(
      {Key? key,
      required this.fileState,
      this.onUploadSuccess,
      this.onUploadProgress,
      this.onUploadFailed,
      required this.onRemoveUpload,
      required this.onCancelUpload,
      required this.onRetryUpload})
      : super(key: key);

  final FileUploadState fileState;

  final OnUploadSuccess? onUploadSuccess;
  final OnUploadProgress? onUploadProgress;
  final OnUploadFailed? onUploadFailed;

  final OnRemoveUpload onRemoveUpload;
  final OnCancelUpload onCancelUpload;
  final OnRetryUpload onRetryUpload;

  UploadState get state => fileState.state;
  AttachmentFile get file => fileState.file;

  @override
  Widget build(BuildContext context) {
    if (state is UploadFailed) {
      final fail = state
          as UploadFailed; //TODO: wait for Dart proposal on field promotion or Enhanced Enum (Dart 2.15)
      return onUploadFailed?.call(file, fail) ??
          UploadFailedWidget(
            file,
            onRetryUpload: onRetryUpload,
          );
    } else if (state is UploadSuccess) {
      final success = state as UploadSuccess;
      return onUploadSuccess?.call(file, success) ??
          UploadSuccessWidget(
            file,
            onRemoveUpload: onRemoveUpload,
          );
    } else if (state is UploadProgress) {
      final progress = state as UploadProgress;
      final totalBytes = progress.totalBytes;
      final sentBytes = progress.sentBytes;
      return onUploadProgress?.call(file, progress) ??
          UploadProgressWidget(
            file,
            totalBytes: totalBytes,
            sentBytes: sentBytes,
            onCancelUpload: onCancelUpload,
          );
    }
    return UploadSuccessWidget(
      file,
      onRemoveUpload: onRemoveUpload,
    );
  }
}

class FilePreview extends StatelessWidget {
  const FilePreview(
    this.file, {
    Key? key,
  }) : super(key: key);
  final AttachmentFile file;
  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.file(File(file.path!)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
    );
  }
}

class UploadSuccessWidget extends StatelessWidget {
  const UploadSuccessWidget(this.file, {Key? key, required this.onRemoveUpload})
      : super(key: key);
  final AttachmentFile file;
  final OnRemoveUpload onRemoveUpload;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
        filePreview: FilePreview(file),
        stateIcon: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            onRemoveUpload(file);
          },
        ));
  }
}

class UploadProgressWidget extends StatefulWidget {
  const UploadProgressWidget(
    this.file, {
    Key? key,
    required this.totalBytes,
    required this.sentBytes,
    required this.onCancelUpload,
  }) : super(key: key);

  final AttachmentFile file;
  final int totalBytes;
  final int sentBytes;
  final OnCancelUpload onCancelUpload;

  @override
  State<UploadProgressWidget> createState() => _UploadProgressWidgetState();
}

class _UploadProgressWidgetState extends State<UploadProgressWidget> {
  late bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
        filePreview: FilePreview(widget.file),
        stateIcon: isHover
            ? InkWell(
                onHover: (val) {
                  setState(() {
                    isHover = val;
                  });
                },
                child: Icon(Icons.close))
            : CircularProgressIndicator(
                value:
                    (widget.totalBytes - widget.sentBytes) / widget.totalBytes,
              ));
  }
}

class UploadFailedWidget extends StatelessWidget {
  const UploadFailedWidget(this.file, {Key? key, required this.onRetryUpload})
      : super(key: key);
  final OnRetryUpload onRetryUpload;

  final AttachmentFile file;
  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
        filePreview: FilePreview(file),
        stateIcon: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            onRetryUpload(file);
          },
        ));
  }
}

class FileUploadStateIcon extends StatelessWidget {
  final Widget stateIcon;
  final Widget filePreview;
  const FileUploadStateIcon({
    Key? key,
    required this.stateIcon,
    required this.filePreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        filePreview,
        Positioned(
          right: 0, //TODO: paramterize position
          top: 0,
          child: stateIcon,
        )
      ],
    );
  }
}
