# `ActivityContent`

A widget that displays the content of an activity

## Background

## Constructor
```dart
const ActivityContent({
  Key? key,
  required this.activity,
  this.onMentionTap,
  this.commentJsonKey = 'comment',
  this.onHashtagTap,
}) : super(key: key);
```

## Properties

```dart
/// The activity that is being displayed.
final DefaultEnrichedActivity activity;

/// A callback to handle mention taps
final OnMentionTap? onMentionTap;

/// A callback to handle hashtag taps
final OnHashtagTap? onHashtagTap;

/// The json key for the comment
final String commentJsonKey;
```

The `typedef` for `OnMentionTap` is
```dart
typedef OnMentionTap = void Function(String? mention);
```

The `typedef` for `OnHashtagTap` is 
```dart
typedef OnHashtagTap = void Function(String? hashtag);
```

---

View the `ActivityContent()` source code [here]() <!--TODO: add link -->

View the pub.dev documentation for `ActivityContent()` [here]() <!--TODO: add link -->