import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/comment/item.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:stream_feed_flutter/src/widgets/pages/reaction_list.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template alert_dialog}
/// An Alert Dialog that displays an activity and a comment field.
/// {@endtemplate}
class AlertDialogComment extends StatelessWidget {
  /// Builds an [AlertDialogComment].
  const AlertDialogComment({
    Key? key,
    required this.feedGroup,
    required this.feedType,
    this.activity,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
  }) : super(key: key);

  /// The feed group/slug that is being commented on.
  final String feedGroup;

  /// The type of feed the activity will be posted to.
  final FeedType feedType;

  /// The activity that is being commented on.
  final DefaultEnrichedActivity? activity;

  /// TODO: document me
  final String handleJsonKey;

  /// TODO: document me
  final String nameJsonKey;

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();
    return AlertDialog(
      actions: [
        AlertDialogActions(
          feedType: feedType,
          activity: activity,
          feedGroup: feedGroup,
          textEditingController: textEditingController,
        ),
      ],
      content: CommentView(
        activity: activity,
        feedGroup: feedGroup,
        textEditingController: textEditingController,
        nameJsonKey: nameJsonKey,
        handleJsonKey: handleJsonKey,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(
        DiagnosticsProperty<DefaultEnrichedActivity?>('activity', activity));
    properties.add(StringProperty('handleJsonKey', handleJsonKey));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(EnumProperty<FeedType>('feedType', feedType));
  }
}

/// {@template comment_view}
/// A Comment View is a widget that shows the activity and a comment field and
/// reactions (if enabled).
/// {@endtemplate}
class CommentView extends StatelessWidget {
  //TODO: merge this with StreamFeedActivity
  /// Builds a [CommentView].
  const CommentView({
    Key? key,
    required this.textEditingController,
    this.activity,
    this.feedGroup = 'user',
    this.feedType = FeedType.flat,
    this.onReactionTap,
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.enableReactions = false,
    this.enableCommentFieldButton = false,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
  }) : super(key: key);

  /// TODO: document me
  final DefaultEnrichedActivity? activity;

  /// TODO: document me
  final String feedGroup;

  /// TODO: document me
  final TextEditingController textEditingController;

  /// TODO: document me
  final bool enableReactions;

  /// {@macro reaction_callback}
  final OnReactionTap? onReactionTap;

  /// {@macro hashtag_callback}
  final OnHashtagTap? onHashtagTap;

  /// {@macro mention_callback}
  final OnMentionTap? onMentionTap;

  /// {@macro user_callback}
  final OnUserTap? onUserTap;

  /// TODO: document me
  final bool enableCommentFieldButton;

  /// TODO: document me
  final String handleJsonKey;

  /// TODO: document me
  final String nameJsonKey;

  /// The type of feed the activity will be posted to.
  final FeedType feedType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //TODO: "this post has been deleted by the author"
          if (activity != null) ...[
            StreamBuilder(
              stream: DefaultFeedBlocProvider.of(context).bloc.activitiesStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return ActivityWidget(
                  activity: activity!,
                  feedGroup: feedGroup,
                  nameJsonKey: nameJsonKey,
                  handleJsonKey: handleJsonKey,
                );
              },
            )
            //TODO: analytics
            //TODO: "in response to" activity.to
          ],
          CommentField(
            feedType: feedType,
            textEditingController: textEditingController,
            activity: activity,

            //enabled in actions [RightActions]
            enableButton: enableCommentFieldButton,
            feedGroup: feedGroup,
          ),
          //TODO: builder for using it elsewhere than in actions
          if (enableReactions && activity != null)
            ReactionListPage(
                activity: activity!,
                onReactionTap: onReactionTap,
                onHashtagTap: onHashtagTap,
                onMentionTap: onMentionTap,
                onUserTap: onUserTap,
                kind: 'comment',
                flags: EnrichmentFlags()
                    .withReactionCounts()
                    .withOwnChildren()
                    .withOwnReactions(), //TODO: refactor this?
                reactionBuilder: (context, reaction) => CommentItem(
                      activity: activity!,
                      user: reaction.user,
                      reaction: reaction,
                      onReactionTap: onReactionTap,
                      onHashtagTap: onHashtagTap,
                      onMentionTap: onMentionTap,
                      onUserTap: onUserTap,
                    ))
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<DefaultEnrichedActivity?>('activity', activity));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textEditingController', textEditingController));
    properties
        .add(DiagnosticsProperty<bool>('enableReactions', enableReactions));
    properties.add(
        ObjectFlagProperty<OnReactionTap?>.has('onReactionTap', onReactionTap));
    properties.add(
        ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap));
    properties.add(
        ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap));
    properties.add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap));
    properties.add(DiagnosticsProperty<bool>(
        'enableCommentFieldButton', enableCommentFieldButton));
    properties.add(StringProperty('handleJsonKey', handleJsonKey));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(EnumProperty<FeedType>('feedType', feedType));
  }
}

