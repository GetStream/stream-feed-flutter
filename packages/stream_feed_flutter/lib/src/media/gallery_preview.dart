import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/media/fullscreen_media.dart';
import 'package:stream_feed_flutter/src/media/media.dart';

/// A widget that displays image previews
class GalleryPreview extends StatelessWidget {
  /// Builds a [GalleryPreview].
  const GalleryPreview({
    Key? key,
    required this.media,
  }) : super(key: key);

  /// The list of image urls to display
  final List<Media> media;

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
                  child: Image.network(
                    media.first.url,
                    fit: BoxFit.cover,
                  ),
                ),
                if (media.length >= 2)
                  FlexibleImage(
                    media: media,
                    index: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Image.network(
                        media[1].url,
                        fit: BoxFit.cover,
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
                      child: Image.network(
                        media[2].url,
                        fit: BoxFit.cover,
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
                              Image.network(
                                media[3].url,
                                fit: BoxFit.cover,
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
    properties.add(IterableProperty<Media>('media', media));
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

  final Widget? child;
  final FlexFit flexFit;
  final int index;
  final List<Media> media;

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
}
