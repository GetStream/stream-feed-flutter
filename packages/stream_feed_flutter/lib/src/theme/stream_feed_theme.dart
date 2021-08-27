import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/child_reaction_theme.dart';

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
      'You must have a StreamChatTheme widget at the top of your widget tree',
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
    ChildReactionThemeData? childReactionTheme,
  }) {
    // Use the given childReactionTheme or a default.
    childReactionTheme ??= ChildReactionThemeData(
      hoverColor: Colors.lightBlue,
      toggleColor: Colors.lightBlue,
    );

    return StreamFeedThemeData.raw(
      childReactionTheme: childReactionTheme,
    );
  }

  /// Raw [StreamFeedThemeData] initialization.
  const StreamFeedThemeData.raw({
    required this.childReactionTheme,
  });

  /// {@macro childReactionThemeData}
  final ChildReactionThemeData childReactionTheme;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ChildReactionThemeData>(
        'childReactionTheme', childReactionTheme));
  }
}
