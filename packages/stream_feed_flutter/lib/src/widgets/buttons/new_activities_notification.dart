import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

typedef LabelFunction = String Function({
  required int count,
  required String labelSingle,
  required String labelPlural,
});

String defaultLabelFn({
  required int count,
  required String labelSingle,
  required String labelPlural,
}) =>
    'You have $count new ${count > 1 ? labelPlural : labelSingle}.';

class NewActivitiesNotification extends StatelessWidget {
  const NewActivitiesNotification({
    Key? key,
    required this.realtimeMessage,
    required this.onPressed,
    this.labelFunction = defaultLabelFn,
    this.labelPlural = 'notifications',
    this.labelSingle = 'notification',
    this.textStyle,
    this.buttonStyle,
  }) : super(key: key);

  final LabelFunction labelFunction;
  final VoidCallback onPressed;
  final String labelPlural;
  final String labelSingle;
  final RealtimeMessage realtimeMessage;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  List<String> get deletes => realtimeMessage.deleted;
  List<EnrichedActivity> get adds => realtimeMessage.newActivities;
  int get count => deletes.length + adds.length;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(
        labelFunction(
          count: count,
          labelPlural: labelPlural,
          labelSingle: labelSingle,
        ),
        style: textStyle,
      ),
    );
  }
}
