import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_feed_flutter/src/media/gallery_header.dart';
import 'package:stream_feed_flutter/src/media/video_package.dart';
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
  FullscreenMediaState createState() => FullscreenMediaState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Media>('media', media));
    properties.add(IntProperty('startIndex', startIndex));
  }
}

class FullscreenMediaState extends State<FullscreenMedia>
    with SingleTickerProviderStateMixin {
  // Whether to display the image options to the user by default or not.
  @visibleForTesting
  // ignore: diagnostic_describe_all_properties, public_member_api_docs
  bool optionsShown = true;

  late final AnimationController _controller;
  late final PageController _pageController;

  late int _currentPage;

  final videoPackages = <String, VideoPackage>{};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController = PageController(initialPage: widget.startIndex);
    _currentPage = widget.startIndex;
    for (final media in widget.media) {
      if (media.mediaType != MediaType.video) continue;
      final package = VideoPackage(media, showControls: true);
      videoPackages[media.url] = package;
    }
    _initializePlayers();
  }

  Future<void> _initializePlayers() async {
    await Future.wait(videoPackages.values.map(
      (it) => it.initialize(),
    ));
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    for (final package in videoPackages.values) {
      package.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return PageView.builder(
                controller: _pageController,
                itemCount: widget.media.length,
                onPageChanged: (val) {
                  setState(() => _currentPage = val);
                },
                itemBuilder: (context, index) {
                  final media = widget.media[index];
                  if (media.mediaType == MediaType.image && media.isValidUrl) {
                    return PhotoView(
                      imageProvider: NetworkImage(media.url),
                      maxScale: PhotoViewComputedScale.covered,
                      minScale: PhotoViewComputedScale.contained,
                      onTapUp: (a, b, c) {
                        setState(() => optionsShown = !optionsShown);
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                      },
                      loadingBuilder: (context, event) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  } else if (media.mediaType == MediaType.video &&
                      media.isValidUrl) {
                    final controller = videoPackages[media.url];
                    if (controller != null && !controller.initialized) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        print(optionsShown);
                        setState(() {
                          optionsShown = !optionsShown;
                        });
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50,
                        ),
                        child: Chewie(
                          controller: controller!.chewieController!,
                        ),
                      ),
                    );
                  } else {
                    // TODO: handle other media types
                    return Container();
                  }
                },
              );
            },
          ),
          AnimatedOpacity(
            opacity: optionsShown ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GalleryHeader(
                  currentIndex: _currentPage,
                  totalMedia: widget.media.length,
                  onBackButtonPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
