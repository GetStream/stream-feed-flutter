import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/default/default.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/comment.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

enum TransitionType {
  material,

  cupertino,

  sharedAxisTransition,
}

/// {@template flat_activity_list_page}
/// Display a list of activities.
///
/// Best used as the main page of an app.
/// {@endtemplate}
class FlatFeedListView extends StatefulWidget {
  /// Builds a [FlatFeedListView].
  const FlatFeedListView({
    Key? key,
    this.feedGroup = 'user',
    this.userId,
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
    this.onProgressWidget = const LoadingStateWidget(),
    this.onErrorWidget = const ErrorStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No activities to display'),
    this.onActivityTap,
    this.transitionType =
        TransitionType.material, //TODO: move this to core or theme
    this.scrollPhysics,
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

  /// Builds the activity header
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

  final String handleJsonKey;

  final String nameJsonKey;

  final String? userId;

  final ScrollPhysics? scrollPhysics;

  @override
  State<FlatFeedListView> createState() => _FlatFeedListViewState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<ScrollPhysics?>('scrollPhysics', scrollPhysics));
    properties.add(StringProperty('userId', userId));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(StringProperty('handleJsonKey', handleJsonKey));
    properties.add(StringProperty('ranking', ranking));
    properties.add(DiagnosticsProperty<EnrichmentFlags?>('flags', flags));
    properties.add(DiagnosticsProperty<Filter?>('filter', filter));
    properties.add(StringProperty('session', session));
    properties.add(IntProperty('offset', offset));
    properties.add(IntProperty('limit', limit));
    properties
        .add(EnumProperty<TransitionType>('transitionType', transitionType));
    properties.add(
        ObjectFlagProperty<OnActivityTap?>.has('onActivityTap', onActivityTap));
    properties.add(ObjectFlagProperty<ActivityHeaderBuilder?>.has(
        'activityHeaderBuilder', activityHeaderBuilder));
    properties.add(ObjectFlagProperty<ActivityContentBuilder?>.has(
        'activityContentBuilder', activityContentBuilder));
    properties.add(ObjectFlagProperty<ActivityFooterBuilder?>.has(
        'activityFooterBuilder', activityFooterBuilder));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap));
    properties.add(
        ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap));
    properties.add(
        ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap));
  }
}

class _FlatFeedListViewState extends State<FlatFeedListView> {
  bool _isPaginating = false;

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      FeedProvider.of(context)
          .bloc
          .loadMoreEnrichedActivities(
            feedGroup: widget.feedGroup,
          )
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatFeedCore(
      userId: widget.userId,
      flags: widget.flags,
      limit: widget.limit,
      offset: widget.offset,
      session: widget.session,
      filter: widget.filter,
      ranking: widget.ranking,
      loadingBuilder: (context) => widget.onProgressWidget,
      errorBuilder: (context, error) => widget.onErrorWidget,
      emptyBuilder: (context) => widget.onEmptyWidget,
      //TODO: activity type Flat?
      feedBuilder: (
        context,
        activities,
      ) {
        return ListView.builder(
          itemCount: activities.length,
          physics: widget.scrollPhysics,
          itemBuilder: (context, index) {
            final shouldLoadMore = activities.length - 3 == index;
            if (shouldLoadMore) {
              _loadMore();
            }
            return ActivityWidget(
              activity: activities[index],
              feedGroup: widget.feedGroup,
              onHashtagTap: widget.onHashtagTap,
              onMentionTap: widget.onMentionTap,
              onUserTap: widget.onUserTap,
              nameJsonKey: widget.nameJsonKey,
              handleJsonKey: widget.handleJsonKey,
              activityHeaderBuilder: widget.activityHeaderBuilder,
              activityFooterBuilder: widget.activityFooterBuilder,
              activityContentBuilder: widget.activityContentBuilder,
              onActivityTap: (context, activity) {
                // onActivityTap != null
                //     ? onActivityTap?.call(context, activity)
                // TODO: provide a way to load via url / ModalRoute.of(context).settings with ActivityCore (todo)
                _pageRouteBuilder(
                  activity: activity,
                  context: context,
                  transitionType: widget.transitionType,
                  currentNavigator: Navigator.of(context),
                  page: Scaffold(
                    appBar: AppBar(
                      // TODO: Parameterize me
                      title: const Text('Post'),
                    ),
                    body: CommentView(
                      feedGroup: widget.feedGroup,
                      nameJsonKey: widget.nameJsonKey,
                      handleJsonKey: widget.handleJsonKey,
                      activity: activity,
                      enableCommentFieldButton: true,
                      enableReactions: true,
                      textEditingController:
                          TextEditingController(), //TODO: move this into props for customisation like buildSpans
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      feedGroup: widget.feedGroup,
    );
  }

  void _pageRouteBuilder({
    required BuildContext context,
    required TransitionType transitionType,
    required GenericEnrichedActivity activity,
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
