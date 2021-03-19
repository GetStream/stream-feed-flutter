import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/cloud/cloud_image_storage_client.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';

class CloudImageStorageClientImpl implements CloudImageStorageClient {
  const CloudImageStorageClientImpl(this.token, this.images);
  final Token token;
  final ImagesApi images;

  @override
  Future<String?> upload(MultipartFile image) => images.upload(token, image);

  @override
  Future<void> delete(String url) => images.delete(token, url);

  @override
  Future<String?> get(String url) => images.get(token, url);

  @override
  Future<String?> getCropped(String url, Crop crop) =>
      images.get(token, url, options: crop.params);

  @override
  Future<String?> getResized(String url, Resize resize) =>
      images.get(token, url, options: resize.params);
}
