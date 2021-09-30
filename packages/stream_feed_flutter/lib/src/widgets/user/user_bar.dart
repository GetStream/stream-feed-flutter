import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/user_bar_theme.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/human_readable_timestamp.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/src/widgets/user/username.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template userBar}
/// Displays the user's name, profile picture, and a timestamp at which the
/// user posted the message.
/// {@endtemplate}
class UserBar extends StatelessWidget {
  /// Builds a [UserBar].
  ///
  /// {@macro userBar}
  const UserBar({
    Key? key,
    required this.timestamp,
    required this.kind,
    required this.user,
    this.onUserTap,
    this.reactionIcon,
    this.afterUsername,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
    this.subtitle,
    this.showSubtitle = true,
  }) : super(key: key);

  /// {@template userBar.user}
  /// The user whose bar is being displayed.
  /// {@endtemplate}
  final User user;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  /// {@template userBar.reactionIcon}
  /// The reaction icon to display next to the user's name (if any)
  /// {@endtemplate}
  final Widget? reactionIcon;

  /// {@template userBar.afterUsername}
  /// The widget to display after the user's name.
  /// {@endtemplate}
  final Widget? afterUsername;

  /// {@template userBar.subtitle}
  /// The subtitle of the user bar if any.
  /// {@endtemplate}
  final Widget? subtitle;

  /// {@template userBar.handleJsonKey}
  /// The json key for the user's handle.
  /// {@endtemplate}
  final String handleJsonKey;

  /// {@template userBar.nameJsonKey}
  /// The json key for the user's name.
  /// {@endtemplate}
  final String nameJsonKey;

  /// {@template userBar.timestamp}
  /// The time at which the user posted the message.
  /// {@endtemplate}
  final DateTime timestamp;

  /// {@template userBar.kind}
  /// The reaction kind to display.
  /// {@endtemplate}
  final String kind;

  /// {@template userBar.showSubtitle}
  /// Whether or not to show the subtitle.
  /// {@endtemplate}
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    // If handle is null, show name. If both are null, show
    // an empty string.
    final displayName = user.data?[handleJsonKey] as String? ??
        user.data?[nameJsonKey] as String?;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Avatar(
            user: user,
            onUserTap: onUserTap,
            size: UserBarTheme.of(context).avatarSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Username(
                user: user,
                nameJsonKey: nameJsonKey,
              ),
              const SizedBox(width: 4),
              if (afterUsername != null) afterUsername!,
              if (showSubtitle && subtitle != null)
                subtitle!
              else if (displayName != null)
                ReactedBy(
                  icon: reactionIcon ?? ReactionByIcon(kind: kind),
                  handleOrUsername: displayName,
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: HumanReadableTimestamp(timestamp: timestamp),
          ),
        )
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('showSubtitle', showSubtitle))
      ..add(StringProperty('kind', kind))
      ..add(DiagnosticsProperty<DateTime>('timestamp', timestamp))
      ..add(StringProperty('nameJsonKey', nameJsonKey))
      ..add(StringProperty('handleJsonKey', handleJsonKey))
      ..add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap))
      ..add(DiagnosticsProperty<User>('user', user));
  }
}

/// {@template reactedBy}
/// Creates a widget to display the user who reacted to an activity/reaction.
/// {@endtemplate}
class ReactedBy extends StatelessWidget {
  /// {@macro reactedBy}
  const ReactedBy({
    Key? key,
    required this.icon,
    required this.handleOrUsername,
  }) : super(key: key);

  /// Icon widget to display.
  final Widget icon;

  /// User's handle or username to display.
  final String handleOrUsername;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 4,
          ),
          const Text('by '), // TODO (anyone): padding?
          Text(handleOrUsername) // TODO (anyone): padding?
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('handleOrUsername', handleOrUsername));
  }
}

/// The reaction icon to display on the kind of reaction.
///
/// {@macro kind_of_reactions_icons}
class ReactionByIcon extends StatelessWidget {
  /// The reaction icon to display on the kind of reaction.
  ///
  /// {@macro kind_of_reactions_icons}
  const ReactionByIcon({
    Key? key,
    required this.kind,
  }) : super(key: key);

  /// {@template kind_of_reactions_icons}
  /// Displays a different icon depending on the reaction kind.
  ///
  /// - 'like' : [StreamSvgIcon.loveActive()]
  /// - 'repost' : [StreamSvgIcon.repost()]
  /// {@endtemplate}
  final String kind;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case 'like':
        return StreamSvgIcon.loveActive();
      case 'repost':
        return StreamSvgIcon.repost();
      default:
        return const Offstage();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('kind', kind));
  }
}