/// {@template alert_dialog_actions}
/// The Actions displayed in the dialog i.e. medias, gif, emojis etc.
/// {@endtemplate}
class AlertDialogActions extends StatelessWidget {
  /// Builds an [AlertDialogActions].
  const AlertDialogActions({
    Key? key,
    this.activity,
    this.targetFeeds,
    required this.feedGroup,
    required this.feedType,
    required this.textEditingController,
  }) : super(key: key);

  /// TODO: document me
  final DefaultEnrichedActivity? activity;

  /// TODO: document me
  final List<FeedId>? targetFeeds;

  /// TODO: document me
  final String feedGroup;

  /// The type of feed the activity will be posted to.
  final FeedType feedType;

  /// TODO: document me
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          const LeftActions(), //TODO: upload controller thingy
          RightActions(
            feedType: feedType,
            textEditingController: textEditingController,
            activity: activity, //TODO: upload controller thingy
            targetFeeds: targetFeeds,
            feedGroup: feedGroup,
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<EnrichedActivity?>('activity', activity));
    properties.add(IterableProperty<FeedId>('targetFeeds', targetFeeds));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textEditingController', textEditingController));
        properties.add(EnumProperty<FeedType>('feedType', feedType));
  }
}

/// {@template left_actions}
/// Actions on the left side of the dialog i.e. medias, gif, emojis etc.
/// {@endtemplate}
class LeftActions extends StatelessWidget {
  /// Builds a [LeftActions].
  const LeftActions({
    Key? key,
    this.spaceBefore = 60,
    this.spaceBetween = 8.0,
  }) : super(key: key);

  /// TODO: document me
  final double spaceBefore;

  /// TODO: document me
  //useful for reddit style clone
  final double spaceBetween;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: spaceBefore, //TODO: compute this based on media query size
      child: Row(
        children: [
          //TODO: actual emojis, upload images, gif, etc
          const MediasAction(), //TODO: push an other dialog open file explorer take file uri upload it using sdk and it to attachments (sent in RightActions/PostCommentButton)
          SizedBox(width: spaceBetween),
          const EmojisAction(), //TODO: push an other dialog and display a nice grid of emojis, add selected emoji to text controller
          SizedBox(width: spaceBetween),
          const GIFAction(), //TODO: push an other dialog and display gif in a card and it to list of attachments
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('spaceBefore', spaceBefore));
    properties.add(DoubleProperty('spaceBetween', spaceBetween));
  }
}

/// {@template right_actions}
/// Actions on the right side of the dialog i.e. "Post" button.
/// {@endtemplate}
class RightActions extends StatelessWidget {
  /// Builds a [RighActions].
  const RightActions({
    Key? key,
    required this.textEditingController,
    this.activity,
    required this.feedGroup,
    required this.feedType,
    this.targetFeeds,
  }) : super(key: key);

  /// TODO: document me
  final DefaultEnrichedActivity? activity;

  /// TODO: document me
  final TextEditingController textEditingController;

  /// TODO: document me
  final String feedGroup;

  /// The type of feed the activity will be posted to.
  final FeedType feedType;

  /// TODO: document me
  final List<FeedId>? targetFeeds;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        //TODO: Row : show progress (if textInputValue.length> 0) if number of characters restricted
        child: PostCommentButton(
          feedType: feedType,
          feedGroup: feedGroup,
          activity: activity,
          targetFeeds: targetFeeds,
          textEditingController: textEditingController,
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<EnrichedActivity?>('activity', activity));
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textEditingController', textEditingController));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(IterableProperty<FeedId>('targetFeeds', targetFeeds));
    properties.add(EnumProperty<FeedType>('feedType', feedType));
  }
}
