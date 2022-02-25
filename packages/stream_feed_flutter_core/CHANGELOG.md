## 0.7.0 25/02/2022

- fix: `FeedProvider` inherited widget had an issue with the `updateShouldNotify` being triggered everytime. This has been fixed via the llc, being bumped to 0.5.1.
- realtime: version bump. You can now listen to connexion status in the `Subscription` class. For example:
```dart
final subscription = await feed.subscribe();
final subscriptionStatus = subscription.stateStream;
```
- BREAKING: Refactors all of our builder methods to return data and not be opinionated about widgets in Core package
new: Various additional code documentation added


## 0.6.0: 12/01/2022

- BREAKING: bumped llc to 0.5.0, which is a breaking change. We no longer accept a token in the constructor. This change is inspired by Stream Chat, and allows for use cases like multi account management. It allows to instantiate `StreamFeedClient` at the top of your widget tree for example, and connecting the user later.
  
```diff
-  client = StreamFeedClient(apiKey, token: frontendToken);
+  client = StreamFeedClient(apiKey);
+
+  await client.setUser(
+    const User(
+      data: {
+        'name': 'John Doe',
+        'occupation': 'Software Engineer',
+        'gender': 'male'
+      },
+    ),
+    frontendToken,
+  );
```

## 0.5.0: 27/12/2021

- fix: the convenient typedefs on generic classes we provided was breaking autocomplete
- breaking: we renamed some methods
  - `followFlatFeed` -> `followFeed`
  - `unfollowFlatFeed` -> `unfollowFeed`
  - `isFollowingUser` -> `isFollowingFeed`
- fix: export MediaUri
- new: add scrollPhysics parameter to `ReactionListCore`
  
## 0.4.1: 22/12/2021

- new: UploadListCore and UploadController

## 0.4.0+1: 07/12/2021

- Use secure link in readme
- version bump llc

## 0.4.0: 29/10/2021

- first release
