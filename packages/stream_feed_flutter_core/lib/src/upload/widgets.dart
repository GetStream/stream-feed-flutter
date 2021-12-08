import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FileUploadHandlers {
  const FileUploadHandlers(this.uploadController);

  final UploadController uploadController;

  void onRemoveUpload(AttachmentFile file) {
    uploadController.removeUpload(file);
  }

  void onCancelUpload(AttachmentFile file) {
    uploadController.cancelUpload(file);
  }

  Future<void> onRetryUpload(AttachmentFile file) {
    return uploadController.uploadImage(file);
  }
}

/// A convenience widget to easily display the state of a file upload.
///
/// Create a custom view by providing:
/// - [onMediaPreview]
/// - [onUploadSuccess]
/// - [onUploadProgress]
/// - [onUploadFailed]
///
/// Extend [FileUploadHandlers] to override the default upload handlers. These
/// hanlders are used in the default
class FileUploadStateWidget extends StatelessWidget {
  const FileUploadStateWidget({
    Key? key,
    required this.fileState,
    required this.fileUploadHandlers,
    this.stateIconPosition = StateIconPosition.left,
    this.onMediaPreview,
    this.onUploadSuccess,
    this.onUploadProgress,
    this.onUploadFailed,
  }) : super(key: key);

  /// The state of the file upload.
  final FileUploadState fileState;
  final FileUploadHandlers fileUploadHandlers;

  final StateIconPosition stateIconPosition;

  final OnMediaPreview? onMediaPreview;
  final OnUploadSuccess? onUploadSuccess;
  final OnUploadProgress? onUploadProgress;
  final OnUploadFailed? onUploadFailed;

  UploadState get _state => fileState.state;
  AttachmentFile get _file => fileState.file;

  @override
  Widget build(BuildContext context) {
    if (_state is UploadFailed) {
      final fail = _state
          as UploadFailed; //TODO: wait for Dart proposal on field promotion or Enhanced Enum (Dart 2.15)
      return onUploadFailed?.call(_file, fail) ??
          UploadFailedWidget(
            _file,
            stateIconPosition: stateIconPosition,
            onMediaPreview: onMediaPreview,
            onRetryUpload: fileUploadHandlers.onRetryUpload,
            mediaType: fail.mediaType,
          );
    } else if (_state is UploadSuccess) {
      final success = _state as UploadSuccess;
      return onUploadSuccess?.call(_file, success) ??
          UploadSuccessWidget(
            _file,
            onMediaPreview: onMediaPreview,
            onRemoveUpload: fileUploadHandlers.onRemoveUpload,
            stateIconPosition: stateIconPosition,
            mediaType: success.mediaType,
          );
    } else if (_state is UploadProgress) {
      final progress = _state as UploadProgress;
      final totalBytes = progress.totalBytes;
      final sentBytes = progress.sentBytes;
      return onUploadProgress?.call(_file, progress) ??
          UploadProgressWidget(
            _file,
            stateIconPosition: stateIconPosition,
            onMediaPreview: onMediaPreview,
            totalBytes: totalBytes,
            sentBytes: sentBytes,
            onCancelUpload: fileUploadHandlers.onCancelUpload,
            mediaType: progress.mediaType,
          );
    }
    return UploadSuccessWidget(
      _file,
      onMediaPreview: onMediaPreview,
      stateIconPosition: stateIconPosition,
      onRemoveUpload: fileUploadHandlers.onRemoveUpload,
      mediaType: _state.mediaType,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FileUploadState>('fileState', fileState))
      ..add((DiagnosticsProperty<FileUploadHandlers>(
          'fileUploadHandlers', fileUploadHandlers)))
      ..add(EnumProperty<StateIconPosition>(
          'stateIconPosition', stateIconPosition))
      ..add(ObjectFlagProperty<OnMediaPreview?>.has(
          'onMediaPreview', onMediaPreview))
      ..add(ObjectFlagProperty<OnUploadSuccess?>.has(
          'onUploadSuccess', onUploadSuccess))
      ..add(ObjectFlagProperty<OnUploadProgress?>.has(
          'onUploadProgress', onUploadProgress))
      ..add(ObjectFlagProperty<OnUploadFailed?>.has(
          'onUploadFailed', onUploadFailed));
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    Key? key,
    required this.file,
    required this.mediaType,
  })  : assert(mediaType == MediaType.image || mediaType == MediaType.gif,
            'we only support images out of the box, please override onMediaPreview callback'),
        super(key: key);

  final AttachmentFile file;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Image.file(File(file.path!)),
    );
  }
}

class UploadSuccessWidget extends StatelessWidget {
  const UploadSuccessWidget(
    this.file, {
    Key? key,
    this.onMediaPreview,
    required this.onRemoveUpload,
    required this.stateIconPosition,
    required this.mediaType,
  }) : super(key: key);

  final AttachmentFile file;
  final OnMediaPreview? onMediaPreview;
  final OnRemoveUpload onRemoveUpload;
  final StateIconPosition stateIconPosition;
  final MediaType mediaType;

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
        child: const CircleAvatar(
          backgroundColor: Colors.black87,
          radius: 10,
          child: Icon(Icons.close, size: 12, color: Colors.white),
        ),
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
  late bool _isHover = false;

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
      stateIcon: _isHover
          ? InkWell(
              onTap: () {
                widget.onCancelUpload(widget.file);
              },
              onHover: (val) {
                setState(() {
                  _isHover = val;
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
                ),
              ),
            ),
    );
  }
}

class UploadFailedWidget extends StatelessWidget {
  const UploadFailedWidget(
    this.file, {
    Key? key,
    required this.onRetryUpload,
    this.onMediaPreview,
    required this.stateIconPosition,
    required this.mediaType,
  }) : super(key: key);

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
      ),
    );
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
        if (stateIconPosition == StateIconPosition.right)
          Positioned(
            right: 0,
            top: 0,
            child: stateIcon,
          )
        else
          Positioned(
            left: 0,
            top: 0,
            child: stateIcon,
          )
      ],
    );
  }
}
