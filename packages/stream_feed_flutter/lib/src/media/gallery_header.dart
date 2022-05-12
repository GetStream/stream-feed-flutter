import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

/// Header/AppBar widget for media display screen
class GalleryHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Builds a [GalleryHeader].
  const GalleryHeader({
    Key? key,
    this.showBackButton = true,
    this.currentIndex = 0,
    this.totalMedia,
    this.onBackButtonPressed,
    this.backgroundColor,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  /// Whether to show the back button or not.
  ///
  /// Defaults to `true`.
  final bool showBackButton;

  /// An optional callback to perform when the back button is pressed.
  ///
  /// By default, it will call `Navigator.of(context).pop()`.
  final VoidCallback? onBackButtonPressed;

  /// The current index of the media being shown.
  final int currentIndex;

  /// The total amount of media being shown.
  final int? totalMedia;

  /// The background color of this [GalleryHeader].
  final Color? backgroundColor;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor:
          backgroundColor ?? GalleryHeaderTheme.of(context).backgroundColor,
      leading: showBackButton
          ? IconButton(
              icon: StreamSvgIcon.close(
                size: 24,
              ),
              onPressed: onBackButtonPressed,
            )
          : const SizedBox(),
      centerTitle: true,
      title: totalMedia != null
          ? Text(
              '${currentIndex + 1} of $totalMedia',
              style: GalleryHeaderTheme.of(context).titleTextStyle,
            )
          : null,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('showBackButton', showBackButton));
    properties.add(ObjectFlagProperty<VoidCallback?>.has(
        'onBackButtonPressed', onBackButtonPressed));
    properties.add(IntProperty('currentIndex', currentIndex));
    properties.add(IntProperty('totalMedia', totalMedia));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}
