import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('mediaType works on all file formats', () {
    final urls = [
      'https://someurl.com/images/test.jpeg',
      'https://someurl.com/images/test.jpg',
      'https://someurl.com/images/test.png',
      'https://someurl.com/audio/test.mp3',
      'https://someurl.com/audio/test.wav',
      'https://someurl.com/video/test.mp4',
      'https://someurl.com/media/test.mov',
      'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw'
    ];
    final mediaTypes = urls.map((url) => Media(url: url).mediaType).toList();
    expect(mediaTypes, [
      MediaType.image,
      MediaType.image,
      MediaType.image,
      MediaType.audio,
      MediaType.audio,
      MediaType.video,
      MediaType.unknown,
      MediaType.image,
    ]);
  });

  test('isValidUrl', () {
    final media = Media(
      url:
          'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8',
    );

    expect(media.isValidUrl, true);
  });

  test('isValidUrl is false', () {
    final media = Media(
      url: 'someurl.com/images/test',
    );

    expect(media.isValidUrl, false);
  });
}
