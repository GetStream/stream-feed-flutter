import 'dart:io';

import 'package:stream_feed_dart/version.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('stream feed version matches pubspec', () {
    final pubspecPath = '${currentDirectory.path}/pubspec.yaml';
    final pubspec = File(pubspecPath).readAsStringSync();
    final regex = RegExp('version:\s*(.*)');
    final match = regex.firstMatch(pubspec)!;
    expect(match, isNotNull);
    expect(PACKAGE_VERSION, match.group(1)!.trim());
  });
}
