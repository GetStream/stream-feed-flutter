import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

///{@template child_reaction_button}
/// A Reaction Button is a widget that can be used to trigger a reaction.
/// It displays the count of reactions it has received and the reaction
/// it is currently displaying.
///{@endtemplate}
class ChildReactionButton extends StatelessWidget {
  ///{@macro child_reaction_button}
  const ChildReactionButton({
    Key? key,
    required this.kind,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.reaction,
    this.hoverColor = Colors.lightBlue,
    this.onTap,
    this.data,
  }) : super(key: key);

  ///The reaction received from stream that should be liked when pressing the LikeButton.
  final Reaction reaction;

  ///If you want to override on tap for some reasons
  final VoidCallback? onTap;

  /// The kind of reaction that should be displayed.
  final String kind;

  /// The button to display if the user already reacted
  final Widget activeIcon;

  /// The button to display if the user didn't reacted yet
  final Widget inactiveIcon;

  /// The data to send along with this reaction.
  final Map<String, Object>? data;

  /// The color to use when the user hovers over the button. (desktop/web)
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    return ChildReactionToggleIcon(
      count: reaction.childrenCounts?[kind],
      ownReactions: reaction.ownChildren?[kind],
      reaction: reaction,
      activeIcon: activeIcon,
      inactiveIcon: inactiveIcon,
      hoverColor: hoverColor,
      kind: kind,
      onTap: onTap,
      data: data,
    );
  }
}

class ChildReactionToggleIcon extends StatefulWidget {
  ///The reactions belongin to the current user
  final List<Reaction>? ownReactions;

  /// The icon to display if you already reacted, with this rreaction kind, to this activity
  final Widget activeIcon;

  /// The icon to display if you did not reacted yet, with this rreaction kind, to this activity
  final Widget inactiveIcon;

  /// The kind of reaction
  final String kind;

  /// The reaction count
  final int? count;

  /// A callback that will be called when the user clicks on the reaction icon
  final VoidCallback? onTap;

  final String? userId;
  final Map<String, Object>? data;
  final List<FeedId>? targetFeeds;
  final Color hoverColor;
  final Reaction reaction;
  //TODO: see what we can extract from a parent widget and put in core
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
    this.hoverColor = Colors.lightBlue,
    this.count,
    this.userId,
  }) : super(key: key);

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
      hoverColor: widget.hoverColor,
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
    final reaction = await StreamFeedProvider.of(context).onAddChildReaction(//TODO: get rid of mutations in StreamFeedProvider 
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
    await StreamFeedProvider.of(context).onRemoveChildReaction(//TODO: get rid of mutations in StreamFeedProvider 
      kind: widget.kind,
      reaction: widget.reaction,
      id: idToRemove!,
    );
    setState(() {
      alreadyReacted = !alreadyReacted;
      count -= 1;
    });
  }
}
