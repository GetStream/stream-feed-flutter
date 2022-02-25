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
  const UploadState({required this.mediaType});
  final MediaType mediaType;
  @override
  List<Object> get props => [mediaType];
}

class UploadEmptyState extends UploadState {
  const UploadEmptyState({required MediaType mediaType})
      : super(mediaType: mediaType);
}

class UploadFailed extends UploadState {
  const UploadFailed(this.error, {required MediaType mediaType})
      : super(mediaType: mediaType);
  final Object error;
  @override
  List<Object> get props => [...super.props, error];
}

class UploadProgress extends UploadState {
  const UploadProgress(
      {this.sentBytes = 0, this.totalBytes = 0, required MediaType mediaType})
      : super(mediaType: mediaType);

  final int sentBytes;
  final int totalBytes;

  @override
  List<Object> get props => [...super.props, sentBytes, totalBytes];
}

class UploadCancelled extends UploadState {
  UploadCancelled({required MediaType mediaType}) : super(mediaType: mediaType);
}

class UploadSuccess extends UploadState {
  const UploadSuccess._({required this.mediaUri, required MediaType mediaType})
      : super(mediaType: mediaType);

  factory UploadSuccess.media({required MediaUri mediaUri}) {
    return UploadSuccess._(mediaUri: mediaUri, mediaType: mediaUri.type);
  }

  final MediaUri mediaUri;

  @override
  List<Object> get props => [...super.props, mediaUri];
}
