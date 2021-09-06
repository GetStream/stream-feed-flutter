import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';

/// Overrides the default style of [ChildReactionButton] and
/// [ChildReactionToggleIcon] descendants.
///
/// See also:
///
///  * [ChildReactionThemeData], which is used to configure this theme.
class ChildReactionTheme extends InheritedTheme {
  /// Builds a [ChildReactionTheme].
  const ChildReactionTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final ChildReactionThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ChildReactionTheme] widget, then
  /// [StreamFeedThemeData.childReactionTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ChildReactionTheme.of(context);
  /// ```
  static ChildReactionThemeData of(BuildContext context) {
    final childReactionThemeData =
        context.dependOnInheritedWidgetOfExactType<ChildReactionTheme>();
    return childReactionThemeData?.data ??
        StreamFeedTheme.of(context).childReactionTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ChildReactionTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ChildReactionTheme oldWidget) =>
      data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ChildReactionThemeData>('data', data));
  }
}

/// {@template childReactionThemeData}
/// A style that overrides the default appearance of [ChildReactionButton] and
/// [ChildReactionToggleIcon] widgets when used with [ChildReactionTheme] or
/// with the overall [StreamFeedTheme]'s
/// [StreamFeedThemeData.childReactionTheme].
///
/// See also:
///
/// * [ChildReactionTheme], the theme which is configured with this class.
/// * [StreamFeedThemeData.childReactionTheme], which can be used to override
/// the default style for [ChildReactionButton] widgets below the overall
/// [StreamFeedTheme].
/// {@endtemplate}
class ChildReactionThemeData with Diagnosticable {
  /// Builds a [ChildReactionThemeData].
  const ChildReactionThemeData({
    this.hoverColor,
    this.toggleColor,
  });

  /// The color shown when the user hovers over the button.
  ///
  /// Generally applies to desktop and web.
  final Color? hoverColor;

  /// The color for a [ChildReactionToggleIcon].
  final Color? toggleColor;

  /// Creates a copy of this theme, but with the given fields replaced with
  /// the new values.
  ChildReactionThemeData copyWith({
    Color? hoverColor,
    Color? toggleColor,
  }) {
    return ChildReactionThemeData(
      hoverColor: hoverColor ?? this.hoverColor,
      toggleColor: toggleColor ?? this.toggleColor,
    );
  }

  /// Linearly interpolates between two [ChildReactionThemeData].
  ///
  /// All the properties must be non-null.
  ChildReactionThemeData lerp(
    ChildReactionThemeData a,
    ChildReactionThemeData b,
    double t,
  ) {
    return ChildReactionThemeData(
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      toggleColor: Color.lerp(a.toggleColor, b.toggleColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildReactionThemeData &&
          runtimeType == other.runtimeType &&
          hoverColor == other.hoverColor &&
          toggleColor == other.toggleColor;

  @override
  int get hashCode => hoverColor.hashCode ^ toggleColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('hoverColor', hoverColor))
      ..add(ColorProperty('toggleColor', toggleColor));
  }
}
