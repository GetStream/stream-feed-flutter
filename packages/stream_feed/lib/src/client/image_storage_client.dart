import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/api/images_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/index.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// Image and files have separate clients
/// (e.g. images can be resized, whereas files cannot).
///
/// Once the upload is completed the URL of the file/image is returned and is ready for use.
///
/// The returned URL is served via CDN and can be requested by anyone.
///
/// In order to avoid resource enumeration attacks,
/// a unique signature is added.
/// Manipulating the returned URL will likely result in HTTP errors.
class ImageStorageClient {
  ///Initialize a [ImageStorageClient] object
  ImageStorageClient(this._images, {this.userToken, this.secret})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  /// Your API secret
  final String? secret;

  /// Your user token obtain via the dashboard.
  /// Required if you are using the sdk client side
  final Token? userToken;
  final ImagesAPI _images;

  /// Uploading an image
  /// input is a [MultipartFile]
  ///
  /// # Example
  /// ```dart
  /// final image = File('...');
  /// var multipartFile = await MultipartFile.fromFile(
  ///   image.path,
  ///   filename: 'my-photo',
  ///   contentType: MediaType('image', 'jpeg'),
  /// );
  /// await client.images.upload(multipartFile);
  /// ```
  /// API docs: https://getstream.io/activity-feeds/docs/flutter-dart/files_introduction/?q=Image
  Future<String?> upload(MultipartFile image) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.write);
    return _images.upload(token, image);
  }

  /// Images can be deleted using their URL.
  /// # Examples

  /// - deleting an image using the url returned by the APIs
  /// ```dart
  /// client.images.delete(imageURL);
  /// ```
  Future<void> delete(String url) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.delete);
    return _images.delete(token, url);
  }

  /// Images can be obtained using their URL.
  ///   - obtain an image using the url returned by the APIs
  /// ```dart
  /// client.images.get(imageURL);
  /// ```
  Future<String?> get(String url) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.read);
    return _images.get(token, url);
  }

  /// Crop an image using its URL. A new URL is then returned by the API.
  /// # Examples:
  ///
  /// - create a 50x50 thumbnail and crop from center
  /// ```dart
  ///await client.images.getCropped(
  ///  'imageUrl',
  ///  const Crop(50, 50),
  ///);
  /// ```
  Future<String?> getCropped(String url, Crop crop) =>
      _process(url, crop.params);

  /// Resize an image using its URL. A new URL is then returned by the API.
  /// # Examples:
  /// - create a 50x50 thumbnail using clipping (keeps aspect ratio)
  /// ```dart
  /// await client.images.getResized(
  ///   'imageUrl',
  ///   const Resize(50, 50),
  /// );
  /// ```
  Future<String?> getResized(String url, Resize resize) =>
      _process(url, resize.params);

  Future<String?> _process(String url, Map<String, Object?> params) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.read);
    return _images.get(token, url, options: params);
  }

  ///Generate a thumbnail for a given image url
  Future<String?> thumbnail(String url, int w, int h,
          {CropType? crop = CropType.center,
          ResizeType resize = ResizeType.clip}) =>
      _process(url, {
        'w': w,
        'h': h,
        'crop': crop,
        'resize': resize,
      });
}
