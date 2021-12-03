import 'package:equatable/equatable.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/media.dart';

class FileUploadState with EquatableMixin {
  const FileUploadState({required this.file, required this.state});

  factory FileUploadState.fromEntry(
          MapEntry<AttachmentFile, UploadState> entry) =>
      FileUploadState(file: entry.key, state: entry.value);

  final AttachmentFile file;
  final UploadState state;

  @override
  List<Object> get props => [file, state];
}

class UploadState with EquatableMixin {
  const UploadState();
  @override
  List<Object> get props => [];
}

class UploadEmptyState extends UploadState {
  const UploadEmptyState();
}

class UploadFailed extends UploadState {
  const UploadFailed(this.error);
  final Object error;
  @override
  List<Object> get props => [error];
}

class UploadProgress extends UploadState {
  const UploadProgress({this.sentBytes = 0, this.totalBytes = 0});

  final int sentBytes;
  final int totalBytes;

  @override
  List<Object> get props => [sentBytes, totalBytes];
}

// class UploadRemoved extends UploadState {}

class UploadCancelled extends UploadState {}

class UploadSuccess extends UploadState {
  const UploadSuccess(this.media);
  final Media media;
  factory UploadSuccess.url( String url) =>
      UploadSuccess(Media(url: url));

  @override
  List<Object> get props => [media];
}
