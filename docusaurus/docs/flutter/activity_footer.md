# `ActivityFooter`

Displays footer content for an activity

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