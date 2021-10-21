import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/transition_type.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/comment.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template flat_activity_list_page}
/// Display a list of activities.
///
/// Best used as the main page of an app.
/// {@endtemplate}
class AggregatedFeedListView extends StatelessWidget {
  /// Builds a [FlatActivityListPage].
  const AggregatedFeedListView({
    Key? key,
    this.feedGroup = 'user',
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.activityFooterBuilder,
    this.activityContentBuilder,
    this.activityHeaderBuilder,
    this.limit,
    this.offset,
    this.session,
    this.filter,
    this.flags,
    // required this.bloc,
    this.ranking,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
    this.onProgressWidget = const ProgressStateWidget(),
    this.onErrorWidget = const ErrorStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No activities to display'),
    this.onActivityTap,
    this.transitionType =
        TransitionType.material, //TODO: move this to core or theme
  }) : super(key: key);

  /// {@macro hashtag_callback}
  final OnHashtagTap? onHashtagTap;
  //TODO:document me
  // final DefaultFeedBloc bloc;

  /// {@macro mention_callback}
  final OnMentionTap? onMentionTap;

  /// {@macro user_callback}
  final OnUserTap? onUserTap;

  /// A feed group to fetch activities for
  final String feedGroup;

  /// Builds the activity footer
  final ActivityFooterBuilder? activityFooterBuilder;

  /// Builds the activity content
  final ActivityContentBuilder? activityContentBuilder;

  /// Builds the activity headerAny
  final ActivityHeaderBuilder? activityHeaderBuilder;

  /// {@macro activity_callback}
  final OnActivityTap? onActivityTap;

  /// A widget to display when there is an error in the request
  final Widget onErrorWidget;

  /// A widget to display loading progress
  final Widget onProgressWidget;

  /// A widget to display when there are no activities
  final Widget onEmptyWidget;

  /// Customises the transition
  final TransitionType transitionType;

  /// The limit of activities to fetch
  final int? limit;

  /// The offset of activities to fetch
  final int? offset;

  /// The session to use for the request
  final String? session;

  /// The filter to use for the request
  final Filter? filter;

  /// The flags to use for the request
  final EnrichmentFlags? flags;

  /// The ranking to use for the request
  final String? ranking;

  /// TODO: document me
  final String handleJsonKey;

  /// TODO: document me
  final String nameJsonKey;

  @override
  Widget build(BuildContext context) {
    return DefaultAggregatedFeedCore(
      bloc: DefaultFeedBlocProvider.of(context).bloc,
      flags: flags,
      limit: limit,
      offset: offset,
      session: session,
      filter: filter,
      ranking: ranking,
      onProgressWidget: onProgressWidget,
      onErrorWidget: onErrorWidget,
      aggregatedFeedBuilder: (context, aggregatedActivities, index) {
        return ActivityWidget(
          //TODO: create it based on ActivityWidget
          activity: aggregatedActivities[index],
          feedGroup: feedGroup,
          onHashtagTap: onHashtagTap,
          onMentionTap: onMentionTap,
          onUserTap: onUserTap,
          nameJsonKey: nameJsonKey,
          handleJsonKey: handleJsonKey,
          activityHeaderBuilder: activityHeaderBuilder,
          activityFooterBuilder: activityFooterBuilder,
          activityContentBuilder: activityContentBuilder,
          onActivityTap: (context, aggregatedActivity) {
            _pageRouteBuilder(
              aggregatedActivity: aggregatedActivity,
              context: context,
              transitionType: transitionType,
              currentNavigator: Navigator.of(context),
              page: Scaffold(
                appBar: AppBar(
                  title: const Text('Post'),
                ),
                body: CommentView(
                  //TODO: create it based on CommentView widget
                  nameJsonKey: nameJsonKey,
                  handleJsonKey: handleJsonKey,
                  activity: aggregatedActivity,
                  enableCommentFieldButton: true,
                  enableReactions: true,
                  textEditingController: TextEditingController(),
                ),
              ),
            );
          },
        );
      },
      feedGroup: feedGroup,
    );
  }

  void _pageRouteBuilder({
    required BuildContext context,
    required TransitionType transitionType,
    required EnrichedActivity aggregatedActivity,
    required Widget page,
    required NavigatorState currentNavigator,
  }) {
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
        currentNavigator.push(
          PageRouteBuilder(
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
          ),
        );
    }
  }
}
