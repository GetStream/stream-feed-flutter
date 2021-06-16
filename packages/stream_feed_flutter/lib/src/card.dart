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
              child: Image.network(image!,
                  height: 100.0,
                  width: 100.0,
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
              }, fit: BoxFit.fill),
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
