import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/child_reaction_theme.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

// ignore_for_file: cascade_invocations

/// {@template child_reaction_button}
/// Used to trigger a reaction.
///
/// It displays the number of reactions it has received and the reaction
/// it is currently displaying.
/// {@endtemplate}
class ChildReactionButton extends StatelessWidget {
  /// Builds a [ChildReactionButton].
  const ChildReactionButton({
    Key? key,
    required this.kind,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.reaction,
    required this.activity,
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

  final EnrichedActivity activity;

  @override
  Widget build(BuildContext context) {
    return ChildReactionToggleIcon(
      activity: activity,
      count: reaction.childrenCounts?[kind] ?? 0,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Reaction>('reaction', reaction));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(StringProperty('kind', kind));
    properties.add(DiagnosticsProperty<Map<String, Object>?>('data', data));
    properties.add(ColorProperty('hoverColor', hoverColor));
  }
}

//TODO: get rid of this now that it is reactive it should work
class ChildReactionToggleIcon extends StatelessWidget {
  //TODO: see what we can extract from a parent widget and put in core
  /// Builds a [ChildReactionToggleIcon].
  const ChildReactionToggleIcon({
    Key? key,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.kind,
    required this.reaction,
    required this.activity,
    this.targetFeeds,
    this.data,
    this.onTap,
    this.ownReactions,
    this.hoverColor,
    required this.count,
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
  final int count;

  //TODO:document me
  final EnrichedActivity activity;

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

  bool get alreadyReacted => reactionsKind?.isNotEmpty != null;
  List<Reaction?>? get reactionsKind => ownReactions?.filterByKind(kind);

  Widget get displayedIcon => alreadyReacted ? activeIcon : inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return ReactionIcon(
      hoverColor: hoverColor ?? ChildReactionTheme.of(context).toggleColor,
      icon: displayedIcon,
      count: count,
      onTap: () async {
        onTap?.call ?? await onToggleChildReaction(context);
      },
    );
  }

  Future<void> onToggleChildReaction(BuildContext context) async {
    alreadyReacted
        ? await onRemoveChildReaction(context)
        : await onAddChildReaction(context);
  }

  Future<void> onAddChildReaction(BuildContext context) async {
    await DefaultFeedBlocProvider.of(context).bloc.onAddChildReaction(
        //TODO: get rid of mutations in StreamFeedProvider
        reaction: reaction,
        kind: kind,
        data: data,
        activity: activity);
  }

  Future<void> onRemoveChildReaction(BuildContext context) async {
    await DefaultFeedBlocProvider.of(context).bloc.onRemoveChildReaction(
        kind: kind, reaction: reaction, activity: activity
        // activity: idToRemove!,
        );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Reaction>('ownReactions', ownReactions));
    properties.add(StringProperty('kind', kind));
    properties.add(IntProperty('count', count));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(StringProperty('userId', userId));
    properties.add(DiagnosticsProperty<Map<String, Object>?>('data', data));
    properties.add(IterableProperty<FeedId>('targetFeeds', targetFeeds));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DiagnosticsProperty<Reaction>('reaction', reaction));
  }
}
