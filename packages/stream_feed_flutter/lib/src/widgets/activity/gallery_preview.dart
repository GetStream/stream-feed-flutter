import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return SizedBox(
      height: 270,
      child: GridView.builder(
        itemCount: urls.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Image.network(urls[index]);
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('urls', urls));
  }
}
