import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';

/// Overrides the default style of [GifDialog] descendants.
///
/// See also:
///
///  * [GifDialogThemeData], which is used to configure this theme.
class GifDialogTheme extends InheritedTheme {
  /// Builds a [GifDialogTheme].
  const GifDialogTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final GifDialogThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [GifDialogTheme] widget, then
  /// [StreamFeedThemeData.gifDialogTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = GifDialogTheme.of(context);
  /// ```
  static GifDialogThemeData of(BuildContext context) {
    final gifDialogTheme =
        context.dependOnInheritedWidgetOfExactType<GifDialogTheme>();
    return gifDialogTheme?.data ?? StreamFeedTheme.of(context).gifDialogTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      GifDialogTheme(data: data, child: child);

  @override
  bool updateShouldNotify(GifDialogTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GifDialogThemeData>('data', data));
  }
}

/// {@template gifDialogThemeData}
/// A style that overrides the default appearance of [GifDialog] widgets when
/// used with [GifDialogTheme] or with the overall [StreamFeedTheme]'s
/// [StreamFeedThemeData.gifDialogTheme].
///
/// See also:
///
/// * [GifDialogTheme], the theme which is configured with this class.
/// * [StreamFeedThemeData.gifDialogTheme], which can be used to override
/// the default style for [GifDialog] widgets below the overall
/// [StreamFeedTheme].
/// {@endtemplate}
class GifDialogThemeData with Diagnosticable {
  /// Builds a [GifDialogThemeData].
  const GifDialogThemeData({
    this.boxDecoration,
    this.iconColor,
  });

  /// The [BoxDecoration] for this [GifDialogThemeData].
  final BoxDecoration? boxDecoration;

  /// The color for the "gif" IconButton
  final Color? iconColor;

  /// Creates a copy of this theme, but with the given fields replaced with
  /// the new values.
  GifDialogThemeData copyWith({
    BoxDecoration? boxDecoration,
    Color? iconColor,
  }) {
    return GifDialogThemeData(
      boxDecoration: boxDecoration ?? this.boxDecoration,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  /// Linearly interpolates between two [GifDialogThemeData].
  ///
  /// All the properties must be non-null.
  GifDialogThemeData lerp(
    GifDialogThemeData a,
    GifDialogThemeData b,
    double t,
  ) {
    return GifDialogThemeData(
      boxDecoration: BoxDecoration.lerp(a.boxDecoration, b.boxDecoration, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GifDialogThemeData &&
          runtimeType == other.runtimeType &&
          boxDecoration == other.boxDecoration &&
          iconColor == other.iconColor;

  @override
  int get hashCode => boxDecoration.hashCode ^ iconColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<BoxDecoration?>('boxDecoration', boxDecoration));
    properties.add(ColorProperty('iconColor', iconColor));
  }
}
