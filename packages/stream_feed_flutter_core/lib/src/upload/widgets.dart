import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';

class FileUploadStateWidget extends StatelessWidget {
  const FileUploadStateWidget({
    Key? key,
    this.onMediaPreview,
    this.onUploadSuccess,
    this.onUploadProgress,
    this.onUploadFailed,
    required this.fileState,
    required this.onRemoveUpload,
    required this.onCancelUpload,
    required this.onRetryUpload,
    required this.stateIconPosition,
  }) : super(key: key);

  final StateIconPosition stateIconPosition;
  final OnMediaPreview? onMediaPreview;
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
          UploadFailedWidget(file,
              stateIconPosition: stateIconPosition,
              onMediaPreview: onMediaPreview,
              onRetryUpload: onRetryUpload,
              mediaType: fail.mediaType);
    } else if (state is UploadSuccess) {
      final success = state as UploadSuccess;
      return onUploadSuccess?.call(file, success) ??
          UploadSuccessWidget(
            file,
            onMediaPreview: onMediaPreview,
            onRemoveUpload: onRemoveUpload,
            stateIconPosition: stateIconPosition,
            mediaType: success.mediaType,
          );
    } else if (state is UploadProgress) {
      final progress = state as UploadProgress;
      final totalBytes = progress.totalBytes;
      final sentBytes = progress.sentBytes;
      return onUploadProgress?.call(file, progress) ??
          UploadProgressWidget(
            file,
            stateIconPosition: stateIconPosition,
            onMediaPreview: onMediaPreview,
            totalBytes: totalBytes,
            sentBytes: sentBytes,
            onCancelUpload: onCancelUpload,
            mediaType: progress.mediaType,
          );
    }
    return UploadSuccessWidget(
      file,
      onMediaPreview: onMediaPreview,
      stateIconPosition: stateIconPosition,
      onRemoveUpload: onRemoveUpload,
      mediaType: state.mediaType,
    );
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key, required this.file, required this.mediaType})
      : assert(mediaType == MediaType.image || mediaType == MediaType.gif,
            'we only support images out of the box, please override onMediaPreview callback'),
        super(key: key);

  final AttachmentFile file;
  final MediaType mediaType;
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
      margin: const EdgeInsets.all(10),
    );
  }
}

class UploadSuccessWidget extends StatelessWidget {
  const UploadSuccessWidget(this.file,
      {Key? key,
      this.onMediaPreview,
      required this.onRemoveUpload,
      required this.stateIconPosition,
      required this.mediaType})
      : super(key: key);
  final MediaType mediaType;

  final StateIconPosition stateIconPosition;
  final OnMediaPreview? onMediaPreview;
  final AttachmentFile file;
  final OnRemoveUpload onRemoveUpload;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
      mediaPreview: onMediaPreview?.call(file: file, mediaType: mediaType) ??
          ImagePreview(
            file: file,
            mediaType: mediaType,
          ),
      stateIconPosition: stateIconPosition,
      stateIcon: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: CircleAvatar(
            backgroundColor: Colors.black87,
            radius: 10,
            child: const Icon(Icons.close, size: 12, color: Colors.white)),
        onTap: () {
          onRemoveUpload(file);
        },
      ),
    );
  }
}

class UploadProgressWidget extends StatefulWidget {
  const UploadProgressWidget(
    this.file, {
    Key? key,
    required this.totalBytes,
    required this.sentBytes,
    required this.onCancelUpload,
    required this.stateIconPosition,
    required this.mediaType,
    this.onMediaPreview,
  }) : super(key: key);

  final StateIconPosition stateIconPosition;
  final OnMediaPreview? onMediaPreview;
  final MediaType mediaType;
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
        stateIconPosition: widget.stateIconPosition,
        mediaPreview: widget.onMediaPreview
                ?.call(file: widget.file, mediaType: widget.mediaType) ??
            ImagePreview(
              file: widget.file,
              mediaType: widget.mediaType,
            ),
        stateIcon: isHover
            ? InkWell(
                onTap: () {
                  widget.onCancelUpload(widget.file);
                },
                onHover: (val) {
                  setState(() {
                    isHover = val;
                  });
                },
                child: const Icon(Icons.close))
            : CircleAvatar(
                backgroundColor: Colors.black87,
                radius: 10,
                child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      value: 1.0 -
                          ((widget.totalBytes - widget.sentBytes) /
                              widget.totalBytes),
                    ))));
  }
}

class UploadFailedWidget extends StatelessWidget {
  const UploadFailedWidget(this.file,
      {Key? key,
      required this.onRetryUpload,
      this.onMediaPreview,
      required this.stateIconPosition,
      required this.mediaType})
      : super(key: key);

  final MediaType mediaType;
  final StateIconPosition stateIconPosition;
  final OnMediaPreview? onMediaPreview;
  final OnRetryUpload onRetryUpload;

  final AttachmentFile file;
  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
        stateIconPosition: stateIconPosition,
        mediaPreview: onMediaPreview?.call(file: file, mediaType: mediaType) ??
            ImagePreview(file: file, mediaType: mediaType),
        stateIcon: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: const Icon(Icons.refresh),
          onTap: () {
            onRetryUpload(file);
          },
        ));
  }
}

enum StateIconPosition { left, right }

class FileUploadStateIcon extends StatelessWidget {
  const FileUploadStateIcon({
    Key? key,
    required this.stateIcon,
    required this.mediaPreview,
    required this.stateIconPosition,
  }) : super(key: key);

  final Widget stateIcon;
  final Widget mediaPreview;

  final StateIconPosition stateIconPosition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        mediaPreview,
        stateIconPosition == StateIconPosition.right
            ? Positioned(
                right: 0,
                top: 0,
                child: stateIcon,
              )
            : Positioned(
                left: 0,
                top: 0,
                child: stateIcon,
              )
      ],
    );
  }
}
