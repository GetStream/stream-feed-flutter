# `ReactionListPage`

Renders a list of reactions to a post.

## Background

It is often useful in social applications to display a list of reactions (replies) to a post. `ReactionListPage` does this for you by making use of the `ReactionListCore` widget from our `stream_feed_flutter_core` package.

## Constructor
```dart
ReactionListPage({
  Key? key,
  required this.activity,
  this.onReactionTap,
  this.onHashtagTap,
  this.onMentionTap,
  this.onUserTap,
  required this.reactionBuilder,
  this.onErrorWidget = const ErrorStateWidget(),
  this.onProgressWidget = const ProgressStateWidget(),
  this.onEmptyWidget =
      const EmptyStateWidget(message: 'No comments to display'),
  this.flags,
  this.lookupAttr = LookupAttribute.activityId,
  String? lookupValue,
  this.filter,
  this.limit,
  this.kind,
})  : _lookupValue = lookupValue ?? activity.id!,
      super(key: key);
```

## Properties

```dart
/// The activity to display notifications for.
final EnrichedActivity activity;

/// A callback to handle reaction taps
final OnReactionTap? onReactionTap;

/// A callback to handle hashtag taps
final OnHashtagTap? onHashtagTap;

/// A callback to handle mention taps
final OnMentionTap? onMentionTap;

/// A callback to handle user taps
final OnUserTap? onUserTap;

/// The callback to invoke when a reaction is added.
final ReactionBuilder reactionBuilder;

/// The widget to display if there is an error.
final Widget onErrorWidget;

/// The widget to display while loading is in progress.
final Widget onProgressWidget;

/// The widget to display if there is no data.
final Widget onEmptyWidget;

/// The flags to use for the request
final EnrichmentFlags? flags;

/// The attribute to perform "lookups" with.
/// 
/// "Lookups" are when you want to retrieve all reactions to a post
/// that meet a specific criteria. See [LookupAttribute] for the types of
/// criteria you can use.
final LookupAttribute lookupAttr;

/// The filter to use for the request
final Filter? filter;

/// The limit of activities to fetch
final int? limit;

/// All reactions being displayed will be of the same type when `kind` 
/// is specified.
final String? kind;
```

---

Check out the source code for `ReactionListPage` [here]()

Check out the pub.dev documentation for `ReactionListPage` [here]()