# Official Dart Client for [Stream Activity Feeds](https://getstream.io/activity-feeds/)

>The official Dart client for Stream Activity Feeds, a service for building feed applications. This library can be used on any Dart project and on both mobile and web apps with Flutter.


**Quick Links**

- [Register](https://getstream.io/activity-feeds/trial/) to get an API key for Stream Activity Feeds
- [Stream Activity Feeds UI Kit](https://getstream.io/activity-feeds/ui-kit/)

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_feed/changelog) to see the latest changes in the package.

## Getting started

### Add dependency
Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_feed.svg)](https://pub.dartlang.org/packages/stream_feed)

```yaml
dependencies:
 stream_feed: ^latest-version
```

You should then run `flutter packages get`

## Example Project

There is a detailed Flutter example project in the `example` folder. You can directly run and play on it. 

## Setup API Client

First you need to instantiate a chat client. The Chat client will manage API call, event handling and manage the websocket connection to Stream Chat servers. You should only create the client once and re-use it across your application.

```dart
final client = StreamClient("stream-chat-api-key");
```
## Contributing

### Code conventions

- Make sure that you run `dartfmt` before commiting your code
- Make sure all public methods and functions are well documented

### Running tests 

- run `flutter test`

### Releasing a new version

- update the package version on `pubspec.yaml` and `version.dart`

- add a changelog entry on `CHANGELOG.md`

- run `flutter pub publish` to publish the package

### Watch models and generate JSON code

JSON serialization relies on code generation; make sure to keep that running while you make changes to the library

```bash
flutter pub run build_runner watch
```
