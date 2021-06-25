import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/comment.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:animations/animations.dart';

enum TransitionType { none, sharedAxisTransition }

class FlatFeed extends StatelessWidget {
  //TODO: rename this builder or something
  const FlatFeed({
    Key? key,
    this.feedGroup = 'user',
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.activityFooterBuilder,
    this.transitionType =
        TransitionType.sharedAxisTransition, //TODO: move this to core or theme
  }) : super(key: key);

  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;
  final OnUserTap? onUserTap;
  final String feedGroup;
  final ActivityFooterBuilder? activityFooterBuilder;

  ///Customise the transition
  final TransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return FlatFeedCore(
      onSuccess: (context, activities, idx) => StreamFeedActivity(
        activity: activities[idx],
        feedGroup: feedGroup,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
        onUserTap: onUserTap,
        activityFooterBuilder: activityFooterBuilder,
        onActivityTap: (context, activity) => pageRouteBuilder(
          activity: activity!,
          context: context,
          transitionType: transitionType,
          widget: CommentView(
            activity: activity,
            textEditingController:
                TextEditingController(), //TODO: move this into props for customisation like buildSpans
          ),
        ),
      ),
      feedGroup: feedGroup,
    );
  }

  void pageRouteBuilder(
      {required BuildContext context,
      required TransitionType transitionType,
      required EnrichedActivity activity,
      required Widget widget}) {
    switch (transitionType) {
      case TransitionType.none:
        StreamFeedCore.of(context).navigator!.push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => widget,
              ),
            );
        break;
      default:
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => widget,
              transitionsBuilder: (
                _,
                animation,
                secondaryAnimation,
                child,
              ) =>
                  SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              ),
            ));
    }
  }
}
