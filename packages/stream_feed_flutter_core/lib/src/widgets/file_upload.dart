import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/bloc/upload_controller.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FileUploadState extends StatelessWidget {
  const FileUploadState({
    Key? key,
    required this.fileState,
    this.onUploadSuccess,
    this.onUploadProgress,
    this.onUploadFailed,
  }) : super(key: key);
  final MapEntry<AttachmentFile, UploadState> fileState;

  final OnUploadSuccess? onUploadSuccess;
  final OnUploadProgress? onUploadProgress;
  final OnUploadFailed? onUploadFailed;
  UploadState get state => fileState.value;
  AttachmentFile get file => fileState.key;

  @override
  Widget build(BuildContext context) {
    if (state is UploadFailed) {
      final fail = state
          as UploadFailed; //TODO: wait for Dart proposal on field promotion or Enhanced Enum (Dart 2.15)
      return onUploadFailed?.call(file, fail) ?? UploadFailedWidget(file);
    } else if (state is UploadSuccess) {
      final success = state as UploadSuccess;
      return onUploadSuccess?.call(file, success) ?? UploadSuccessWidget(file);
    } else if (state is UploadProgress) {
      final progress = state as UploadProgress;
      final totalBytes = progress.totalBytes;
      final sentBytes = progress.sentBytes;
      return onUploadProgress?.call(file, progress) ??
          UploadProgressWidget(file,
              totalBytes: totalBytes, sentBytes: sentBytes);
    }
    return UploadSuccessWidget(file);
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
    return Image.file(File(file.path!));
  }
}

class UploadSuccessWidget extends StatelessWidget {
  const UploadSuccessWidget(
    this.file, {
    Key? key,
  }) : super(key: key);
  final AttachmentFile file;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
        filePreview: FilePreview(file), stateIcon: Icon(Icons.check_circle));
  }
}

class UploadProgressWidget extends StatelessWidget {
  const UploadProgressWidget(
    this.file, {
    Key? key,
    required this.totalBytes,
    required this.sentBytes,
  }) : super(key: key);

  final AttachmentFile file;
  final int totalBytes;
  final int sentBytes;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
      filePreview: FilePreview(file),
      stateIcon: CircularProgressIndicator(
        value: (totalBytes - sentBytes) / totalBytes,
      ),
    );
  }
}

class UploadFailedWidget extends StatelessWidget {
  const UploadFailedWidget(
    this.file, {
    Key? key,
  }) : super(key: key);

  final AttachmentFile file;
  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
        filePreview: FilePreview(file), stateIcon: Icon(Icons.cancel_outlined));
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
          right: 0,
          top: 0,
          child: stateIcon,
        )
      ],
    );
  }
}
