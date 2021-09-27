# `ReactionsListCore`

[ReactionListCore] is a simplified class that allows fetching a list of
reactions while exposing UI builders.

## Background

When developing a feeds application you are likely to want to display a list of reactions to various activities in a feed. `ReactionsListCore()` makes it easy to fetch the reactions to an activity while allowing you to build your own user interfaces to represent the reactions.

## Constructor
```dart
const ReactionListCore({
  Key? key,
  required this.reactionsBuilder,
  required this.lookupValue,
  this.onErrorWidget = const ErrorStateWidget(),
  this.onProgressWidget = const ProgressStateWidget(),
  this.onEmptyWidget =
      const EmptyStateWidget(message: 'No comments to display'),
  this.lookupAttr = LookupAttribute.activityId,
  this.filter,
  this.flags,
  this.kind,
  this.limit,
}) : super(key: key);
```

## Properties
```dart
/// A builder that allows building a ListView of Reaction based Widgets
final ReactionsBuilder reactionsBuilder;

/// A builder for building widgets to show on error
final Widget onErrorWidget;

/// A builder for building widgets to show on progress
final Widget onProgressWidget;

/// A builder for building widgets to show on empty
final Widget onEmptyWidget;

/// Lookup objects based on attributes
final LookupAttribute lookupAttr;

/// TODO: document me
final String lookupValue;

/// {@macro filter}
final Filter? filter;

/// The flags to use for the request
final EnrichmentFlags? flags;

/// The limit of activities to fetch
final int? limit;

/// All reactions being displayed will be of the same type when `kind` 
/// is specified.
final String? kind;
```

## Example Usage
```dart
class FlatActivityListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactionListCore(
        onErrorWidget: Center(
          child: Text('An error has occurred'),
        ),
        onEmptyWidget: Center(
          child: Text('Nothing here...'),
        ),
        onProgressWidget: Center(
          child: CircularProgressIndicator(),
        ),
        feedBuilder: (context, reactions, idx) {
          return YourReactionWidget(reaction: reactions[idx]);
        }
      ),
    );
  }
}
```

## More Information

For more information on `ReactionsListCore()`, check out the [source code]() and the pub.dev [documentation]()