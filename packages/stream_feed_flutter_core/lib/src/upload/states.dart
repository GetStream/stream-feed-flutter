import 'package:equatable/equatable.dart';
import 'package:stream_feed/stream_feed.dart';

class FileUploadState with EquatableMixin {
  const FileUploadState({required this.file, required this.state});

  factory FileUploadState.fromEntry(MapEntry entry) =>
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

class UploadCancelled extends UploadState {}

class UploadSuccess extends UploadState {
  const UploadSuccess(this.url);
  final String url;

  @override
  List<Object> get props => [url];
}
