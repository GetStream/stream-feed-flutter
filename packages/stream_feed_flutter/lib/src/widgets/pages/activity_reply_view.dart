import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reactive_elevated_button.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

// ignore_for_file: cascade_invocations

/// A widget that provides the means to reply to an activity.
///
/// It displays the parent activity with a reply area underneath. It also
/// provides a button to actually post the activity.
class ActivityReplyView extends StatefulWidget {
  const ActivityReplyView({
    Key? key,
    required this.parentActivity,
    required this.feedGroup,
    this.nameJsonKey = 'full_name',
  }) : super(key: key);

  /// The activity to reply to.
  final EnrichedActivity parentActivity;

  /// The feed group that the [parentActivity] belongs to.
  final String feedGroup;

  final String nameJsonKey;

  @override
  _ActivityReplyViewState createState() => _ActivityReplyViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EnrichedActivity>(
        'parentActivity', parentActivity));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
  }
}

class _ActivityReplyViewState extends State<ActivityReplyView> {
  final _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply'),
        actions: [
          ReactiveElevatedButton(
            textEditingController: _replyController,
            label: 'Post',
            buttonStyle: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onSend: (inputText) async {
              if (inputText.isNotEmpty) {
                await FeedProvider.of(context).bloc.onAddReaction(
                  kind: 'comment',
                  data: {'text': inputText.trim()},
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
              nameJsonKey: widget.nameJsonKey,
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
