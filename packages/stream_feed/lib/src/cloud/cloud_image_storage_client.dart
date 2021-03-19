import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';

class CloudImageStorageClient {
  const CloudImageStorageClient(this.token, this.images);
  final Token token;
  final ImagesApi images;

  
  Future<String?> upload(MultipartFile image) => images.upload(token, image);

  
  Future<void> delete(String url) => images.delete(token, url);

  
  Future<String?> get(String url) => images.get(token, url);

  
  Future<String?> getCropped(String url, Crop crop) =>
      images.get(token, url, options: crop.params);

  
  Future<String?> getResized(String url, Resize resize) =>
      images.get(token, url, options: resize.params);
}
