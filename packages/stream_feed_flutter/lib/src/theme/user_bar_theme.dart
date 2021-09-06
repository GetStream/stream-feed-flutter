import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';

// ignore_for_file: cascade_invocations

/// Overrides the default style of [UserBar] and [CommentItem] descendants.
///
/// See also:
///
///  * [UserBarThemeData], which is used to configure this theme.
class UserBarTheme extends InheritedTheme {
  /// Builds a [GifDialogTheme].
  const UserBarTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final UserBarThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [UserBarTheme] widget, then
  /// [StreamFeedThemeData.userBarTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = UserBarTheme.of(context);
  /// ```
  static UserBarThemeData of(BuildContext context) {
    final userBarTheme =
        context.dependOnInheritedWidgetOfExactType<UserBarTheme>();
    return userBarTheme?.data ?? StreamFeedTheme.of(context).userBarTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      UserBarTheme(data: data, child: child);

  @override
  bool updateShouldNotify(UserBarTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<UserBarThemeData>('data', data));
  }
}

/// {@template userBarThemeData}
/// A style that overrides the default appearance of [UserBar] and
/// [CommentItem] widgets when used with [UserBarTheme] or with the overall
/// [StreamFeedTheme]'s [StreamFeedThemeData.userBarTheme].
///
/// See also:
///
/// * [UserBarTheme], the theme which is configured with this class.
/// * [StreamFeedThemeData.userBarTheme], which can be used to override
/// the default style for [UserBar] and [CommentItem] widgets below the overall
/// [StreamFeedTheme].
/// {@endtemplate}
class UserBarThemeData with Diagnosticable {
  /// Builds a [UserBarThemeData].
  const UserBarThemeData({
    this.timestampTextStyle,
    this.usernameTextStyle,
    this.avatarSize,
  });

  /// The text style for the timestamp.
  final TextStyle? timestampTextStyle;

  /// The text style for the username.
  final TextStyle? usernameTextStyle;

  /// The size of the avatar.
  final double? avatarSize;

  /// Creates a copy of this theme, but with the given fields replaced with
  /// the new values.
  UserBarThemeData copyWith({
    TextStyle? timestampTextStyle,
    TextStyle? usernameTextStyle,
    double? avatarSize,
  }) {
    return UserBarThemeData(
      timestampTextStyle: timestampTextStyle ?? this.timestampTextStyle,
      usernameTextStyle: usernameTextStyle ?? this.usernameTextStyle,
      avatarSize: avatarSize ?? this.avatarSize,
    );
  }

  /// Linearly interpolates between two [UserBarThemeData].
  ///
  /// All the properties must be non-null.
  UserBarThemeData lerp(
    UserBarThemeData a,
    UserBarThemeData b,
    double t,
  ) {
    return UserBarThemeData(
      timestampTextStyle:
          TextStyle.lerp(a.timestampTextStyle, b.timestampTextStyle, t),
      usernameTextStyle:
          TextStyle.lerp(a.usernameTextStyle, b.usernameTextStyle, t),
      avatarSize: a.avatarSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBarThemeData &&
          runtimeType == other.runtimeType &&
          timestampTextStyle == other.timestampTextStyle &&
          usernameTextStyle == other.usernameTextStyle &&
          avatarSize == other.avatarSize;

  @override
  int get hashCode =>
      timestampTextStyle.hashCode ^
      usernameTextStyle.hashCode ^
      avatarSize.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('avatarSize', avatarSize));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'usernameTextStyle', usernameTextStyle));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'timestampTextStyle', timestampTextStyle));
  }
}
