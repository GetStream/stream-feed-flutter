import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/comment.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:animations/animations.dart';

enum TransitionType { none, sharedAxisTransition }
enum DesignSystem { material, cupertino }

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
    this.designSystem = DesignSystem.material,
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
  final Widget onErrorWidget;
  final Widget onProgressWidget;

  final DesignSystem designSystem;

  ///Customise the transition
  final TransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return FlatFeedCore(
      onProgressWidget: onProgressWidget,
      onErrorWidget: onErrorWidget,
      //TODO: activity type Flat?
      onSuccess: (context, activities, idx) => StreamFeedActivity(
        activity: activities[idx],
        feedGroup: feedGroup,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
        onUserTap: onUserTap,
        activityHeaderBuilder: activityHeaderBuilder,
        activityFooterBuilder: activityFooterBuilder,
        activityContentBuilder: activityContentBuilder,
        onActivityTap: (context, activity) => pageRouteBuilder(
          activity: activity,
          context: context,
          transitionType: transitionType,
          page: CommentView(
            //TODO: core for loading this Navigator 2.0 style
            activity: activity,
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
      case TransitionType.none:
        currentNavigator.push(
          MaterialPageRoute<void>(
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
