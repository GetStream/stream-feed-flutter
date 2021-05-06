import 'package:faye_dart/src/error.dart';
import 'package:test/test.dart';

void main() {
  test('should successfully parse error if it matches error grammar', () {
    final errorMessage = '405:bayeuxChannel:Invalid channel';
    final error = FayeClientError.parse(errorMessage);
    expect(error.code, 405);
    expect(error.params, ['bayeuxChannel']);
    expect(error.errorMessage, 'Invalid channel');
  });

  test(
    'should return same errorMessage if it does not matches error grammar',
    () {
      final errorMessage = 'dummy error message';
      final error = FayeClientError.parse(errorMessage);
      expect(error.code, isNull);
      expect(error.params, isEmpty);
      expect(error.errorMessage, errorMessage);
    },
  );

  test('should print error as a String', () {
    final errorMessage = '405:bayeuxChannel:Invalid channel';
    final error = FayeClientError.parse(errorMessage);
    expect(
      error.toString(),
      '${error.code} : ${error.params.join(',')} : ${error.errorMessage}',
    );
  });
}
