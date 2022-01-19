import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/reaction_theme.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
// ignore_for_file: cascade_invocations

/// {@template reaction_button}
/// A widget that can be used to trigger a reaction.
///
/// Displays the count of reactions it has received and the reaction
/// it is currently displaying.
/// {@endtemplate}
class ReactionButton extends StatelessWidget {
  /// Builds a [ReactionButton].
  const ReactionButton({
    Key? key,
    required this.activity,
    required this.kind,
    required this.activeIcon,
    required this.inactiveIcon,
    this.feedGroup = 'user',
    this.hoverColor,
    this.reaction,
    this.onTap,
    this.data,
  }) : super(key: key);

  /// The reaction received from Stream that should be liked when pressing
  /// the [LikeButton].
  final Reaction? reaction;

  /// The activity received from Stream that should be liked when pressing
  /// the [LikeButton].
  final EnrichedActivity activity;

  /// The callback to be performed on tap.
  ///
  /// This is generally not to be overridden, but can be done if developers
  /// wish.
  final VoidCallback? onTap;

  /// The kind of reaction that should be displayed.
  final String kind;

  /// The button to display if the current user has already reacted
  final Widget activeIcon;

  /// The button to display if the current user has not reacted yet
  final Widget inactiveIcon;

  /// The data to send along with this reaction.
  final Map<String, Object>? data;

  /// The color to use when the user hovers over the button.
  ///
  /// Generally applies to desktop and web.
  final Color? hoverColor;

  ///The group/slug of the feed to which this reaction will belong.
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return ReactionToggleIcon(
      activity: activity,
      count: reaction?.childrenCounts?[kind] ??
          activity.reactionCounts?[kind] ??
          0,
      ownReactions:
          reaction?.ownChildren?[kind] ?? activity.ownReactions?[kind],
      activeIcon: activeIcon,
      inactiveIcon: inactiveIcon,
      hoverColor: hoverColor ?? ReactionTheme.of(context).hoverColor,
      kind: kind,
      onTap: onTap,
      data: data,
      feedGroup: feedGroup,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Reaction?>('reaction', reaction));
    properties.add(
        DiagnosticsProperty<GenericEnrichedActivity>('activity', activity));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(StringProperty('kind', kind));
    properties.add(DiagnosticsProperty<Map<String, Object>?>('data', data));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(StringProperty('feedGroup', feedGroup));
  }
}

class ReactionToggleIcon extends StatelessWidget {
  //TODO: see what we can extract from a parent widget and put in core
  /// Builds a [ReactionToggleIcon].
  const ReactionToggleIcon({
    Key? key,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.kind,
    required this.activity,
    this.reaction,
    this.targetFeeds,
    this.data,
    this.onTap,
    this.ownReactions,
    this.feedGroup = 'user',
    this.hoverColor,
    required this.count,
    this.userId,
  }) : super(key: key);

  /// The reactions belonging to the current user
  final List<Reaction>? ownReactions;

  /// The icon to display if you already reacted, with this reaction kind,
  /// to this activity
  final Widget activeIcon;

  /// The icon to display if you did not reacted yet, with this reaction kind,
  /// to this activity
  final Widget inactiveIcon;

  /// The kind of reaction
  final String kind;

  /// The reaction count
  final int count;

  /// A callback that will be called when the user clicks on the reaction icon
  final VoidCallback? onTap;

  /// The group/slug of the feed
  final String feedGroup;

  /// TODO: document me
  final EnrichedActivity activity;

  /// TODO: document me
  final Reaction? reaction;

  /// TODO: document me
  final String? userId;

  /// TODO: document me
  final Map<String, Object>? data;

  /// TODO: document me
  final List<FeedId>? targetFeeds;

  /// TODO: document me
  final Color? hoverColor;

  bool get alreadyReacted => ownReactions != null && ownReactions!.isNotEmpty;
  // List<Reaction?>? get reactionsKind => ownReactions?.filterByKind(kind);

  Widget get displayedIcon => alreadyReacted ? activeIcon : inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return ReactionIcon(
      hoverColor: hoverColor ?? ReactionTheme.of(context).toggleHoverColor!,
      icon: displayedIcon,
      count: count,
      onTap: () async {
        onTap?.call ?? await onToggleReaction(context);
      },
    );
  }

  Future<void> onToggleChildReaction(BuildContext context) async {
    alreadyReacted
        ? await FeedProvider.of(context).bloc.onRemoveChildReaction(
              kind: kind,
              activity: activity,
              childReaction: ownReactions!.last,
              parentReaction: reaction!,
            )
        : await FeedProvider.of(context).bloc.onAddChildReaction(
              activity: activity,
              kind: kind,
              data: data,
              reaction: reaction!,
            );
  }

  Future<void> onToggleReaction(BuildContext context) async {
    alreadyReacted
        ? await FeedProvider.of(context).bloc.onRemoveReaction(
              kind: kind,
              activity: activity,
              reaction: reaction!,
              feedGroup: feedGroup,
            )
        : await FeedProvider.of(context).bloc.onAddReaction(
              kind: kind,
              activity: activity,
              feedGroup: feedGroup,
            );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Reaction>('ownReactions', ownReactions));
    properties.add(StringProperty('kind', kind));
    properties.add(IntProperty('count', count));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(
        DiagnosticsProperty<GenericEnrichedActivity>('activity', activity));
    properties.add(StringProperty('userId', userId));
    properties.add(DiagnosticsProperty<Map<String, Object>?>('data', data));
    properties.add(IterableProperty<FeedId>('targetFeeds', targetFeeds));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DiagnosticsProperty<bool>('alreadyReacted', alreadyReacted));
    properties.add(DiagnosticsProperty<Reaction?>('reaction', reaction));
  }
}

/// TODO: document me
class ReactionIcon extends StatelessWidget {
  /// Builds a [ReactionIcon].
  const ReactionIcon({
    Key? key,
    this.count,
    required this.icon,
    this.onTap,
    this.hoverColor,
  }) : super(key: key);

  /// TODO: document me
  final int? count;

  /// TODO: document me
  final Widget icon;

  /// TODO: document me
  final VoidCallback? onTap;

  /// TODO: document me
  final Color? hoverColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: hoverColor ?? ReactionTheme.of(context).iconHoverColor,
      borderRadius: BorderRadius.circular(18), //iconSize
      onTap: onTap,
      child: count != null && count! > 0
          ? Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 6),
                  Center(child: Text('$count'))
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(4),
              child: icon,
            ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ColorProperty('hoverColor', hoverColor));
  }
}
