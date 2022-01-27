import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/media/gallery_preview.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template activity_card}
/// A card used to display media attachments.
///
/// For now, it can display images and videos. When clicked, the image or
/// video will open in its own view.
/// {@endtemplate}
class ActivityCard extends StatelessWidget {
  /// Builds an [ActivityCard].
  const ActivityCard({
    Key? key,
    this.attachments,
  }) : super(key: key);

  /// The attachments to this post
  final List<Attachment>? attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments != null && attachments!.isNotEmpty) {
      return GalleryPreview(attachments: attachments!);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Attachment>('attachments', attachments));
  }
}
