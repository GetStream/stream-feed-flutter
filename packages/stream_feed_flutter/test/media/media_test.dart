import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('mediaType works on all file formats', () {
    test('jpeg', () {
      final jpegMedia = Media(
        url: 'https://someurl.com/images/test.jpeg',
      );

      expect(MediaType.image, jpegMedia.mediaType);
    });

    test('jpg', () {
      final jpgMedia = Media(
        url: 'https://someurl.com/images/test.jpg',
      );

      expect(MediaType.image, jpgMedia.mediaType);
    });

    test('png', () {
      final pngMedia = Media(
        url: 'https://someurl.com/images/test.png',
      );

      expect(MediaType.image, pngMedia.mediaType);
    });

    test('mp3', () {
      final mp3Media = Media(
        url: 'https://someurl.com/audio/test.mp3',
      );

      expect(MediaType.audio, mp3Media.mediaType);
    });

    test('wav', () {
      final wavMedia = Media(
        url: 'https://someurl.com/audio/test.wav',
      );

      expect(MediaType.audio, wavMedia.mediaType);
    });

    test('mp4', () {
      final mp4Media = Media(
        url: 'https://someurl.com/video/test.mp4',
      );

      expect(MediaType.video, mp4Media.mediaType);
    });

    test('unknown/unsupported', () {
      final mp4Media = Media(
        url: 'https://someurl.com/media/test.mov',
      );

      expect(MediaType.unknown, mp4Media.mediaType);
    });
  });
}
