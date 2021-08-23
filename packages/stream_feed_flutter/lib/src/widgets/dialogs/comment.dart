import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/comment/item.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:stream_feed_flutter/src/widgets/pages/reaction_list.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template alert_dialog}
/// An Alert Dialog that displays an activity and a comment field.
///{@endtemplate}
class AlertDialogComment extends StatelessWidget {
  /// Builds an [AlertDialogComment].
  const AlertDialogComment({
    Key? key,
    required this.feedGroup,
    this.activity,
  }) : super(key: key);

  /// The feed group/slug that is being commented on.
  final String feedGroup;

  /// The activity that is being commented on.
  final EnrichedActivity? activity;

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();
    return AlertDialog(
      actions: [
        AlertDialogActions(
          activity: activity,
          feedGroup: feedGroup,
          textEditingController: textEditingController,
        ),
      ],
      content: CommentView(
        activity: activity,
        feedGroup: feedGroup,
        textEditingController: textEditingController,
      ),
    );
  }
}

///{@template comment_view}
/// A Comment View is a widget that shows the activity and a comment field and reactions (if enabled)
///{@endtemplate}
class CommentView extends StatelessWidget {
  //TODO: merge this with StreamFeedActivity
  ///{@macro comment_view}
  const CommentView({
    Key? key,
    required this.textEditingController,
    this.activity,
    this.feedGroup = 'user',
    this.onReactionTap,
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.enableReactions = false,
    this.enableCommentFieldButton = false,
  }) : super(key: key);

  final EnrichedActivity? activity;
  final String feedGroup;
  final TextEditingController textEditingController;
  final bool enableReactions;

  ///{@macro reaction_callback}
  final OnReactionTap? onReactionTap;

  ///{@macro hashtag_callback}
  final OnHashtagTap? onHashtagTap;

  ///{@macro mention_callback}
  final OnMentionTap? onMentionTap;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  final bool enableCommentFieldButton;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //TODO: "this post has been deleted by the author"
          if (activity != null) ...[
            ActivityWidget(
              activity: activity!,
              feedGroup: feedGroup,
            )
            //TODO: analytics
            //TODO: "in response to" activity.to
          ],
          CommentField(
            textEditingController: textEditingController,
            activity: activity,

            //enabled in actions [RightActions]
            enableButton: enableCommentFieldButton,
            feedGroup: feedGroup,
          ),
          //TODO: builder for using it elsewhere than in actions
          if (enableReactions && activity != null)
            ReactionListPage(
                //TODO: extract to CommentList
                feedGroup: feedGroup,
                activity: activity,
                onReactionTap: onReactionTap,
                onHashtagTap: onHashtagTap,
                onMentionTap: onMentionTap,
                onUserTap: onUserTap,
                flags: EnrichmentFlags()
                    .withReactionCounts()
                    .withOwnChildren()
                    .withOwnReactions(), //TODO: refactor this?
                reactionBuilder: (context, reaction) => CommentItem(
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
}

///{@template alert_dialog_actions}
/// The Actions displayed in the dialog i.e. medias, gif, emojis etc.
///{@endtemplate}
class AlertDialogActions extends StatelessWidget {
  ///{@macro alert_dialog_actions}
  const AlertDialogActions({
    Key? key,
    this.activity,
    this.targetFeeds,
    required this.feedGroup,
    required this.textEditingController,
  }) : super(key: key);
  final EnrichedActivity? activity;
  final List<FeedId>? targetFeeds;
  final String feedGroup;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          LeftActions(), //TODO: upload controller thingy
          RightActions(
            textEditingController: textEditingController,
            activity: activity, //TODO: upload controller thingy
            targetFeeds: targetFeeds,
            feedGroup: feedGroup,
          ),
        ],
      ),
    );
  }
}

///{@template left_actions}
/// Actions on the left side of the dialog i.e. medias, gif, emojis etc.
/// {@endtemplate}
class LeftActions extends StatelessWidget {
  ///{@macro left_actions}
  const LeftActions({
    Key? key,
    this.spaceBefore = 60,
    this.spaceBetween = 8.0,
  }) : super(key: key);
  final double spaceBefore; //useful for reddit style clone
  final double spaceBetween;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: spaceBefore, //TODO: compute this based on media query size
      child: Row(
        children: [
          //TODO: actual emojis, upload images, gif, etc
          MediasAction(), //TODO: push an other dialog open file explorer take file uri upload it using sdk and it to attachments (sent in RightActions/PostCommentButton)
          SizedBox(width: spaceBetween),
          EmojisAction(), //TODO: push an other dialog and display a nice grid of emojis, add selected emoji to text controller
          SizedBox(width: spaceBetween),
          GIFAction(), //TODO: push an other dialog and display gif in a card and it to list of attachments
        ],
      ),
    );
  }
}

///{@template right_actions}
/// Actions on the right side of the dialog i.e. "Post" button.
/// {@endtemplate}
class RightActions extends StatelessWidget {
  ///{@macro right_actions}
  const RightActions({
    Key? key,
    required this.textEditingController,
    this.activity,
    required this.feedGroup,
    this.targetFeeds,
  }) : super(key: key);
  final EnrichedActivity? activity;
  final TextEditingController textEditingController;
  final String feedGroup;
  final List<FeedId>? targetFeeds;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        //TODO: Row : show progress (if textInputValue.length> 0) if number of characters restricted
        child: PostCommentButton(
          feedGroup: feedGroup,
          activity: activity,
          targetFeeds: targetFeeds,
          textEditingController: textEditingController,
        ));
  }
}
