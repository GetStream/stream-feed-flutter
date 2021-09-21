# `ActivityWidget`

A widget that displays a single activity.

## Background
`stream_feed_flutter` provides an out-of-the-box visual representation of an activity for you that you can customize to your preference. Let's take a look at the constructor for `ActivityWidget()`:

```dart
const ActivityWidget({
  Key? key,
  required this.activity,
  this.feedGroup = 'user',
  this.handleJsonKey = 'handle',
  this.nameJsonKey = 'name',
  this.onHashtagTap,
  this.onMentionTap,
  this.onUserTap,
  this.activityFooterBuilder,
  this.activityContentBuilder,
  this.activityHeaderBuilder,
  this.onActivityTap,
}) : super(key: key);
```

An activity must be passed in, but everything else is optional. Let's go through each of the properties and see what they are for.

## Properties
```dart
/// The activity to display.
final DefaultEnrichedActivity activity;
```
This is the activity to display. Read more about `DefaultEnrichedActivity` [here]().

---

```dart
/// The json key for the user's handle.
final String handleJsonKey;
```
This is a String representing a piece of the JSON for an activity. You can use it to quickly reference that value of the activity's JSON. In this case, that value is the user's *handle*.

---

```dart
/// The json key for the user's name.
final String nameJsonKey;
```
This is a String representing a piece of the JSON for an activity. You can use it to quickly reference that value of the activity's JSON. In this case, that value is the user's *name*.

---

```dart
/// A callback to invoke when a mention is tapped.
final OnMentionTap? onMentionTap;
```

An `OnMentionTap` is a custom typedef function that allows you to specify what should happen when a mention is tapped. By default, this is null. That typedef is as follows:

```dart
typedef OnMentionTap = void Function(String? mention);
```

---

```dart
/// A callback to handle hashtag taps
final OnHashtagTap? onHashtagTap;
```

An `OnHashtagTap` is a custom typedef function that allows you to specify what should happen when a hashtag is tapped. By default, this is null. That typedef is as follows:

```dart
typedef OnHashtagTap = void Function(String? hashtag);
```

---

```dart
/// A callback to handle user taps
final OnUserTap? onUserTap;
```

An `OnUserTap` is a custom typedef function that allows you to specify what should happen when a hashtag is tapped. By default, this is null. That typedef is as follows:

```dart
typedef OnUserTap = void Function(User? user);
```

---

```dart
/// A callback to handle activity taps
final OnActivityTap? onActivityTap;
```

An `OnActivityTap` is a custom typedef function that allows you to specify what should happen when a hashtag is tapped. By default, this is null. That typedef is as follows:

```dart
typedef OnActivityTap = void Function(
    BuildContext context, DefaultEnrichedActivity activity);
```

---

```dart
/// A builder for the activity footer.
final ActivityFooterBuilder? activityFooterBuilder;
```

An `ActivityFooterBuilder` is a custom typedef function that allows you to build the `ActivityFooter` section of the `ActivityWidget` yourself. By default, this is null. That typedef is as follows:

```dart
typedef ActivityFooterBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);
```

---

```dart
/// A builder for the activity content.
final ActivityContentBuilder? activityContentBuilder;
```

An `ActivityContentBuilder` is a custom typedef function that allows you to build the `ActivityContent` section of the `ActivityWidget` yourself. By default, this is null. That typedef is as follows:

```dart
typedef ActivityContentBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);
```

---

```dart
/// A builder for the activity header.
final ActivityHeaderBuilder? activityHeaderBuilder;
```

An `ActivityHeaderBuilder` is a custom typedef function that allows you to build the `ActivityHeader` section of the `ActivityWidget` yourself. By default, this is null. That typedef is as follows:

```dart
typedef ActivityHeaderBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);
```

---

```dart
/// The group of the feed this activity belongs to.
final String feedGroup;
```

This is the feed group that the activity belongs to. If you have created a feed in your dashboard that has an ID other than 'timeline' or 'user', you'll want to include that feed ID as the `feedGroup`


---

`ActivityWidget()` source code

`ActivityWidget()` pub.dev documentation