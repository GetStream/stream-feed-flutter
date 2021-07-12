import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/circular_progress_indicator.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// A card used to diplay Open Graph medias.
/// For now it displays an image
///  and when clicked, it opens the media in device's browser.
class ActivityCard extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final _url = og.url!;
    final firstOgImage = og.images?.first;
    final image = firstOgImage?.secureUrl ??
        firstOgImage?.url ??
        firstOgImage?.image ??
        imageURL;
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      onTap: () async {
        await canLaunch(_url) //TODO: provide a callback
            ? await launch(_url)
            : throw 'Could not launch $_url';
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.grey[50],
          child: Row(children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.network(
                image!,
                height: 100.0,
                width: 100.0,
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        og.title!, //TODO: handle null
                        style: TextStyle(
                          color: Color(0xff007aff),
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        og.description!, //TODO: handle null
                        style: TextStyle(
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
