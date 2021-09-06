import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';

// ignore_for_file: cascade_invocations

/// Overrides the default style of [ActivityCard] descendants.
///
/// See also:
///
///  * [OgCardThemeData], which is used to configure this theme.
class OgCardTheme extends InheritedTheme {
  /// Builds a [GifDialogTheme].
  const OgCardTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final OgCardThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [OgCardTheme] widget, then
  /// [StreamFeedThemeData.ogCardTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = OgCardTheme.of(context);
  /// ```
  static OgCardThemeData of(BuildContext context) {
    final ogCardTheme =
        context.dependOnInheritedWidgetOfExactType<OgCardTheme>();
    return ogCardTheme?.data ?? StreamFeedTheme.of(context).ogCardTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      OgCardTheme(data: data, child: child);

  @override
  bool updateShouldNotify(OgCardTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<OgCardThemeData>('data', data));
  }
}

/// {@template ogCardThemeData}
/// A style that overrides the default appearance of [ActivityCard] widgets when
/// used with [OgCardTheme] or with the overall [StreamFeedTheme]'s
/// [StreamFeedThemeData.ogCardTheme].
///
/// See also:
///
/// * [GifDialogTheme], the theme which is configured with this class.
/// * [StreamFeedThemeData.ogCardTheme], which can be used to override
/// the default style for [ActivityCard] widgets below the overall
/// [StreamFeedTheme].
/// {@endtemplate}
class OgCardThemeData with Diagnosticable {
  /// Builds an [OgCardThemeData].
  const OgCardThemeData({
    this.titleTextStyle,
    this.descriptionTextStyle,
  });

  /// The text style for the card's title.
  final TextStyle? titleTextStyle;

  /// The text style for the card's description.
  final TextStyle? descriptionTextStyle;

  /// Creates a copy of this theme, but with the given fields replaced with
  /// the new values.
  OgCardThemeData copyWith({
    TextStyle? titleTextStyle,
    TextStyle? descriptionTextStyle,
  }) {
    return OgCardThemeData(
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
    );
  }

  /// Linearly interpolates between two [OgCardThemeData].
  ///
  /// All the properties must be non-null.
  OgCardThemeData lerp(
    OgCardThemeData a,
    OgCardThemeData b,
    double t,
  ) {
    return OgCardThemeData(
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      descriptionTextStyle:
          TextStyle.lerp(a.descriptionTextStyle, b.descriptionTextStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OgCardThemeData &&
          runtimeType == other.runtimeType &&
          titleTextStyle == other.titleTextStyle &&
          descriptionTextStyle == other.descriptionTextStyle;

  @override
  int get hashCode => titleTextStyle.hashCode ^ descriptionTextStyle.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'descriptionTextStyle', descriptionTextStyle));
  }
}
