import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/media/fullscreen_media.dart';

import 'package:stream_feed_flutter/src/media/media_widget.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

// ignore_for_file: cascade_invocations

/// A widget that displays image previews
class GalleryPreview extends StatelessWidget {
  /// Builds a [GalleryPreview].
  const GalleryPreview({
    Key? key,
    required this.media,
  }) : super(key: key);

  /// The list of image urls to display
  final List<MediaUri> media;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(
          mediaQueryData.size.width * 1.0,
          mediaQueryData.size.height * 0.3,
        ),
      ),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: Axis.horizontal,
              children: [
                FlexibleImage(
                  media: media,
                  child: MediaWidget(
                    media: media[0],
                  ),
                ),
                if (media.length >= 2)
                  FlexibleImage(
                    media: media,
                    index: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: MediaWidget(
                        media: media[1],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (media.length >= 3)
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FlexibleImage(
                      media: media,
                      index: 2,
                      child: MediaWidget(
                        media: media[2],
                      ),
                    ),
                    if (media.length >= 4)
                      FlexibleImage(
                        media: media,
                        index: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              MediaWidget(
                                media: media[3],
                              ),
                              if (media.length > 4)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => _onTap(context, 3),
                                    child: Material(
                                      color: Colors.black38,
                                      child: Center(
                                        child: Text(
                                          '+ ${media.length - 4}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullscreenMedia(
          startIndex: index,
          media: media,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<MediaUri>('media', media));
  }
}

/// A flexible, tappable image that resizes itself according to (...?)
class FlexibleImage extends StatelessWidget {
  /// Builds a [FlexibleImage].
  const FlexibleImage({
    Key? key,
    required this.media,
    this.index = 0,
    this.child,
    this.flexFit = FlexFit.tight,
  }) : super(key: key);

  /// The child to display, ideally an image of some kind.
  final Widget? child;

  /// How the child is inscribed into the available space.
  final FlexFit flexFit;

  /// The current index of the media being shown.
  final int index;

  /// The media being shown.
  final List<MediaUri> media;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: flexFit,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullscreenMedia(
                startIndex: index,
                media: media,
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<FlexFit>('flexFit', flexFit));
    properties.add(IntProperty('index', index));
    properties.add(IterableProperty<MediaUri>('media', media));
  }
}
