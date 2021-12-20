import 'package:stream_feed_example/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:timeago/timeago.dart' as timeago;

//ignore: public_member_api_docs
class ActivityCard extends StatelessWidget {
  //ignore: public_member_api_docs
  const ActivityCard({
    required this.activity,
    Key? key,
  }) : super(key: key);

  //ignore: public_member_api_docs
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final user = appUsers
        .firstWhere((it) => createUserReference(it.id) == activity.actor);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(user.name[0]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Shared an update ${timeago.format(
                        activity.time!,
                        allowFromNow: true,
                      )}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            activity.extraData!['tweet'].toString(),
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Activity>('activity', activity));
  }
}
