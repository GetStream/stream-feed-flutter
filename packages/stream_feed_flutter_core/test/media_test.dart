import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter_core/src/media.dart';

void main() {
  test('url', () {
    final url =
        'https://us-east.stream-io-cdn.com/1147834/attachments/b3a65dc8-4485-4eff-aba8-4c818b5061d7.image_picker_2C9E1754-CA5A-483D-89DB-B7.png?dl=image_picker_2C9E1754-CA5A-483D-89DB-B7.pdf&Expires=1639509073&Signature=eCguUW3Q5jXll0iELX73NIuUH2B9yx8A2nGZNskO6WDCsbrjid~EekK67PELq8MIIWJiVJsFxQQDwSUSoJrdrHHI3zoyc7fOxAKvnpDsiXxzhVZBNBJqaQUL7vJEK1vvRFoLICmuo-5XfvZeaf7j~opSoV9DkWqAj51GulTgDe-VlurksLaqfDq98xwkxiHSdqbGJJwfKRDfce79Zt1oDXHjBYhs7QTKPkIlSp-8XkMUQdVw0mk-wJbCREcj8J901K35k6cWR-HvMd1JBlT9nADkWOGzOy4FJfcrgvfxjgHerG0CDlYXhHCA0xDdHnRaY5BIUmZugtcWIeVm469Zxg__&Key-Pair-Id=APKAIHG36VEWPDULE23Q';
    final media = MediaUri(uri: Uri.tryParse(url)!);
    expect(media.type, MediaType.image);
  });
}
