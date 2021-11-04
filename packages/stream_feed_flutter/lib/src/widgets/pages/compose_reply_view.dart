import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class ComposeReplyView extends StatefulWidget {
  const ComposeReplyView({
    Key? key,
    required this.parentActivity,
    required this.feedGroup,
  }) : super(key: key);

  final EnrichedActivity parentActivity;
  final String feedGroup;

  @override
  _ComposeReplyViewState createState() => _ComposeReplyViewState();
}

class _ComposeReplyViewState extends State<ComposeReplyView> {
  final _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply'),
        actions: [
          ActionChip(
            label: const Text('Post'),
            onPressed: () async {
              if (_replyController.text.isNotEmpty) {
                await FeedProvider.of(context).bloc.onAddReaction(
                  kind: 'comment',
                  data: {'text': _replyController.text},
                  activity: widget.parentActivity,
                  feedGroup: widget.feedGroup,
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
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
