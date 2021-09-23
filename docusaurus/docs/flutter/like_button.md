# `LikeButton`

A reaction button that displays a "like" icon. It is used to like a post when pressed.

## Background

It is often useful in a social feed to be able to "like" content. The `LikeButton()` widget allows developers to easily add this functionality to Flutter applications.

## Constructor
```dart
const LikeButton({
  Key? key,
  required this.activity,
  this.feedGroup = 'user',
  this.reaction,
  this.onTap,
  this.activeIcon,
  this.inactiveIcon,
  this.hoverColor,
}) : super(key: key);
```

## Properties

```dart
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

/// The icon to display when a post has been liked by the current user.
final Widget? activeIcon;

/// The icon to display when a post has not yet been liked by the current
/// user.
final Widget? inactiveIcon;

/// The feed group that this [LikeButton] is associated with.
final String feedGroup;

/// The color to use when the user hovers over the button.
///
/// Generally applies to desktop and web.
final Color? hoverColor;
```