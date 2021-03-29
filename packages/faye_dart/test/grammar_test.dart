import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/grammar.dart';
import 'package:test/test.dart';

main() {
  group('Grammar', () {
    test('matches valid channel names', () {
      expect(Channel.isValid("/fo_o/\$@()bar"), true);
    });

    test('does not match invalid channel names', () {
      expect(Channel.isValid("foo/\$@()bar"), false);
      expect(Channel.isValid("/foo/\$@()bar/"), false);
      expect(Channel.isValid("/fo o/\$@()bar"), false);
    });
  });
}
