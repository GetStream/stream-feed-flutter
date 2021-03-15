import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/models/crop.dart';
import 'package:stream_feed_dart/src/core/models/resize.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

import 'package:stream_feed_dart/src/client/image_storage_client.dart';

class ImageStorageClientImpl implements ImageStorageClient {
  const ImageStorageClientImpl(this.secret, this.images);
  final String secret;
  final ImagesApi images;

  @override
  Future<String?> upload(MultipartFile image) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.write);
    return images.upload(token, image);
  }

  @override
  Future<void> delete(String url) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.delete);
    return images.delete(token, url);
  }

  @override
  Future<String?> get(String url) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.read);
    return images.get(token, url);
  }

  @override
  Future<String?> getCropped(String url, Crop crop) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.read);
    return images.get(token, url, options: crop.params);
  }

  @override
  Future<String?> getResized(String url, Resize resize) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.read);
    return images.get(token, url, options: resize.params);
  }
}
