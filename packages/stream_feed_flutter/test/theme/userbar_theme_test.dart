import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('UserBarThemeData copyWith, ==, hashCode basics', () {
    expect(const UserBarThemeData(),
        const UserBarThemeData().copyWith());
    expect(const UserBarThemeData().hashCode,
        const UserBarThemeData().copyWith().hashCode);
  });

  test('UserBarThemeData lerps halfway', () {
    expect(
        const UserBarThemeData()
            .lerp(_userBarThemeDefault, _userBarThemeFullLerp, 0.5),
        _userBarThemeHalfLerp);
  });
}

const _userBarThemeDefault = UserBarThemeData(
  usernameTextStyle: TextStyle(
    color: Color(0xff0ba8e0),
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ),
  timestampTextStyle: TextStyle(
    color: Color(0xff7a8287),
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontSize: 14,
  ),
  avatarSize: 46,
);

const _userBarThemeHalfLerp = UserBarThemeData(
  usernameTextStyle: TextStyle(
    color: Color(0xff7f758b),
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ),
  timestampTextStyle: TextStyle(
    color: Color(0xff8c9092),
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontSize: 14,
  ),
  avatarSize: 46,
);

const _userBarThemeFullLerp = UserBarThemeData(
  usernameTextStyle: TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ),
  timestampTextStyle: TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontSize: 14,
  ),
  avatarSize: 46,
);
