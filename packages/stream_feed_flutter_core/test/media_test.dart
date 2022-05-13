import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter_core/src/attachment.dart';
import 'package:stream_feed_flutter_core/src/media.dart';

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
    final mediaTypes =
        urls.map((url) => MediaUri(uri: Uri.tryParse(url)!).type).toList();
    expect(mediaTypes, [
      MediaType.image,
      MediaType.image,
      MediaType.image,
      MediaType.audio,
      MediaType.audio,
      MediaType.video,
      MediaType.video,
      MediaType.image,
    ]);
  });

  test('isValidUrl', () {
    final media = MediaUri(
      uri: Uri.tryParse(
          'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8')!,
    );

    expect(media.isValidUrl, true);
  });

  test('isValidUrl is false', () {
    final media = MediaUri(
      uri: Uri.tryParse('someurl.com/images/test')!,
    );

    expect(media.isValidUrl, false);
  });

  group('MediaUri', () {
    test('to Extra Data', () {
      final mediaUris = [
        MediaUri(
          uri: Uri.tryParse(
              'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8')!,
        )
      ];
      expect(mediaUris.toExtraData(), {
        'attachments': [
          {
            'url':
                'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8',
            'type': 'image'
          }
        ]
      });
    });

    test('to attachments', () {
      final rawAttachments = {
        'attachments': [
          {
            'url':
                'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8',
            'type': 'image'
          }
        ]
      };
      expect(rawAttachments.toAttachments(), [
        const Attachment(
          url:
              'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8',
          mediaType: MediaType.image,
        )
      ]);
    });
  });
}
