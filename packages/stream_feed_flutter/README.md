# Official Flutter SDK for [Stream Activity Feeds](https://getstream.io/activity-feeds/)

> The official Flutter components for Stream Activity Feeds

**🔗 Quick Links**

- [Register](https://getstream.io/activity-feeds/try-for-free) to get an API key for Stream Activity Feeds
- [Tutorial](https://getstream.io/activity-feeds/sdk/flutter/tutorial/) to learn how to setup a timeline feed, follow other feeds and post new activities.
- [Stream Activity Feeds UI Kit](https://getstream.io/activity-feeds/ui-kit/) to jumpstart your design with notifications and social feeds

## 🛠 (WIP: expect breaking changes) Installation

#### Install as a git depedency

We are doing some polishing before releasing the UI kit, but if you want to have a sneak peek this is how. Next step is to add `stream_feed_flutter` to your dependencies, to do that just open pubspec.yaml and add it inside the dependencies section. Specifying the commit hash will ensure your builds are reproducible in the future.

```yaml
dependencies:   
  stream_feed_flutter:
     git:
       url: https://github.com/GetStream/stream-feed-flutter
       ref: {latest commit hash}
       path: packages/stream_feed_flutter

dependency_overrides:
  stream_feed_flutter_core:
    git:
       url: https://github.com/GetStream/stream-feed-flutter
       ref: {latest commit hash}
       path: packages/stream_feed_flutter_core
```
