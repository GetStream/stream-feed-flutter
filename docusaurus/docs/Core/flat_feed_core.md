# `FlatFeedCore`

[FlatFeedCore] is a simplified class that allows fetching a list of
enriched activities (flat) while exposing UI builders.

## Background

When you are building a feeds application you'll want to fetch and display the content for your feed. The `FlatFeedCore()` widget makes it easy to
fetch activities and build your own user interface to display those activities.

## Constructor
```dart
const FlatFeedCore({
  Key? key,
  required this.feedGroup,
  required this.feedBuilder,
  this.onErrorWidget = const ErrorStateWidget(),
  this.onProgressWidget = const ProgressStateWidget(),
  this.limit,
  this.offset,
  this.session,
  this.filter,
  this.flags,
  this.ranking,
  this.userId,
  this.onEmptyWidget =
      const EmptyStateWidget(message: 'No activities to display'),
}) : super(key: key);
```

## Properties
```dart
/// A builder that let you build a ListView of EnrichedActivity based Widgets
final EnrichedFeedBuilder<A, Ob, T, Or> feedBuilder;

/// An error widget to show when an error occurs
final Widget onErrorWidget;

/// A progress widget to show when a request is in progress
final Widget onProgressWidget;

/// A widget to show when the feed is empty
final Widget onEmptyWidget;

/// The limit of activities to fetch
final int? limit;

/// The offset of activities to fetch
final int? offset;

/// The session to use for the request
final String? session;

/// The filter to use for the request
final Filter? filter;

/// The flags to use for the request
final EnrichmentFlags? flags;

/// The ranking to use for the request
final String? ranking;

/// The user id to use for the request
final String? userId;

/// The feed group to use for the request
final String feedGroup;
```

## Example Usage
```dart
class FlatActivityListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatFeedCore(
        onErrorWidget: Center(
          child: Text('An error has occurred'),
        ),
        onEmptyWidget: Center(
          child: Text('Nothing here...'),
        ),
        onProgressWidget: Center(
          child: CircularProgressIndicator(),
        ),
        feedBuilder: (context, activities, idx) {
          return YourActivityWidget(activity: activities[idx]);
        }
      ),
    );
  }
}
```

## More Information

For more information on `FlatFeedCore`, check out the [source code]() and the pub.dev [documentation]()