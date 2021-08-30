import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/themes.dart';

/// Applies a [StreamFeedThemeData] to descendent Stream Feed widgets.
class StreamFeedTheme extends InheritedWidget {
  /// Builds a [StreamFeedTheme].
  const StreamFeedTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The [StreamFeedThemeData] styling for this theme.
  final StreamFeedThemeData data;

  @override
  bool updateShouldNotify(StreamFeedTheme old) => data != old.data;

  /// Retrieves the [StreamFeedThemeData] from the closest ancestor
  /// [StreamFeedTheme] widget.
  static StreamFeedThemeData of(BuildContext context) {
    final streamFeedTheme =
        context.dependOnInheritedWidgetOfExactType<StreamFeedTheme>();

    assert(
      streamFeedTheme != null,
      'You must have a StreamFeedTheme widget at the top of your widget tree',
    );

    return streamFeedTheme!.data;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamFeedThemeData>('data', data));
  }
}

/// Defines the configuration of the overall visual [StreamFeedTheme] for a
/// particular widget subtree.
class StreamFeedThemeData with Diagnosticable {
  /// Builds a [StreamFeedThemeData] with default values, if none are given.
  factory StreamFeedThemeData({
    Brightness? brightness,
    ChildReactionThemeData? childReactionTheme,
    ReactionThemeData? reactionTheme,
    IconThemeData? primaryIconTheme,
  }) {
    // Use the given brightness, or a default
    final _brightness = brightness ?? Brightness.light;
    // Determine dark or light
    final isDark = _brightness == Brightness.dark;

    // Use the given childReactionTheme or a default.
    childReactionTheme ??= const ChildReactionThemeData(
      hoverColor: Colors.lightBlue,
      toggleColor: Colors.lightBlue,
    );

    // Use the given reactionTheme or a default.
    reactionTheme ??= const ReactionThemeData(
      hoverColor: Colors.lightBlue,
      toggleHoverColor: Colors.lightBlue,
      iconHoverColor: Colors.lightBlue,
    );

    // Use the given primaryIconTheme or a default.
    primaryIconTheme ??= IconThemeData(
      color: isDark ? const Color(0xff959595) : const Color(0xff757575),
    );

    return StreamFeedThemeData.raw(
      brightness: _brightness,
      childReactionTheme: childReactionTheme,
      reactionTheme: reactionTheme,
      primaryIconTheme: primaryIconTheme,
    );
  }

  /// A default light theme.
  factory StreamFeedThemeData.light() =>
      StreamFeedThemeData(brightness: Brightness.light);

  /// A default dark theme.
  factory StreamFeedThemeData.dark() =>
      StreamFeedThemeData(brightness: Brightness.dark);

  /// Raw [StreamFeedThemeData] initialization.
  const StreamFeedThemeData.raw({
    required this.brightness,
    required this.childReactionTheme,
    required this.reactionTheme,
    required this.primaryIconTheme,
  });

  /// The [Brightness] of this theme.
  final Brightness brightness;

  /// {@macro childReactionThemeData}
  final ChildReactionThemeData childReactionTheme;

  /// {@macro reactionThemeData}
  final ReactionThemeData reactionTheme;

  /// The primary icon theme
  final IconThemeData primaryIconTheme;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ChildReactionThemeData>(
          'childReactionTheme', childReactionTheme))
      ..add(DiagnosticsProperty<ReactionThemeData>(
          'reactionTheme', reactionTheme))
      ..add(EnumProperty<Brightness>('brightness', brightness))
      ..add(DiagnosticsProperty<IconThemeData>(
          'primaryIconTheme', primaryIconTheme));
  }
}
