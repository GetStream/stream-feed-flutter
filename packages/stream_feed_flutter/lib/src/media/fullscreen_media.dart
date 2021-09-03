import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

// ignore_for_file: cascade_invocations

/// Displays [Media] from a Feed in fullscreen.
class FullscreenMedia extends StatefulWidget {
  /// Builds a [FullscreenMedia].
  const FullscreenMedia({
    Key? key,
    required this.media,
    this.startIndex = 0,
  }) : super(key: key);

  /// The media to display.
  ///
  /// Can be audio, images, or videos.
  final List<Media> media;

  /// The first index of the media being shown.
  final int startIndex;

  @override
  _FullscreenMediaState createState() => _FullscreenMediaState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Media>('media', media));
    properties.add(IntProperty('startIndex', startIndex));
  }
}

class _FullscreenMediaState extends State<FullscreenMedia>
    with SingleTickerProviderStateMixin {
  // Whether to display the image options to the user by default or not.
  bool _optionsShown = true;

  late final AnimationController _controller;
  late final PageController _pageController;

  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController = PageController(initialPage: widget.startIndex);
    _currentPage = widget.startIndex;
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return PageView.builder(
                controller: _pageController,
                onPageChanged: (val) {
                  setState(() => _currentPage = val);
                },
                itemBuilder: (context, index) {
                  final media = widget.media[index];
                  if (media.mediaType == MediaType.image) {
                    return PhotoView(
                      imageProvider: NetworkImage(media.url),
                      maxScale: PhotoViewComputedScale.covered,
                      minScale: PhotoViewComputedScale.contained,
                    );
                  } else {
                    // TODO: handle other media types
                    return Container();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
