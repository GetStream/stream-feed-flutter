import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';

/// Overrides the default style of [ReactionButton] and
/// [ChildReactionToggleIcon] descendants.
///
/// See also:
///
///  * [ReactionThemeData], which is used to configure this theme.
class ReactionTheme extends InheritedTheme {
  /// Builds a [ReactionTheme].
  const ReactionTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final ReactionThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ReactionTheme] widget, then
  /// [StreamFeedThemeData.reactionTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ReactionTheme.of(context);
  /// ```
  static ReactionThemeData of(BuildContext context) {
    final reactionThemeData =
        context.dependOnInheritedWidgetOfExactType<ReactionTheme>();
    return reactionThemeData?.data ?? StreamFeedTheme.of(context).reactionTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ReactionTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ReactionTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ReactionThemeData>('data', data));
  }
}

/// {@template reactionThemeData}
/// A style that overrides the default appearance of [ReactionButton] and
/// [ChildReactionToggleIcon] widgets when used with [ReactionTheme] or
/// with the overall [StreamFeedTheme]'s
/// [StreamFeedThemeData.reactionTheme].
///
/// See also:
///
/// * [ReactionTheme], the theme which is configured with this class.
/// * [StreamFeedThemeData.reactionTheme], which can be used to override
/// the default style for [ReactionButton] widgets below the overall
/// [StreamFeedTheme].
/// {@endtemplate}
class ReactionThemeData with Diagnosticable {
  /// Builds a [ReactionThemeData].
  const ReactionThemeData({
    this.hoverColor,
    this.toggleHoverColor,
    this.iconHoverColor,
  });

  /// The color shown when the user hovers over the button.
  ///
  /// Generally applies to desktop and web.
  final Color? hoverColor;

  /// The color for a [ReactionToggleIcon].
  final Color? toggleHoverColor;

  /// The hover color for a [ReactionIcon].
  final Color? iconHoverColor;

  /// Creates a copy of this theme, but with the given fields replaced with
  /// the new values.
  ReactionThemeData copyWith({
    Color? hoverColor,
    Color? toggleHoverColor,
    Color? iconHoverColor,
  }) {
    return ReactionThemeData(
      hoverColor: hoverColor ?? this.hoverColor,
      toggleHoverColor: toggleHoverColor ?? this.toggleHoverColor,
      iconHoverColor: iconHoverColor ?? this.iconHoverColor,
    );
  }

  /// Linearly interpolates between two [ReactionThemeData].
  ///
  /// All the properties must be non-null.
  ReactionThemeData lerp(
    ReactionThemeData a,
    ReactionThemeData b,
    double t,
  ) {
    return ReactionThemeData(
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      toggleHoverColor: Color.lerp(a.toggleHoverColor, b.toggleHoverColor, t),
      iconHoverColor: Color.lerp(a.iconHoverColor, b.iconHoverColor, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReactionThemeData &&
          runtimeType == other.runtimeType &&
          hoverColor == other.hoverColor &&
          toggleHoverColor == other.toggleHoverColor &&
          iconHoverColor == other.iconHoverColor;

  @override
  int get hashCode => hoverColor.hashCode ^ toggleHoverColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('hoverColor', hoverColor))
      ..add(ColorProperty('toggleHoverColor', toggleHoverColor))
      ..add(ColorProperty('iconHoverColor', iconHoverColor));
  }
}
