import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

/// An alert dialog that prompts the user to delete the current activity.
class DeleteActivityDialog extends StatelessWidget {
  /// Builds a [DeleteActivityDialog].
  const DeleteActivityDialog({
    Key? key,
    required this.activityId,
    required this.feedGroup,
  }) : super(key: key);

  /// The ID of the activity to delete.
  final String activityId;

  /// The feed group that the activity being deleted belongs to.
  ///
  /// Ex: 'timeline'.
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: const Text('Do you really want to delete this activity?'),
      actions: [
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            // Keep in mind that we might need to refactor this so that
            // users pass in their own logic.
            FeedProvider.of(context)
                .bloc
                .onRemoveActivity(feedGroup: feedGroup, activityId: activityId);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('activityId', activityId));
    properties.add(StringProperty('feedGroup', feedGroup));
  }
}
