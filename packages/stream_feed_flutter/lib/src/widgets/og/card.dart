import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/circular_progress_indicator.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:url_launcher/url_launcher.dart';

///{@template activity_card}
/// A card used to diplay Open Graph medias.
///
/// For now it displays an image and when clicked, it opens the media in
/// the device's browser.
///{@endtemplate}
class ActivityCard extends StatelessWidget {
  /// Builds an [ActivityCard].
  const ActivityCard({
    Key? key,
    required this.og,
    this.alt,
    this.image,
    // this.nolink,
    this.description,
    this.title,
    this.url,
    this.imageURL,
  }) : super(key: key);

  /// The alternative text to display for accessibility reasons.
  final String? alt;

  /// The image to display.
  final String? image;
  // final bool? nolink;
  /// The Opengraph media object.
  final OpenGraphData og;

  /// The imageUrl of the media.
  final String? imageURL;

  /// The description of the media.
  final String? description;

  /// The url of the media.
  final String? url;

  /// The title of the media.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final _url = og.url!;
    final firstOgImage = og.images?.first;
    final image = firstOgImage?.secureUrl ??
        firstOgImage?.url ??
        firstOgImage?.image ??
        imageURL;
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
      onTap: () async {
        await canLaunch(_url) //TODO: provide a callback
            ? await launch(_url)
            : throw 'Could not launch $_url';
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          color: Colors.grey[50],
          child: Row(children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                image!,
                height: 100,
                width: 100,
                semanticLabel:
                    firstOgImage?.alt ?? alt ?? title ?? description ?? '',
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) =>
                    StreamCircularProgressIndicator(
                  loadingProgress: loadingProgress,
                  child: child,
                ),
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        og.title!, //TODO: handle null
                        style: const TextStyle(
                          color: Color(0xff007aff),
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        og.description!, //TODO: handle null
                        style: const TextStyle(
                          color: Color(0xff364047),
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
