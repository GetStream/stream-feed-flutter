import 'dart:io';

import 'package:stream_feed_dart/version.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('stream feed version matches pubspec', () {
    final String pubspecPath = '${currentDirectory.path}/pubspec.yaml';
    final String pubspec = File(pubspecPath).readAsStringSync();
    final RegExp regex = RegExp('version:\s*(.*)');
    final RegExpMatch match = regex.firstMatch(pubspec);
    expect(match, isNotNull);
    expect(PACKAGE_VERSION, match.group(1).trim());
  });
}
