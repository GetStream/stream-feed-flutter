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

class UploadController {
  UploadController(this.client);
  late Map<AttachmentFile, CancelToken> cancelMap = {};
  final StreamFeedClient client;

  @visibleForTesting
  late BehaviorSubject<Map<AttachmentFile, UploadState>> stateMap =
      BehaviorSubject.seeded({});

  Stream<Map<AttachmentFile, UploadState>> get uploadsStream => stateMap.stream;

  void close() {
    stateMap.close();
  }

  void cancelUpload(AttachmentFile attachmentFile) {
    final token = cancelMap[attachmentFile];
    token!.cancel('cancelled');
  }

  /// Convenient method to upload a media
  /// Let you override the media type
  /// If you have a file picker per media for example
  /// it's safer to override the mediaType
  /// otherwise will guess it from the file extension
  Future<void> uploadMedia(AttachmentFile attachmentFile,
      [MediaType? mediaType, CancelToken? cancelToken]) async {
    final mediaUri =
        MediaUri(uri: Uri.file(attachmentFile.path!), mediaType: mediaType);

    mediaUri.type == MediaType.image
        ? uploadImage(attachmentFile, cancelToken)
        : uploadFile(attachmentFile, mediaUri.type, cancelToken);
  }

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
              UploadFailed('Not a valid uri', mediaType: mediaType));
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

  Future<void> uploadImages(List<AttachmentFile> attachmentFiles) async {
    await Future.wait(attachmentFiles.map(uploadImage));
  }

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
              UploadFailed('Not a valid uri', mediaType: mediaType));
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

  void _initController(AttachmentFile attachmentFile, MediaType mediaType,
      [CancelToken? cancelToken]) {
    final newState = stateMap.value
        .upsert(attachmentFile, UploadEmptyState(mediaType: mediaType));
    stateMap.add(newState);
    cancelMap[attachmentFile] = cancelToken ?? CancelToken();
  }

  /// Remove upload from controller and from cdn
  void removeUpload(AttachmentFile file) {
    final entry = stateMap.value[file];
    if (entry is UploadSuccess) {
      if(entry.mediaType == MediaType.image) {
        client.images.delete(entry.mediaUri.uri.toString());
      } else {
        client.files.delete(entry.mediaUri.uri.toString());
      }
    }
    final newMap = stateMap.value..remove(file);
    stateMap.add(newMap);
  }

  void clear() {
    final newMap = stateMap.value..clear();
    stateMap.add(newMap);
  }

  /// Get urls
  List<MediaUri> getMediaUris() {
    final successes = stateMap.value.values
        .map((state) => state)
        .toList()
        .whereType<UploadSuccess>();
    final mediaUris = successes.map((success) => success.mediaUri).toList();
    return mediaUris;
  }
}
