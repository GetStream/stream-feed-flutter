import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';

/// Overrides the default style of [GalleryHeader] descendants.
///
/// See also:
///
///  * [GalleryHeaderThemeData], which is used to configure this theme.
class GalleryHeaderTheme extends InheritedTheme {
  /// Creates a [GalleryHeaderTheme].
  ///
  /// The [data] parameter must not be null.
  const GalleryHeaderTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final GalleryHeaderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [GalleryHeaderTheme] widget, then
  /// [StreamFeedThemeData.galleryHeaderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = GalleryHeaderTheme.of(context);
  /// ```
  static GalleryHeaderThemeData of(BuildContext context) {
    final galleryHeaderTheme =
        context.dependOnInheritedWidgetOfExactType<GalleryHeaderTheme>();
    return galleryHeaderTheme?.data ??
        StreamFeedTheme.of(context).galleryHeaderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      GalleryHeaderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(GalleryHeaderTheme oldWidget) =>
      data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GalleryHeaderThemeData>('data', data));
  }
}

/// {@template galleryHeaderThemeData}
/// A style that overrides the default appearance of [GalleryHeader]s when used
/// with [GalleryHeaderTheme] or with the overall [StreamFeedTheme]'s
/// [StreamFeedThemeData.galleryHeaderTheme].
///
/// See also:
///
/// * [GalleryHeaderTheme], the theme which is configured with this class.
/// * [StreamFeedThemeData.galleryHeaderTheme], which can be used to override
/// the default style for [GalleryHeader]s below the overall [StreamFeedTheme].
/// {@endtemplate}
class GalleryHeaderThemeData with Diagnosticable {
  /// Builds a [GalleryHeaderThemeData].
  const GalleryHeaderThemeData({
    this.closeButtonColor,
    this.backgroundColor,
    this.titleTextStyle,
  });

  /// The color of the "close" button.
  ///
  /// Defaults to [ColorTheme.textHighEmphasis].
  final Color? closeButtonColor;

  /// The background color of the [GalleryHeader] widget.
  ///
  /// Defaults to [ChannelHeaderTheme.color].
  final Color? backgroundColor;

  /// The [TextStyle] to use for the [GalleryHeader] title text.
  ///
  /// Defaults to [TextTheme.headlineBold].
  final TextStyle? titleTextStyle;

  /// Copies this [GalleryHeaderThemeData] to another.
  GalleryHeaderThemeData copyWith({
    Color? closeButtonColor,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
  }) =>
      GalleryHeaderThemeData(
        closeButtonColor: closeButtonColor ?? this.closeButtonColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      );

  /// Linearly interpolate between two [GalleryHeader] themes.
  ///
  /// All the properties must be non-null.
  GalleryHeaderThemeData lerp(
    GalleryHeaderThemeData a,
    GalleryHeaderThemeData b,
    double t,
  ) =>
      GalleryHeaderThemeData(
        closeButtonColor: Color.lerp(a.closeButtonColor, b.closeButtonColor, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryHeaderThemeData &&
          runtimeType == other.runtimeType &&
          closeButtonColor == other.closeButtonColor &&
          backgroundColor == other.backgroundColor &&
          titleTextStyle == other.titleTextStyle;

  @override
  int get hashCode =>
      closeButtonColor.hashCode ^
      backgroundColor.hashCode ^
      titleTextStyle.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('closeButtonColor', closeButtonColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties
        .add(DiagnosticsProperty<TextStyle?>('titleTextStyle', titleTextStyle));
  }
}
