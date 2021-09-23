# `ReplyButton`

A reaction button that displays a post icon. Used to post a reply to a post when clicked.

## Background

It is often useful in a social feed to be able to reply to content in some fashion. The `ReplyButton()` allows developers to easily add this functionality to Flutter applications. Please note that this button simply shows the amount of replies that currently exist for the content in question and does not bring up any UI related to text entry - you will need to use our "comment" widgets for that, or build your own UI.

## Constructor
```dart
const ReplyButton({
  Key? key,
  this.feedGroup = 'user',
  required this.activity,
  this.reaction,
  this.iconSize = 14,
  this.handleJsonKey = 'handle',
  this.nameJsonKey = 'name',
}) : super(key: key);
```

## Properties
```dart
/// The json key for the user's handle.
final String handleJsonKey;

/// The json key for the user's name.
final String nameJsonKey;

/// The group or slug of the feed to post to.
final String feedGroup;

/// The activity to post to the feed.
final DefaultEnrichedActivity activity;

/// The size of the icon to display.
final double iconSize;
```