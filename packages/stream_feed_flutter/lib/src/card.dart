import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StreamFeedCard extends StatelessWidget {
  final String? alt;
  final String? image;
  // final bool? nolink;
  final OpenGraphData og;
  final String? imageURL;
  final String? description;
  final String? url;
  final String? title;
  const StreamFeedCard({
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
    final image = firstOgImage?.secureUrl ?? firstOgImage?.url ?? imageURL;
    return InkWell(
        onTap: () async {
          await canLaunch(_url)//TODO: provide a callback
              ? await launch(_url)
              : throw 'Could not launch $_url';
        },
        child: Card(
          child: Image.network(
            //TODO: replace with cached network image
            image!, //TODO: handle empty state
            semanticLabel:
                firstOgImage?.alt ?? alt ?? title ?? description ?? '',
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  //TODO: provide a way to customize progress indicator
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },

            fit: BoxFit.cover,
          ),
        ));
  }
}
