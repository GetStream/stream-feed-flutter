import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// A convenience widget to easily display the state of a file upload.
///
/// ```dart
/// return FileUploadStateWidget(
///   fileState: uploads[index],
///   onRemoveUpload: (attachment) {
///     return uploadController.removeUpload(attachment);
///   },
///   onCancelUpload: (attachment) {
///     uploadController.cancelUpload(attachment);
///   },
///   onRetryUpload: (attachment) async {
///     return uploadController.uploadImage(attachment);
///   },
/// );
/// ```
class FileUploadStateWidget extends StatelessWidget {
  /// Create a new [FileUploadStateWidget].
  ///
  /// Customize view by providing:
  /// - [mediaPreviewBuilder]
  /// - [uploadSuccessBuilder]
  /// - [uploadProgressBuilder]
  /// - [uploadFailedBuilder]
  ///
  /// These handlers are required to define behaviour:
  /// - [onRetryUpload] - retry upload callback
  /// - [onCancelUpload] - cancel upload callback
  /// - [onRemoveUpload] - remove upload callback
  const FileUploadStateWidget({
    Key? key,
    required this.fileState,
    required this.onRetryUpload,
    required this.onCancelUpload,
    required this.onRemoveUpload,
    this.stateIconPosition = StateIconPosition.left,
    this.mediaPreviewBuilder,
    this.uploadSuccessBuilder,
    this.uploadProgressBuilder,
    this.uploadFailedBuilder,
  }) : super(key: key);

  /// The state of the file upload.
  final FileUploadState fileState;
  final OnRetryUpload onRetryUpload;
  final OnCancelUpload onCancelUpload;
  final OnRemoveUpload onRemoveUpload;

  final StateIconPosition stateIconPosition;

  final MediaPreviewBuilder? mediaPreviewBuilder;
  final UploadSuccessBuilder? uploadSuccessBuilder;
  final UploadProgressBuilder? uploadProgressBuilder;
  final UploadFailedBuilder? uploadFailedBuilder;

  UploadState get _state => fileState.state;
  AttachmentFile get _file => fileState.file;

  @override
  Widget build(BuildContext context) {
    if (_state is UploadFailed) {
      final fail = _state
          as UploadFailed; //TODO: wait for Dart proposal on field promotion or Enhanced Enum (Dart 2.15)
      return uploadFailedBuilder?.call(_file, fail) ??
          UploadFailedWidget(
            _file,
            stateIconPosition: stateIconPosition,
            mediaPreviewBuilder: mediaPreviewBuilder,
            onRetryUpload: onRetryUpload,
            mediaType: fail.mediaType,
          );
    } else if (_state is UploadSuccess) {
      final success = _state as UploadSuccess;
      return uploadSuccessBuilder?.call(_file, success) ??
          UploadSuccessWidget(
            _file,
            mediaPreviewBuilder: mediaPreviewBuilder,
            onRemoveUpload: onRemoveUpload,
            stateIconPosition: stateIconPosition,
            mediaType: success.mediaType,
          );
    } else if (_state is UploadProgress) {
      final progress = _state as UploadProgress;
      final totalBytes = progress.totalBytes;
      final sentBytes = progress.sentBytes;
      return uploadProgressBuilder?.call(_file, progress) ??
          UploadProgressWidget(
            _file,
            stateIconPosition: stateIconPosition,
            mediaPreviewBuilder: mediaPreviewBuilder,
            totalBytes: totalBytes,
            sentBytes: sentBytes,
            onCancelUpload: onCancelUpload,
            mediaType: progress.mediaType,
          );
    }
    return UploadSuccessWidget(
      _file,
      mediaPreviewBuilder: mediaPreviewBuilder,
      stateIconPosition: stateIconPosition,
      onRemoveUpload: onRemoveUpload,
      mediaType: _state.mediaType,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FileUploadState>('fileState', fileState))
      ..add(
          ObjectFlagProperty<OnRetryUpload>.has('onRetryUpload', onRetryUpload))
      ..add(ObjectFlagProperty<OnCancelUpload>.has(
          'onCancelUpload', onCancelUpload))
      ..add(ObjectFlagProperty<OnRemoveUpload>.has(
          'onRemoveUpload', onRemoveUpload))
      ..add(EnumProperty<StateIconPosition>(
          'stateIconPosition', stateIconPosition))
      ..add(ObjectFlagProperty<MediaPreviewBuilder?>.has(
          'onMediaPreview', mediaPreviewBuilder))
      ..add(ObjectFlagProperty<UploadSuccessBuilder?>.has(
          'onUploadSuccess', uploadSuccessBuilder))
      ..add(ObjectFlagProperty<UploadProgressBuilder?>.has(
          'onUploadProgress', uploadProgressBuilder))
      ..add(ObjectFlagProperty<UploadFailedBuilder?>.has(
          'onUploadFailed', uploadFailedBuilder));
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    Key? key,
    required this.file,
    required this.mediaType,
  })  : assert(mediaType == MediaType.image || mediaType == MediaType.gif,
            '''we only support images out of the box, please override mediaPreviewBuilder callback'''),
        super(key: key);

  final AttachmentFile file;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Image.file(File(file.path!)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AttachmentFile>('file', file))
      ..add(EnumProperty<MediaType>('mediaType', mediaType));
  }
}

