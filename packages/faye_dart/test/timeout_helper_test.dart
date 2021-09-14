// ignore_for_file: cascade_invocations

import 'package:faye_dart/src/timeout_helper.dart';
import 'package:test/test.dart';

void main() {
  test('setTimeout', () {
    final timeoutHelper = TimeoutHelper();
    expect(timeoutHelper.hasTimeouts, isFalse);
    timeoutHelper.setTimeout(const Duration(seconds: 3), () {});
    expect(timeoutHelper.hasTimeouts, isTrue);

    addTearDown(timeoutHelper.cancelAllTimeout);
  });

  test('cancelTimeout', () {
    final timeoutHelper = TimeoutHelper();
    expect(timeoutHelper.hasTimeouts, isFalse);
    final id = timeoutHelper.setTimeout(const Duration(seconds: 3), () {});
    expect(timeoutHelper.hasTimeouts, isTrue);
    timeoutHelper.cancelTimeout(id);
    expect(timeoutHelper.hasTimeouts, isFalse);
  });

  test('cancelTimeouts', () {
    final timeoutHelper = TimeoutHelper();
    expect(timeoutHelper.hasTimeouts, isFalse);
    timeoutHelper.setTimeout(const Duration(seconds: 3), () {});
    timeoutHelper.setTimeout(const Duration(seconds: 6), () {});
    timeoutHelper.setTimeout(const Duration(seconds: 9), () {});
    expect(timeoutHelper.hasTimeouts, isTrue);
    timeoutHelper.cancelAllTimeout();
    expect(timeoutHelper.hasTimeouts, isFalse);
  });
}
