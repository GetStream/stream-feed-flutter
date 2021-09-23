# `RepostButton`

A Repost Button is a widget that allows a user to repost a feed item. When pressed it will post a new item with the same content as the original.

## Background

In a social feed it is often useful for users to be able to "repost" content found in the feed. The `RepostButton()` widget makes it easy for developers to add this functionality to Flutter applications.

## Constructor
```dart
const RepostButton({
  Key? key,
  required this.activity,
  this.feedGroup = 'user',
  this.reaction,
  this.onTap,
  this.inactiveIcon,
  this.activeIcon,
}) : super(key: key);
```

## Properties
```dart
/// The icon to display when a post has been liked by the current user.
final Widget? activeIcon;

/// The icon to display when a post has not yet been liked by the current
/// user.
final Widget? inactiveIcon;

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

/// The feed group that the activity belongs to.
final String feedGroup;
```