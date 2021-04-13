import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class ImageStorageClient {
  ImageStorageClient(this.images,
      {this.userToken, this.secret, this.tokenHelper})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );
  final String? secret;
  final Token? userToken;
  late TokenHelper? tokenHelper = TokenHelper();
  final ImagesApi images;

  Future<String?> upload(MultipartFile image) {
    final token =
        userToken ?? tokenHelper!.buildFilesToken(secret!, TokenAction.write);
    return images.upload(token, image);
  }

  Future<void> delete(String url) {
    final token =
        userToken ?? tokenHelper!.buildFilesToken(secret!, TokenAction.delete);
    return images.delete(token, url);
  }

  Future<String?> get(String url) {
    final token =
        userToken ?? tokenHelper!.buildFilesToken(secret!, TokenAction.read);
    return images.get(token, url);
  }

  Future<String?> getCropped(String url, Crop crop) {
    final token =
        userToken ?? tokenHelper!.buildFilesToken(secret!, TokenAction.read);
    return images.get(token, url, options: crop.params);
  }

  Future<String?> getResized(String url, Resize resize) {
    final token =
        userToken ?? tokenHelper!.buildFilesToken(secret!, TokenAction.read);
    return images.get(token, url, options: resize.params);
  }
}
