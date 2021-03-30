import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class ImageStorageClient {
  const ImageStorageClient(this.images, {this.userToken, this.secret});
  final String? secret;
  final Token? userToken;
  final ImagesApi images;

  Future<String?> upload(MultipartFile image) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.write);
    return images.upload(token, image);
  }

  Future<void> delete(String url) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.delete);
    return images.delete(token, url);
  }

  Future<String?> get(String url) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.read);
    return images.get(token, url);
  }

  Future<String?> getCropped(String url, Crop crop) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.read);
    return images.get(token, url, options: crop.params);
  }

  Future<String?> getResized(String url, Resize resize) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.read);
    return images.get(token, url, options: resize.params);
  }
}
