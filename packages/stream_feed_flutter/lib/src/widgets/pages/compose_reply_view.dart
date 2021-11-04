import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class ComposeReplyView extends StatefulWidget {
  const ComposeReplyView({
    Key? key,
    required this.parentActivity,
  }) : super(key: key);

  final EnrichedActivity parentActivity;

  @override
  _ComposeReplyViewState createState() => _ComposeReplyViewState();
}

class _ComposeReplyViewState extends State<ComposeReplyView> {
  final _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ActivityWidget(
              activity: widget.parentActivity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Avatar(
                    user: User(
                      data: FeedProvider.of(context).bloc.currentUser!.data,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Post your reply',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
