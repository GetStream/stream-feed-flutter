import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/bloc/upload_controller.dart';

typedef OnUploadSuccess = Widget Function(UploadSuccess success);

class FileUploadState extends StatelessWidget {
  const FileUploadState(
      {Key? key, this.state = const UploadEmptyState(), this.onUploadSuccess})
      : super(key: key);
  final UploadState state;

  final OnUploadSuccess? onUploadSuccess;

  @override
  Widget build(BuildContext context) {
    // UploadProgress success;
    if (state is UploadFailed) {
      return UploadFailedWidget();
    } else if (state is UploadSuccess) {
      final success = state  as UploadSuccess;
      return onUploadSuccess?.call(success) ?? UploadSuccessWidget();
    } else if (state is UploadProgress) {
      final progress = state  as UploadProgress;
      final totalBytes = progress.totalBytes;
      final sentBytes = progress.sentBytes;
      return UploadProgressWidget(totalBytes: totalBytes, sentBytes: sentBytes);
    }
    return UploadSuccessWidget();
  }
}

class UploadSuccessWidget extends StatelessWidget {
  const UploadSuccessWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(stateIcon: Icon(Icons.check_circle));
  }
}

class UploadProgressWidget extends StatelessWidget {
  const UploadProgressWidget({
    Key? key,
    required this.totalBytes,
    required this.sentBytes,
  }) : super(key: key);

  final int totalBytes;
  final int sentBytes;

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(
        stateIcon: CircularProgressIndicator(
      value: (totalBytes - sentBytes) / totalBytes,
    ));
  }
}

class UploadFailedWidget extends StatelessWidget {
  const UploadFailedWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FileUploadStateIcon(stateIcon: Icon(Icons.cancel_outlined));
  }
}

class FileUploadStateIcon extends StatelessWidget {
  final Widget stateIcon;
  const FileUploadStateIcon({Key? key, required this.stateIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(Icons.file_present),
        Positioned(
          right: 0,
          top: 0,
          child: stateIcon,
        )
      ],
    );
  }
}