class UploadSuccessWidget extends StatelessWidget {
  const UploadSuccessWidget(
    this.file, {
    Key? key,
    this.mediaPreviewBuilder,
    required this.onRemoveUpload,
    required this.stateIconPosition,
    required this.mediaType,
  }) : super(key: key);

  final AttachmentFile file;

  final MediaPreviewBuilder? mediaPreviewBuilder;
  final OnRemoveUpload onRemoveUpload;
  final StateIconPosition stateIconPosition;
  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
      mediaPreview: mediaPreviewBuilder?.call(file, mediaType) ??
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AttachmentFile>('file', file))
      ..add(ObjectFlagProperty<MediaPreviewBuilder?>.has(
          'mediaPreviewBuilder', mediaPreviewBuilder))
      ..add(ObjectFlagProperty<OnRemoveUpload>.has(
          'onRemoveUpload', onRemoveUpload))
      ..add(EnumProperty<StateIconPosition>(
          'stateIconPosition', stateIconPosition))
      ..add(EnumProperty<MediaType>('mediaType', mediaType));
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
    this.mediaPreviewBuilder,
  }) : super(key: key);

  final AttachmentFile file;
  final int totalBytes;
  final int sentBytes;
  final OnCancelUpload onCancelUpload;
  final StateIconPosition stateIconPosition;
  final MediaType mediaType;
  final MediaPreviewBuilder? mediaPreviewBuilder;

  @override
  State<UploadProgressWidget> createState() => _UploadProgressWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AttachmentFile>('file', file))
      ..add(IntProperty('totalBytes', totalBytes))
      ..add(IntProperty('sentBytes', sentBytes))
      ..add(ObjectFlagProperty<OnCancelUpload>.has(
          'onCancelUpload', onCancelUpload))
      ..add(EnumProperty<StateIconPosition>(
          'stateIconPosition', stateIconPosition))
      ..add(EnumProperty<MediaType>('mediaType', mediaType))
      ..add(ObjectFlagProperty<MediaPreviewBuilder?>.has(
          'mediaPreviewBuilder', mediaPreviewBuilder));
  }
}

class _UploadProgressWidgetState extends State<UploadProgressWidget> {
  late bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
      stateIconPosition: widget.stateIconPosition,
      mediaPreview:
          widget.mediaPreviewBuilder?.call(widget.file, widget.mediaType) ??
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
    required this.stateIconPosition,
    required this.mediaType,
    this.mediaPreviewBuilder,
  }) : super(key: key);

  final AttachmentFile file;
  final OnRetryUpload onRetryUpload;
  final StateIconPosition stateIconPosition;
  final MediaType mediaType;
  final MediaPreviewBuilder? mediaPreviewBuilder;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
      stateIconPosition: stateIconPosition,
      mediaPreview: mediaPreviewBuilder?.call(file, mediaType) ??
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AttachmentFile>('file', file))
      ..add(
          ObjectFlagProperty<OnRetryUpload>.has('onRetryUpload', onRetryUpload))
      ..add(EnumProperty<StateIconPosition>(
          'stateIconPosition', stateIconPosition))
      ..add(EnumProperty<MediaType>('mediaType', mediaType))
      ..add(ObjectFlagProperty<MediaPreviewBuilder?>.has(
          'mediaPreviewBuilder', mediaPreviewBuilder));
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<StateIconPosition>(
        'stateIconPosition', stateIconPosition));
  }
}
