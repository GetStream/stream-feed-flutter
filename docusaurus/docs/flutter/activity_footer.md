# `ActivityFooter`

Displays footer content for an activity

## Background

When displaying an activity it is useful to include buttons to perform various actions. This widget includes three buttons: a "like" button, a "repost" button and a "reply" button.

## Constructor
```dart
const ActivityFooter({
  Key? key,
  required this.activity,
  this.feedGroup = 'user',
}) : super(key: key);
```

## Properties
```dart
/// A convenient `typedef` that helps to
/// restrict the type of values accepted by `EnrichedActivity`.
final DefaultEnrichedActivity activity;

/// The feed group that this activity belongs to
final String feedGroup;
```
___

View the source code for `ActivityFooter()` [here]()

View the pub.dev documentation for `ActivityFooter()` [here]()