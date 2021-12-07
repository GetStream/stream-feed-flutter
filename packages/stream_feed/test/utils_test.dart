import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/serializer.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';
import 'package:test/test.dart';

void main() {
  group('extension', () {
    test('nullProtected', () {
      expect({null: 'nullKey'}.nullProtected, {});
      expect({'nullValue': null}.nullProtected, {});
    });
    test('checkNotNull', () {
      expect(
          () => checkNotNull(null, 'your custom message'),
          throwsA(predicate<ArgumentError>(
              (e) => e.message == 'your custom message')));
    });
    test('checkArgument', () {
      expect(
          () => checkArgument(false, 'your custom message'),
          throwsA(predicate<ArgumentError>(
              (e) => e.message == 'your custom message')));
    });
    group('mimeType', () {
      test('should return null if `String` is not a filename', () {
        const fileName = 'not-a-file-name';
        final mimeType = fileName.mimeType;
        expect(mimeType, isNull);
      });

      test('should return mimeType if string is a filename', () {
        const fileName = 'dummyFileName.jpeg';
        final mimeType = fileName.mimeType;
        expect(mimeType, isNotNull);
        expect(mimeType!.type, 'image');
        expect(mimeType.subtype, 'jpeg');
      });

      test('should return `image/heic` if ends with `heic`', () {
        const fileName = 'dummyFileName.heic';
        final mimeType = fileName.mimeType;
        expect(mimeType, isNotNull);
        expect(mimeType!.type, 'image');
        expect(mimeType.subtype, 'heic');
      });
    });
  });

  group('Serializer', () {
    test('moveKeysToMapInPlace', () {
      final serializer =
          Serializer.moveKeysToMapInPlace({'test': 'test'}, ['test']);
      expect(serializer, {'test': 'test'});
    });

    test('moveKeysToMapInPlace', () {
      final serializer = Serializer.moveKeysToRoot({'test': 'test'}, ['test']);
      expect(serializer, {'test': 'test', 'extra_data': {}});
    });
  });

  group('DateTimeUTConverter', () {
    const converter = DateTimeUTCConverter();
    test('fromJson sample 1', () {
      const rawDate = '2021-05-26T14:23:33.918391';
      final convertedDate = converter.fromJson(rawDate);
      expect(convertedDate.isUtc, true);
    });

    test('fromJson sample 2', () {
      const rawDate = '2021-05-14T19:58:27.274792063Z';
      final convertedDate = converter.fromJson(rawDate);
      expect(convertedDate.isUtc, true); //
    });
  });
}
