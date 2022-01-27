import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';

extension MapUpsert<K, V> on Map<K, V> {
  Map<K, V> upsert(K key, V value) {
    return this..update(key, (_) => value, ifAbsent: () => value);
  }
}

/// The upload controller manages all logic with the upload state of
/// attachments. Such as:
/// - a stream of the upload state, progress, error, result: [uploadsStream].
/// - uploading files and images: [uploadFile], [uploadImage], [uploadImages].
/// - remove uploads: [removeUpload]
/// - clear all uploads: [clear]
class UploadController {
  /// Creates a new upload controller to manage file/attachment uploads.
  UploadController(this.client);

  /// Store cancel token for each upload.
  late Map<AttachmentFile, CancelToken> cancelMap = {};

  /// Stream Feed Client.
  final StreamFeedClient client;

  /// A StreamController to keep the state of the uploads.
  @visibleForTesting
  late BehaviorSubject<Map<AttachmentFile, UploadState>> stateMap =
      BehaviorSubject.seeded({});

  /// The current attachment list as a stream.
  Stream<Map<AttachmentFile, UploadState>> get uploadsStream => stateMap.stream;

  /// Closes the controller
  void close() {
    stateMap.close();
  }

  /// Cancels the upload of the given [AttachmentFile]
  void cancelUpload(AttachmentFile attachmentFile) {
    final token = cancelMap[attachmentFile];
    token!.cancel('cancelled');
  }

  /// A smart method that will guess the type of the files and upload them
  /// using the correct storage method.
  Future<void> uploadMedias(List<AttachmentFile> attachmentFiles) async {
    await Future.wait(attachmentFiles.map(uploadMedia));
  }

  /// A smart method that will guess the type of the file and upload it
  /// using the correct storage method.
  Future<void> uploadMedia(AttachmentFile attachmentFile,
      [CancelToken? cancelToken]) async {
    //TODO: path doesn't exist
    final mediaUri = MediaUri(uri: Uri.file(attachmentFile.path!));

    mediaUri.type == MediaType.image
        ? uploadImage(attachmentFile, cancelToken)
        : uploadFile(attachmentFile, mediaUri.type, cancelToken);
  }

  /// Uploads the given [AttachmentFile] as a file (other than an image)
  Future<void> uploadFile(AttachmentFile attachmentFile, MediaType mediaType,
      [CancelToken? cancelToken]) async {
    _initController(attachmentFile, mediaType, cancelToken);
    try {
      final url = await client.files
          .upload(attachmentFile, cancelToken: cancelMap[attachmentFile],
              onSendProgress: (sentBytes, totalBytes) {
        final newState = stateMap.value.upsert(
            attachmentFile,
            UploadProgress(
              sentBytes: sentBytes,
              totalBytes: totalBytes,
              mediaType: mediaType,
            ));
        stateMap.add(newState);
      });
      final uri = Uri.tryParse(url ?? '');
      final newState = uri != null
          ? stateMap.value.upsert(
              attachmentFile,
              UploadSuccess.media(
                  mediaUri: MediaUri(uri: uri, mediaType: mediaType)),
            )
          : stateMap.value.upsert(attachmentFile,
              UploadFailed('Not a valid URI', mediaType: mediaType));
      stateMap.add(newState);
    } catch (e) {
      if (e is SocketException) {
        final newState = stateMap.value
            .upsert(attachmentFile, UploadFailed(e, mediaType: mediaType));
        stateMap.add(newState);
      }

      if (e is DioError && CancelToken.isCancel(e)) {
        final newState = stateMap.value
            .upsert(attachmentFile, UploadCancelled(mediaType: mediaType));
        stateMap.add(newState);
      }
    }
  }

  /// Upload several images.
  Future<void> uploadImages(List<AttachmentFile> attachmentFiles) async {
    await Future.wait(attachmentFiles.map(uploadImage));
  }

  /// Upload files of a specific type.
  Future<void> uploadFiles(
      List<AttachmentFile> attachmentFiles, MediaType mediaType) async {
    await Future.wait(attachmentFiles
        .map((attachmentFile) => uploadFile(attachmentFile, mediaType)));
  }

  /// Upload an image.
  Future<void> uploadImage(AttachmentFile attachmentFile,
      [CancelToken? cancelToken]) async {
    const mediaType = MediaType.image;
    _initController(attachmentFile, mediaType, cancelToken);
    try {
      final url = await client.images
          .upload(attachmentFile, cancelToken: cancelMap[attachmentFile],
              onSendProgress: (sentBytes, totalBytes) {
        final newState = stateMap.value.upsert(
            attachmentFile,
            UploadProgress(
                sentBytes: sentBytes,
                totalBytes: totalBytes,
                mediaType: mediaType));
        stateMap.add(newState);
      });
      final uri = Uri.tryParse(url ?? '');
      final newState = uri != null
          ? stateMap.value.upsert(
              attachmentFile,
              UploadSuccess.media(
                  mediaUri: MediaUri(uri: uri, mediaType: mediaType)),
            )
          : stateMap.value.upsert(attachmentFile,
              const UploadFailed('Not a valid URI', mediaType: mediaType));
      stateMap.add(newState);
    } catch (e) {
      if (e is SocketException) {
        final newState = stateMap.value
            .upsert(attachmentFile, UploadFailed(e, mediaType: mediaType));
        stateMap.add(newState);
      }

      if (e is DioError && CancelToken.isCancel(e)) {
        final newState = stateMap.value
            .upsert(attachmentFile, UploadCancelled(mediaType: mediaType));
        stateMap.add(newState);
      }
    }
  }

  /// Init the controller
  void _initController(AttachmentFile attachmentFile, MediaType mediaType,
      [CancelToken? cancelToken]) {
    final newState = stateMap.value
        .upsert(attachmentFile, UploadEmptyState(mediaType: mediaType));
    stateMap.add(newState);
    cancelMap[attachmentFile] = cancelToken ?? CancelToken();
  }

  /// Remove upload from controller and delete from cdn
  void removeUpload(AttachmentFile file) {
    final entry = stateMap.value[file];
    if (entry is UploadSuccess) {
      if (entry.mediaType == MediaType.image) {
        client.images.delete(entry.mediaUri.uri.toString());
      } else {
        client.files.delete(entry.mediaUri.uri.toString());
      }
    }
    final newMap = stateMap.value..remove(file);
    stateMap.add(newMap);
  }

  /// Clears all file uploads from the upload ontroller.
  void clear() {
    final newMap = stateMap.value..clear();
    stateMap.add(newMap);
  }

  /// Returns a list of uploads [MediaUri]s.
  List<MediaUri>? getMediaUris() {
    final successes = stateMap.value.values
        .map((state) => state)
        .toList()
        .whereType<UploadSuccess>();
    final mediaUris = successes.map((success) => success.mediaUri).toList();
    return mediaUris;
  }
}
