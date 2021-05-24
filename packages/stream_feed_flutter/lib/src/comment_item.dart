import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hashtags = ['snowboarding', 'winter'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Avatar(
            size: 25,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Text('Rosemary',
                          style: TextStyle(
                              color: Color(0xff0ba8e0),
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        timeago.format(now),
                        style: TextStyle(
                            color: Color(0xff7a8287),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Snowboarding is awesome!',
                        style: TextStyle(
                            color: Color(0xff7a8287),
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    ...hashtags
                        .map((hashtag) => TextSpan(
                            text: ' #$hashtag',
                            style: TextStyle(
                                color: Color(0xff095482),
                                fontWeight: FontWeight.w600,
                                fontSize: 14)))
                        .toList()
                  ])),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
