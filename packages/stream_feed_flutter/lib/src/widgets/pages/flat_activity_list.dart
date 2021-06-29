import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/comment.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:animations/animations.dart';

enum TransitionType { material, cupertino, sharedAxisTransition }

class FlatActivityListPage extends StatelessWidget {
  const FlatActivityListPage({
    Key? key,
    this.feedGroup = 'user',
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.activityFooterBuilder,
    this.activityContentBuilder,
    this.activityHeaderBuilder,
    this.onProgressWidget = const ProgressStateWidget(),
    this.onErrorWidget = const ErrorStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No activities to display'),
    this.onActivityTap,
    this.transitionType =
        TransitionType.sharedAxisTransition, //TODO: move this to core or theme
  }) : super(key: key);

  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;
  final OnUserTap? onUserTap;
  final String feedGroup;
  final ActivityFooterBuilder? activityFooterBuilder;
  final ActivityContentBuilder? activityContentBuilder;
  final ActivityHeaderBuilder? activityHeaderBuilder;

  ///Override the current navigation behavior. Useful for user provided Navigator 2.0
  final OnActivityTap? onActivityTap;
  final Widget onErrorWidget;
  final Widget onProgressWidget;
  final Widget onEmptyWidget;

  ///Customise the transition
  final TransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return FlatFeedCore(
      onProgressWidget: onProgressWidget,
      onErrorWidget: onErrorWidget,
      //TODO: activity type Flat?
      onActivities: (context, activities, idx) => StreamFeedActivity(
        activity: activities[idx],
        feedGroup: feedGroup,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
        onUserTap: onUserTap,
        activityHeaderBuilder: activityHeaderBuilder,
        activityFooterBuilder: activityFooterBuilder,
        activityContentBuilder: activityContentBuilder,
        onActivityTap: (context, activity) => onActivityTap != null
            ? onActivityTap?.call(context, activity)
            //TODO: provide a way to load via url / ModalRoute.of(context).settings with ActivityCore (todo)

            : pageRouteBuilder(
                activity: activity,
                context: context,
                transitionType: transitionType,
                page: CommentView(
                  enableReactions: true,
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
      required Widget page}) {
    final currentNavigator = StreamFeedCore.of(context).navigator!;
    switch (transitionType) {
      case TransitionType.material:
        currentNavigator.push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => page,
          ),
        );
        break;
      case TransitionType.cupertino:
        currentNavigator.push(
          CupertinoPageRoute<void>(
            builder: (BuildContext context) => page,
          ),
        );
        break;
      default:
        currentNavigator.push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
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
