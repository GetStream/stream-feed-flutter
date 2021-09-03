import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/media/fullscreen_media.dart';
import 'package:stream_feed_flutter/src/media/media.dart';

/// A widget that displays image previews
class GalleryPreview extends StatelessWidget {
  /// Builds a [GalleryPreview].
  const GalleryPreview({
    Key? key,
    required this.urls,
  }) : super(key: key);

  /// The list of image urls to display
  final List<String> urls;

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
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () => _onTap(context, 0),
                    child: Image.network(
                      urls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (urls.length >= 2)
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: GestureDetector(
                        onTap: () => _onTap(context, 1),
                        child: Image.network(
                          urls[1],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (urls.length >= 3)
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () => _onTap(context, 2),
                        child: Image.network(
                          urls[2],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (urls.length >= 4)
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                urls[3],
                                fit: BoxFit.cover,
                              ),
                              if (urls.length > 4)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => _onTap(context, 3),
                                    child: Material(
                                      color: Colors.black38,
                                      child: Center(
                                        child: Text(
                                          '+ ${urls.length - 4}',
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
    final media = <Media>[];
    for (final url in urls) {
      media.add(Media(url: url));
    }
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
    properties.add(IterableProperty<String>('urls', urls));
  }
}
