# `UserBar`

Displays the user's name, profile picture, and a timestamp at which the
user posted the message.

## Background
It is useful in social feeds to be able to see who posted the content being viewed and when it was posted. The `UserBar()` widget makes it easy for developers to add this functionality to Flutter applications.

## Constructor
```dart
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
```

## Properties
```dart
/// The User whose bar is being displayed.
final User user;

///{@macro user_callback}
final OnUserTap? onUserTap;

/// The reaction icon to display next to the user's name (if any)
final Widget? reactionIcon;

/// The widget to display after the user's name.
final Widget? afterUsername;

/// The subtitle of the user bar if any
final Widget? subtitle;

/// The json key for the user's handle.
final String handleJsonKey;

/// The json key for the user's name.
final String nameJsonKey;

/// The time at which the user posted the message.
final DateTime timestamp;

/// The reaction kind to display.
final String kind;

/// Whether or not to show the subtitle.
final bool showSubtitle;
```