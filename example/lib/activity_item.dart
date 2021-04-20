import 'package:flutter/material.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'dummy_app_user.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        DummyAppUser.values.firstWhere((it) => it.id == activity.actor);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(user.name![0]),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name!,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Shared an update ${timeago.format(
                        activity.time!,
                        allowFromNow: true,
                      )}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Text(
            activity.extraData!['tweet'] as String,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
