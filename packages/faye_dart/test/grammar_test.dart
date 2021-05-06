import 'package:faye_dart/src/grammar.dart' as grammar;
import 'package:test/test.dart';

main() {
  group('grammar', () {
    group('channelName', () {
      final channelName = RegExp(grammar.channelName);
      test('matches valid channel names', () {
        expect(channelName.hasMatch("/fo_o/\$@()bar"), isTrue);
      });

      test('does not match channel patterns', () {
        expect(channelName.hasMatch("/foo/**"), isFalse);
      });

      test('does not match invalid channel names', () {
        expect(channelName.hasMatch("foo/\$@()bar"), isFalse);
        expect(channelName.hasMatch("/foo/\$@()bar/"), isFalse);
        expect(channelName.hasMatch("/fo o/\$@()bar"), isFalse);
      });
    });

    group('channelPattern', () {
      final channelPattern = RegExp(grammar.channelPattern);
      test('does not match channel names', () {
        expect(channelPattern.hasMatch("/fo_o/\$@()bar"), isFalse);
      });

      test('matches valid channel patterns', () {
        expect(channelPattern.hasMatch("/foo/**"), isTrue);
        expect(channelPattern.hasMatch("/foo/*"), isTrue);
      });

      test('does not match invalid channel patterns', () {
        expect(channelPattern.hasMatch("/foo/**/*"), isFalse);
      });
    });

    group('error', () {
      final error = RegExp(grammar.error);
      test("matches an error with an argument", () {
        expect(error.hasMatch("402:bayeuxChannel:Unknown Client ID"), isTrue);
      });

      test('matches an error with many arguments', () {
        expect(
          error.hasMatch("403:bayeuxChannel,/foo/bar:Subscription denied"),
          isTrue,
        );
      });

      test('matches an error with no arguments', () {
        expect(error.hasMatch("402::Unknown Client ID"), isTrue);
      });

      test('does not match an error with no code', () {
        expect(error.hasMatch(":bayeuxChannel:Unknown Client ID"), isFalse);
      });

      test('does not match an error with an invalid code', () {
        expect(error.hasMatch("40:bayeuxChannel:Unknown Client ID"), isFalse);
      });
    });

    group('version', () {
      final version = RegExp(grammar.version);
      test('matches a version number', () {
        expect(version.hasMatch("9"), isTrue);
        expect(version.hasMatch("9.0.a-delta1"), isTrue);
      });

      test('does not match invalid version numbers', () {
        expect(version.hasMatch("9.0.a-delta1."), isFalse);
        expect(version.hasMatch(""), isFalse);
      });
    });
  });
}
