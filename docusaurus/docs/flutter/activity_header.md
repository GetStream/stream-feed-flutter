# `ActivityHeader`

This widget represents the heading of an activity and contains the user's name and profile image.

## Background

This widget builds a `UserBar()`, which is a custom widget for displaying a user's username and profile image. To learn more about `UserBar()`, click [here]().

## Constructor

Let's take a look at the constructor for `ActivityHeader`:

```dart
const ActivityHeader({
  Key? key,
  required this.activity,
  this.onUserTap,
  this.activityKind = 'like',
  this.showSubtitle = true,
  this.handleJsonKey = 'handle',
  this.nameJsonKey = 'name',
}) : super(key: key);
```

## Properties

Let's break down the arguments that the `ActivityHeader` constructor takes:

```dart
final DefaultEnrichedActivity activity;
```

This is the activity to display. Read more about `DefaultEnrichedActivity` [here](). <!--TODO: add link -->


```dart
/// A callback to handle username taps
final OnUserTap? onUserTap;

/// Whether to show the widget subtitle or not
final bool showSubtitle;

/// The json key for the user's handle.
final String handleJsonKey;

/// The json key for the user's name.
final String nameJsonKey;

/// The kind of activity to display.
///
/// Can be 'like', 'repost', 'post', etc.
final String activityKind;
```

The `typedef` definition for `OnUserTap` is 
```dart
typedef OnUserTap = void Function(User? user);
```