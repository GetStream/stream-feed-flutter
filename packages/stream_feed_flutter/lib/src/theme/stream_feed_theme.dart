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
    GifDialogThemeData? gifDialogTheme,
    OgCardThemeData? ogCardTheme,
    UserBarThemeData? userBarTheme,
    GalleryHeaderThemeData? galleryHeaderTheme,
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
    reactionTheme ??= ReactionThemeData(
      hoverColor: Colors.lightBlue,
      toggleHoverColor: Colors.lightBlue,
      iconHoverColor: Colors.lightBlue,
      hashtagTextStyle: const TextStyle(
        color: Color(0xff0076ff),
        fontSize: 14,
      ),
      mentionTextStyle: const TextStyle(
        color: Color(0xff0076ff),
        fontSize: 14,
      ),
      normalTextStyle: isDark
          ? const TextStyle(
              color: Colors.white,
              fontSize: 14,
            )
          : const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
    );

    // Use the given primaryIconTheme or a default.
    primaryIconTheme ??= IconThemeData(
      color: isDark ? const Color(0xff959595) : const Color(0xff757575),
    );

    // Use the given gifDialogTheme or a default.
    gifDialogTheme ??= GifDialogThemeData(
      boxDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue),
      ),
      iconColor: Colors.blue,
    );

    // Use the given ogCardTheme or a default.
    ogCardTheme ??= const OgCardThemeData(
      titleTextStyle: TextStyle(
        color: Color(0xff007aff),
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
      ),
      descriptionTextStyle: TextStyle(
        color: Color(0xff364047),
        fontSize: 13,
        overflow: TextOverflow.ellipsis,
      ),
    );

    // Use the given userBarTheme or a default.
    userBarTheme ??= const UserBarThemeData(
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

    // Use the given galleryHeaderTheme or a default.
    galleryHeaderTheme ??= GalleryHeaderThemeData(
      backgroundColor: Colors.black,
      closeButtonColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
      ),
    );

    return StreamFeedThemeData.raw(
      brightness: _brightness,
      childReactionTheme: childReactionTheme,
      reactionTheme: reactionTheme,
      primaryIconTheme: primaryIconTheme,
      gifDialogTheme: gifDialogTheme,
      ogCardTheme: ogCardTheme,
      userBarTheme: userBarTheme,
      galleryHeaderTheme: galleryHeaderTheme,
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
    required this.gifDialogTheme,
    required this.ogCardTheme,
    required this.userBarTheme,
    required this.galleryHeaderTheme,
  });

  /// The [Brightness] of this theme.
  final Brightness brightness;

  /// {@macro childReactionThemeData}
  final ChildReactionThemeData childReactionTheme;

  /// {@macro reactionThemeData}
  final ReactionThemeData reactionTheme;

  /// The primary icon theme
  final IconThemeData primaryIconTheme;

  /// {@macro gifDialogThemeData}
  final GifDialogThemeData gifDialogTheme;

  /// {@macro ogCardThemeData}
  final OgCardThemeData ogCardTheme;

  /// {@macro userBarThemeData}
  final UserBarThemeData userBarTheme;

  /// {@macro galleryHeaderThemeData}
  final GalleryHeaderThemeData galleryHeaderTheme;

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
          'primaryIconTheme', primaryIconTheme))
      ..add(DiagnosticsProperty<GifDialogThemeData>(
          'gifDialogTheme', gifDialogTheme))
      ..add(DiagnosticsProperty<OgCardThemeData>('ogCardTheme', ogCardTheme))
      ..add(DiagnosticsProperty<UserBarThemeData>('userBarTheme', userBarTheme))
      ..add(DiagnosticsProperty<GalleryHeaderThemeData>(
          'galleryHeaderTheme', galleryHeaderTheme));
  }
}
