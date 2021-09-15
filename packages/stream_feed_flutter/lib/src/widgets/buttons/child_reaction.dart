import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/child_reaction_theme.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

///{@template child_reaction_button}
/// Used to trigger a reaction.
///
/// It displays the number of reactions it has received and the reaction
/// it is currently displaying.
///{@endtemplate}
class ChildReactionButton extends StatelessWidget {
  /// Builds a [ChildReactionButton].
  const ChildReactionButton({
    Key? key,
    required this.kind,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.reaction,
    this.hoverColor,
    this.onTap,
    this.data,
  }) : super(key: key);

  /// The reaction received from stream that should be liked when pressing
  /// the LikeButton.
  final Reaction reaction;

  /// The callback to be performed on tap.
  ///
  /// This is generally not to be overridden, but can be done if developers
  /// wish.
  final VoidCallback? onTap;

  /// The kind of reaction that should be displayed.
  final String kind;

  /// The button to display if the user has already reacted
  final Widget activeIcon;

  /// The button to display if the user didn't react yet
  final Widget inactiveIcon;

  /// The data to send along with this reaction.
  final Map<String, Object>? data;

  /// The color to use when the user hovers over the button.
  ///
  /// Generally applies to desktop and web.
  final Color? hoverColor;

  @override
  Widget build(BuildContext context) {
    return ChildReactionToggleIcon(
      count: reaction.childrenCounts?[kind],
      ownReactions: reaction.ownChildren?[kind],
      reaction: reaction,
      activeIcon: activeIcon,
      inactiveIcon: inactiveIcon,
      hoverColor: hoverColor ?? ChildReactionTheme.of(context).hoverColor,
      kind: kind,
      onTap: onTap,
      data: data,
    );
  }
}

//TODO: get rid of this now that it is reactive it should work
class ChildReactionToggleIcon extends StatefulWidget {
  //TODO: see what we can extract from a parent widget and put in core
  /// Builds a [ChildReactionToggleIcon].
  const ChildReactionToggleIcon({
    Key? key,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.kind,
    required this.reaction,
    this.targetFeeds,
    this.data,
    this.onTap,
    this.ownReactions,
    this.hoverColor,
    this.count,
    this.userId,
  }) : super(key: key);

  /// The reactions belonging to the current user
  final List<Reaction>? ownReactions;

  /// The icon to display if the current user has already reacted, with this
  /// reaction kind, to this activity.
  final Widget activeIcon;

  /// The icon to display if the current user did not react yet, with this
  /// reaction kind, to this activity.
  final Widget inactiveIcon;

  /// The kind of reaction
  final String kind;

  /// The reaction count
  final int? count;

  /// The callback to be performed when the user clicks on the reaction icon.
  final VoidCallback? onTap;

  /// TODO: document me
  final String? userId;

  /// TODO: document me
  final Map<String, Object>? data;

  /// TODO: document me
  final List<FeedId>? targetFeeds;

  /// TODO: document me
  final Color? hoverColor;

  /// TODO: document me
  final Reaction reaction;

  @override
  State<ChildReactionToggleIcon> createState() =>
      _ChildReactionToggleIconState();
}

class _ChildReactionToggleIconState extends State<ChildReactionToggleIcon> {
  late bool alreadyReacted;
  late List<Reaction?>? reactionsKind;
  late String? idToRemove;
  late int count;

  @override
  void initState() {
    super.initState();
    reactionsKind = widget.ownReactions?.filterByKind(widget.kind);
    alreadyReacted = reactionsKind?.isNotEmpty != null;
    idToRemove = reactionsKind?.last?.id;
    count = widget.count ?? 0;
  }

  Widget get displayedIcon =>
      alreadyReacted ? widget.activeIcon : widget.inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return ReactionIcon(
      hoverColor:
          widget.hoverColor ?? ChildReactionTheme.of(context).toggleColor,
      icon: displayedIcon,
      count: count,
      onTap: () async {
        widget.onTap?.call ?? await onToggleChildReaction();
      },
    );
  }

  Future<void> onToggleChildReaction() async {
    alreadyReacted ? await onRemoveChildReaction() : await onAddChildReaction();
  }

  Future<void> onAddChildReaction() async {
    final reaction = await FeedBlocProvider.of(context).bloc.onAddChildReaction(
          //TODO: get rid of mutations in StreamFeedProvider
          reaction: widget.reaction,
          kind: widget.kind,
          data: widget.data,
        );

    setState(() {
      alreadyReacted = !alreadyReacted;
      idToRemove = reaction.id;
      count += 1;
    });
  }

  Future<void> onRemoveChildReaction() async {
    await FeedBlocProvider.of(context).bloc.onRemoveChildReaction(
          kind: widget.kind,
          reaction: widget.reaction,
          // activity: idToRemove!,
        );
    setState(() {
      alreadyReacted = !alreadyReacted;
      count -= 1;
    });
  }
}
