import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reactive_elevated_button.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

// ignore_for_file: cascade_invocations

/// A widget that provides the means to compose or reply to an activity.
class ComposeView extends StatelessWidget {
  const ComposeView({
    Key? key,
    this.parentActivity,
    this.feedGroup,
    this.nameJsonKey = 'full_name',
  }) : super(key: key);

  /// The activity to reply to.
  final EnrichedActivity? parentActivity;

  /// The feed group that the [parentActivity] belongs to.
  final String? feedGroup;

  /// The json key for the user's name.
  final String nameJsonKey;

  @override
  Widget build(BuildContext context) {
    if (parentActivity == null) {
      return const _Composing();
    } else {
      return _Replying(
        parentActivity: parentActivity!,
        feedGroup: feedGroup!,
        nameJsonKey: nameJsonKey,
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EnrichedActivity?>(
        'parentActivity', parentActivity));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
  }
}

class _Composing extends StatefulWidget {
  const _Composing({Key? key}) : super(key: key);

  @override
  _ComposingState createState() => _ComposingState();
}

class _ComposingState extends State<_Composing> {
  final _composingController = TextEditingController();
  final _lightThemeInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade300,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    hintText: 'What\'s on your mind?',
    alignLabelWithHint: true,
  );
  final _darkThemeInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade800,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade800,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade800,
      ),
    ),
    hintText: 'What\'s on your mind?',
    alignLabelWithHint: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: Theme.of(context).iconTheme,
        titleTextStyle: Theme.of(context).textTheme.headline6,
        elevation: 0,
        title: const Text('Compose'),
        actions: [
          ReactiveElevatedButton(
            textEditingController: _composingController,
            label: 'Post',
            buttonStyle: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onSend: (inputText) async {
              if (inputText.isNotEmpty) {
                try {
                  FeedProvider.of(context).bloc.onAddActivity(
                        feedGroup: 'user',
                        verb: 'post',
                        object: _composingController.text,
                        userId: FeedProvider.of(context).bloc.currentUser!.id,
                      );

                  Navigator.of(context).pop();
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                  user: User(
                    data: FeedProvider.of(context).bloc.currentUser?.data,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _composingController,
                      autofocus: true,
                      maxLines: 5,
                      decoration:
                          Theme.of(context).brightness == Brightness.light
                              ? _lightThemeInputDecoration
                              : _darkThemeInputDecoration,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Replying extends StatefulWidget {
  const _Replying({
    Key? key,
    required this.parentActivity,
    required this.feedGroup,
    this.nameJsonKey = 'full_name',
  }) : super(key: key);

  final EnrichedActivity parentActivity;
  final String feedGroup;
  final String nameJsonKey;

  @override
  _ReplyingState createState() => _ReplyingState();
}

class _ReplyingState extends State<_Replying> {
  final _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        titleTextStyle: Theme.of(context).textTheme.headline6,
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
